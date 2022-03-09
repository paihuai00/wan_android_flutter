import 'package:permission_handler/permission_handler.dart';

import 'log_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/9 11:09 上午
/// @Description: 权限请求封装

enum PermissionName {
  camera, //相机
  storage, //存储
}

typedef OnDeniedCallBack = Function(bool isNeverAsk);
typedef OnGrantCallBack = Function(Object? object);
typedef OnErrorCallBack = Function(Object? object);

class XPermission {
  static const String _TAG = "XPermission ";

  //私有构造函数
  XPermission._();

  //保存单例
  static final XPermission _instance = XPermission._();

  static XPermission getInstance() {
    return _instance;
  }

  Future request(PermissionName permissionName,
      {OnDeniedCallBack? onDeniedCallBack,
      OnGrantCallBack? onGrantCallBack,
      OnErrorCallBack? onErrorCallBack}) async {
    Permission? needRequestPermission;

    switch (permissionName) {
      case PermissionName.camera:
        needRequestPermission = Permission.camera;
        break;
      case PermissionName.storage:
        needRequestPermission = Permission.storage;
        break;
      default:
        XLog.e(message: "不支持的请求", tag: _TAG);
        break;
    }

    if (needRequestPermission == null) {
      onErrorCallBack?.call("不支持的请求");
      return;
    }

    ///1,查询当前'权限状态'
    var status = await needRequestPermission.status;

    ///同意
    if (status.isGranted) {
      onGrantCallBack?.call(null);
      return;
    }

    ///拒绝
    if (status.isDenied) {
      //请求权限
      var newStatus = await needRequestPermission.request();
      if (newStatus.isGranted) {
        onGrantCallBack?.call(null);
        return;
      }

      //请求，用户拒绝
      if (newStatus.isPermanentlyDenied) {
        //拒绝且不再询问
        onDeniedCallBack?.call(newStatus.isPermanentlyDenied);
        return;
      }

      if (newStatus.isDenied) {
        //拒绝且不再询问
        onDeniedCallBack?.call(newStatus.isPermanentlyDenied);
      }
    }
  }

  ///打开用户权限设置
  openPermissionSetting() {
    openAppSettings();
  }
}
