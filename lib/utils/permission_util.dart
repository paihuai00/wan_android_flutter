import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dialog_util.dart';
import 'log_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/9 11:09 上午
/// @Description: 权限请求封装
///    - 权限自己声明的名称：【PermissionName】
///    - 工具类：【_PermissionUtils】

enum PermissionName {
  camera, //相机
  photos, //相册
  storage, //存储
  unknown
}

extension PermissionNameToString on PermissionName {
  String? getString() {
    switch (index) {
      case 0:
        return "相机";
      case 1:
        return "相册";
      case 2:
        return "存储";
    }
    return null;
  }
}

///回调
typedef OnDeniedCallBack = Function(
    PermissionName permissionName, bool isNeverAsk);
typedef OnGrantCallBack = Function(
    PermissionName permissionName, Object? object);
typedef OnErrorCallBack = Function(
  PermissionName? permissionName,
  Object? object,
);

class XPermission {
  static const String _TAG = "XPermission ";

  //私有构造函数
  XPermission._();

  //保存单例
  static final XPermission _instance = XPermission._();

  static XPermission getInstance() {
    return _instance;
  }

  ///请求单个权限
  Future<bool> request(PermissionName permissionName,
      {OnDeniedCallBack? onDeniedCallBack,
      OnGrantCallBack? onGrantCallBack,
      OnErrorCallBack? onErrorCallBack}) async {
    Permission? needRequestPermission;

    switch (permissionName) {
      case PermissionName.camera:
        needRequestPermission = Permission.camera;
        break;
      case PermissionName.photos:
        needRequestPermission = Permission.photos;
        break;
      case PermissionName.storage:
        needRequestPermission = Permission.storage;
        break;
      default:
        XLog.e(message: "不支持的请求", tag: _TAG);
        break;
    }

    if (needRequestPermission == null) {
      onErrorCallBack?.call(permissionName, "不支持的请求");
      return false;
    }

    ///1,查询当前'权限状态'
    var status = await needRequestPermission.status;

    ///同意
    if (status.isGranted) {
      onGrantCallBack?.call(permissionName, null);
      return true;
    }

    ///拒绝
    if (status.isDenied) {
      //请求权限
      var newStatus = await needRequestPermission.request();
      if (newStatus.isGranted) {
        onGrantCallBack?.call(permissionName, null);
        return false;
      }

      //请求，用户拒绝
      if (newStatus.isPermanentlyDenied) {
        //拒绝且不再询问
        onDeniedCallBack?.call(permissionName, newStatus.isPermanentlyDenied);
        return false;
      }

      if (newStatus.isDenied) {
        //拒绝且不再询问
        onDeniedCallBack?.call(permissionName, newStatus.isPermanentlyDenied);
      }
    }

    return false;
  }

  ///同时请求多个权限
  /// - 回调中，会有权限名称，参考：【PermissionName】
  Future<bool> requests(List<PermissionName> permissions,
      {OnDeniedCallBack? onDeniedCallBack,
      OnGrantCallBack? onGrantCallBack,
      OnErrorCallBack? onErrorCallBack}) async {
    if (permissions.isEmpty) {
      onErrorCallBack?.call(null, "请求权限为null");
      return false;
    }

    var finalResult = true;
    List<Permission> tempPermissions = [];
    for (var name in permissions) {
      tempPermissions.add(PermissionUtils.getRequestPermission(name));
    }

    Map<Permission, PermissionStatus> statuses =
        await tempPermissions.request();

    ///循环判断状态
    statuses.forEach((permission, status) async {
      PermissionName name =
          PermissionUtils.getRequestPermissionName(permission);

      ///1- 请求，同意
      if (status.isGranted) {
        onGrantCallBack?.call(name, null);
        finalResult = finalResult && true;
        return;
      }

      ///2- 拒绝
      if (status.isDenied) {
        var newStatus = await permission.request();

        ///再次请求，同意
        if (newStatus.isGranted) {
          onGrantCallBack?.call(name, null);
          finalResult = finalResult && true;
          return;
        }

        ///拒绝&不在询问
        if (newStatus.isPermanentlyDenied) {
          onDeniedCallBack?.call(name, newStatus.isPermanentlyDenied);
          finalResult = finalResult && false;
          return;
        }

        if (newStatus.isDenied) {
          //拒绝
          onDeniedCallBack?.call(name, newStatus.isPermanentlyDenied);
        }
      }

      ///3- 拒绝&不在询问
      if (status.isPermanentlyDenied) {
        onDeniedCallBack?.call(name, status.isPermanentlyDenied);
        finalResult = finalResult && false;
      }
    });

    return finalResult;
  }
}

///权限工具类
class PermissionUtils {
  static Permission getRequestPermission(PermissionName permissionName) {
    switch (permissionName) {
      case PermissionName.camera:
        return Permission.camera;
      case PermissionName.photos:
        return Permission.photos;
      case PermissionName.storage:
        return Permission.storage;
      default:
        return Permission.unknown;
    }
  }

  static PermissionName getRequestPermissionName(Permission permission) {
    if (permission == Permission.camera) {
      return PermissionName.camera;
    }
    if (permission == Permission.photos) {
      return PermissionName.photos;
    }
    if (permission == Permission.storage) {
      return PermissionName.storage;
    }

    return PermissionName.unknown;
  }

  ///打开用户权限设置
  static void openPermissionSetting() {
    openAppSettings();
  }

  ///打开设置弹框
  static void showOpenSetDialog(BuildContext context, {String? permissionStr}) {
    DialogUtil.showCommonDialog(context,
        content: "App需要使用${permissionStr ?? "该"}权限，请前往设置开启！", leftTab: () {
      Navigator.of(context).pop();
    }, rightTab: () {
      openPermissionSetting();
      Navigator.of(context).pop();
    });
  }
}
