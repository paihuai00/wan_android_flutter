import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/collection_link_model.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/collection_link_vm.dart';
import 'package:wan_android_flutter/widgets/collection_link_item_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 3:31 下午
/// @Description: 链接 detail

class CollectionLinkDetailPage extends StatefulWidget {
  int pageType = 0;

  CollectionLinkDetailPage(this.pageType, {Key? key}) : super(key: key);

  @override
  _CollectionLinkDetailPageState createState() =>
      _CollectionLinkDetailPageState();
}

class _CollectionLinkDetailPageState
    extends BaseState<CollectionLinkDetailPage> {
  final String _TAG = "_CollectionLinkDetailPageState";

  late CollectionLinkViewModel _collectionViewModel;

  late CancelToken cancelToken = CancelToken();

  int pageIndex = 0;

  late final List<CollectionLinkData> _itemLinkList = [];

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  @override
  void initState() {
    super.initState();
    Get.put(CollectionLinkViewModel());
  }

  @override
  void onBuildFinish() {
    super.onBuildFinish();

    getData();
  }

  void getData() async {
    _collectionViewModel.startLoading(this);

    BaseDioResponse baseDioResponse =
        await _collectionViewModel.getCollectionData(pageIndex, widget.pageType,
            cancelToken: cancelToken);

    if (baseDioResponse.ok) {
      var data = baseDioResponse.data;

      CollectionLinkModel model = CollectionLinkModel.fromJson(data);

      _itemLinkList.clear();
      _itemLinkList.addAll(model.data ?? []);

      if (_itemLinkList.isEmpty) {
        _collectionViewModel.refreshRequestState(LoadingStateEnum.EMPTY, this);
      } else {
        _collectionViewModel.stopLoading(this);
      }
    } else {
      XToast.showRequestError();
      _collectionViewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
    }

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
      body: BaseView<CollectionLinkViewModel>(
        builder: (vm) {
          _collectionViewModel = vm;

          return Container(
            color: Colors.white12,
            width: double.infinity,
            height: double.infinity,
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              controller: _easyRefreshController,
              child: ListView(
                children: _buildList(),
              ),
              onRefresh: () async {
                _onRefresh();
              },
            ),
          );
        },
        onTapEmptyRefresh: () {
          _easyRefreshController.callRefresh();
        },
        onTapErrorRefresh: () {
          _easyRefreshController.callRefresh();
        },
      ),
    );
  }

  _buildList() {
    return _itemLinkList
        .map((itemData) => CollectionLinkItemWidget(
              itemData,
              onTap: (data, isUnCollection) {
                int clickIndex = _itemLinkList.indexOf(data);

                XLog.d(
                    message: "点击item = $clickIndex , 是否为取消收藏：$isUnCollection");

                if (!isUnCollection) {
                  String url = data.link ?? "";
                  if (url.isEmpty) {
                    XToast.show("文章链接不存在");
                    return;
                  }

                  NavigatorUtil.jumpToWeb(url, data.name ?? "");
                  return;
                }

                //取消收藏
                dealUnCollection(clickIndex, data);
              },
            ))
        .toList();
  }

  //下拉刷新
  void _onRefresh() {
    getData();
  }
}

void dealUnCollection(int clickIndex, CollectionLinkData data) {}
