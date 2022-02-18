import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/18 10:25 上午
/// @Description: 刷新框架 封装

typedef ComposeRefreshCallBack = Function(bool isRefresh);

class ComposeRefreshWidget extends StatelessWidget {
  ComposeRefreshCallBack? callBack;

  EasyRefreshController? controller;

  Widget childWidget;

  bool canLoadMore;

  ComposeRefreshWidget(this.childWidget,
      {this.controller, this.callBack, this.canLoadMore = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: EasyRefresh(
        enableControlFinishLoad: true,
        enableControlFinishRefresh: canLoadMore,
        controller: controller,
        child: childWidget,
        onRefresh: () async {
          callBack?.call(true);
        },
        onLoad: () async {
          if (canLoadMore) {
            callBack?.call(false);
          }
        },
      ),
    );
  }
}
