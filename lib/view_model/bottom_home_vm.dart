import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/article_list_model.dart';
import 'package:wan_android_flutter/requests/collection_request.dart';
import 'package:wan_android_flutter/requests/home_request.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 9:05 下午
/// @Description:

class BottomHomeViewModel extends BaseViewModel {
  var isCollection = false.obs;
  late HomeRequest request = HomeRequest();

  @override
  void dispose() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }

    super.dispose();
  }

  //收藏 or 取消收藏
  void doCollection(bool isCollection, ArticleItemData e, State state) async {
    if (!UserManager.getInstance().isLogin()) {
      XToast.showLoginError();
      NavigatorUtil.jump(RouterConfig.loginPage);
      return;
    }

    startLoading(state);

    BaseDioResponse baseDioResponse;
    CollectionRequest request = CollectionRequest();

    if (isCollection) {
      baseDioResponse = await request.doCollection(e.id!.toString(),
          cancelToken: cancelToken);
    } else {
      baseDioResponse = await request.unCollection(e.id!.toString(),
          cancelToken: cancelToken);
    }

    if (baseDioResponse.ok) {
      if (isCollection) XToast.show("收藏成功");
      this.isCollection.value = isCollection;
    } else {
      XToast.showRequestError();
    }

    stopLoading(state);
  }

  //置顶文章
  getTopArticleData({CancelToken? cancelToken}) async {
    BaseDioResponse baseDioResponse =
        await request.getTopArticles(cancelToken: cancelToken);
    return baseDioResponse;
  }

  //列表数据
  getHomeList(int pageIndex, {CancelToken? cancelToken}) async {
    return await request.getHomeList(pageIndex, cancelToken: cancelToken);
  }

  //banner 数据
  getBannerList({CancelToken? cancelToken}) async {
    return await request.getBannerList(cancelToken: cancelToken);
  }
}
