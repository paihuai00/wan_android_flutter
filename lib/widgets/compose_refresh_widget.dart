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
        header: ClassicalHeader(
          refreshText: "下拉可以刷新",
          refreshingText: "正在刷新....",
          refreshReadyText: "释放立即刷新",
          refreshedText: "刷新完成",
          refreshFailedText: "刷新失败",
          infoText: "上次更新时间：%T",
          noMoreText: "暂无更多数据",
        ),
        footer: ClassicalFooter(
          loadedText: "加载完成",
          loadReadyText: "释放加载更多",
          loadingText: "加载中....",
          loadFailedText: "加载失败",
          noMoreText: "暂无更多数据",
          infoText: "上次更新时间：%T",
        ),
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
