import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:33 下午
/// @Description:
class BaseViewModel extends GetxController {
  CancelToken cancelToken = CancelToken();

  //取消网络请求方法
  void cancelRequest() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  LoadingStateEnum pageState = LoadingStateEnum.IDLE;

  bool loadingBackground = false; // loading 是否携带背景。

  void refreshRequestState(LoadingStateEnum state, State ctx,
      {loadingBg = false}) {
    if (ctx.mounted) {
      if (state != pageState) {
        pageState = state;
        loadingBackground = loadingBg;
        update();
      }
    }
  }

  void startLoading(State state) {
    refreshRequestState(LoadingStateEnum.LOADING, state);
  }

  void stopLoading(State state) {
    refreshRequestState(LoadingStateEnum.IDLE, state);
  }
}

enum LoadingStateEnum { LOADING, IDLE, ERROR }
