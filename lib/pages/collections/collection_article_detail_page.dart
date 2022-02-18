import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/collection_article_model.dart';
import 'package:wan_android_flutter/models/collection_link_model.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/collection_vm.dart';
import 'package:wan_android_flutter/widgets/collection_article_item_widget.dart';
import 'package:wan_android_flutter/widgets/compose_refresh_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 3:31 下午
/// @Description: 收藏 detail

class CollectionDetailPage extends StatefulWidget {
  int pageType = 0;

  CollectionDetailPage(this.pageType, {Key? key}) : super(key: key);

  @override
  _CollectionDetailPageState createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends BaseState<CollectionDetailPage> {
  final String _TAG = "_CollectionDetailPageState";

  late CollectionViewModel _collectionViewModel;

  late CancelToken cancelToken = CancelToken();

  int pageIndex = 0;

  CollectionData? collectionData;

  late final List<CollectionItemData> _itemArticleList = [];

  late final List<CollectionLinkData> _itemLinkList = [];

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  @override
  void initState() {
    super.initState();
    Get.put(CollectionViewModel());
  }

  @override
  void onBuildFinish() {
    super.onBuildFinish();

    _easyRefreshController.callRefresh();
  }

  void getData() async {
    BaseDioResponse baseDioResponse =
        await _collectionViewModel.getCollectionData(pageIndex, widget.pageType,
            cancelToken: cancelToken);

    if (baseDioResponse.ok) {
      var data = baseDioResponse.data;

      CollectionArticleModel model = CollectionArticleModel.fromJson(data);

      collectionData = model.data;
    }

    if (!baseDioResponse.ok || collectionData == null) {
      XToast.showRequestError();
      _collectionViewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
      return;
    }

    if (pageIndex == 0) {
      _itemArticleList.clear();
      _easyRefreshController.finishRefresh(success: baseDioResponse.ok);
    } else {
      _easyRefreshController.finishLoad(success: baseDioResponse.ok);
    }

    _itemArticleList.addAll(collectionData!.datas!);

    setState(() {});
  }

  @override
  void dispose() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<CollectionViewModel>(
        builder: (vm) {
          _collectionViewModel = vm;

          return ComposeRefreshWidget(
            ListView(
              children: _buildList(),
            ),
            callBack: (isRefresh) {
              if (isRefresh) {
                _onRefresh();
              } else {
                _onLoadMore();
              }
            },
            controller: _easyRefreshController,
          );
        },
      ),
    );
  }

  _buildList() {
    return _itemArticleList
        .map((itemData) => CollectionItemWidget(
              itemData,
              onTap: (data, isUnCollection) {
                int clickIndex = _itemArticleList.indexOf(data);

                XLog.d(
                    message: "点击item = $clickIndex , 是否为取消收藏：$isUnCollection");

                if (!isUnCollection) {
                  String url = data.link ?? "";
                  if (url.isEmpty) {
                    XToast.show("文章链接不存在");
                    return;
                  }

                  NavigatorUtil.jumpToWeb(url, data.title ?? "");
                  return;
                }

                //取消收藏
                dealUnCollection(clickIndex, data);
              },
            ))
        .toList();
  }

  void _onRefresh() {
    pageIndex = 0;
    getData();
  }

  void _onLoadMore() {
    pageIndex++;
    getData();
  }
}

void dealUnCollection(int clickIndex, CollectionItemData data) {}
