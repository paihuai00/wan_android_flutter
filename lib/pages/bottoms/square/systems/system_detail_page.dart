import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/article_list_model.dart';
import 'package:wan_android_flutter/requests/collection_request.dart';
import 'package:wan_android_flutter/requests/system_request.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/system_detail_vm.dart';
import 'package:wan_android_flutter/widgets/home_card_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/9 2:36 下午
/// @Description: 体系  详情页面
class SystemDetailPage extends StatefulWidget {
  String cid = "";

  SystemDetailPage(this.cid, {Key? key}) : super(key: key);

  @override
  _SystemDetailPageState createState() => _SystemDetailPageState();
}

class _SystemDetailPageState extends BaseState<SystemDetailPage> {
  final String _TAG = "SystemDetailPage";

  late var cid = widget.cid;
  late BaseViewModel _viewModel;
  int pageIndex = 0;

  late final CancelToken _cancelToken = CancelToken();

  late final CancelToken _collectionCancelToken = CancelToken();

  late final List<ArticleItemData> _itemlist = [];

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  @override
  void initState() {
    super.initState();
    XLog.d(message: "获取到的 cid = $cid", tag: _TAG);

    Get.put(SystemDetailViewModel());
  }

  @override
  void onBuildFinish() {
    _easyRefreshController.callRefresh();
  }

  @override
  void dispose() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SystemDetailViewModel>(builder: (vm) {
      _viewModel = vm;

      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: EasyRefresh(
          enableControlFinishLoad: true,
          enableControlFinishRefresh: true,
          controller: _easyRefreshController,
          child: ListView(
            children: _buildList(),
          ),
          onRefresh: () async {
            _onRefresh();
          },
          onLoad: () async {
            _onLoadMore();
          },
        ),
      );
    });
  }

  void _getDetailData() async {
    // _viewModel.startLoading(this);

    var baseDioResponse = await SystemRequest()
        .getDetailList(pageIndex, cid, cancelToken: _cancelToken);

    if (baseDioResponse.ok) {
      ArticleListDataModel model =
          ArticleListDataModel.fromJson(baseDioResponse.data);

      if (pageIndex == 1) {
        _itemlist.clear();
      }

      if (model.data != null && model.data!.datas != null) {
        _itemlist.addAll(model.data!.datas!);
      }
    } else {
      XLog.d(message: "数据获取失败 $cid", tag: _TAG);
    }

    if (pageIndex == 1) {
      _easyRefreshController.finishRefresh(success: baseDioResponse.ok);
    } else {
      _easyRefreshController.finishLoad(success: baseDioResponse.ok);
    }

    setState(() {});

    // _viewModel.stopLoading(this);
  }

  ///构建列表 item
  _buildList() {
    return _itemlist
        .map((e) => HomeCardWidget(
              item: e,
              callBack: (item, isCollection) {
                //点击事件回调

                if (!isCollection) {
                  String url = item!.link ?? "";
                  if (url.isEmpty) {
                    XToast.show("文章链接不存在");
                    return;
                  }
                  NavigatorUtil.jumpToWeb(url, item.title ?? url);
                } else {
                  doCollection(!item!.collect!, item, this);
                }
              },
            ))
        .toList();
  }

  //收藏 or 取消收藏
  void doCollection(bool isCollection, ArticleItemData e, State state) async {
    _viewModel.startLoading(state);

    BaseDioResponse baseDioResponse;
    CollectionRequest request = CollectionRequest();

    if (isCollection) {
      baseDioResponse = await request.doCollection(e.id!.toString(),
          cancelToken: _collectionCancelToken);
    } else {
      baseDioResponse = await request.unCollection(e.id!.toString(),
          cancelToken: _collectionCancelToken);
    }

    if (baseDioResponse.ok) {
      if (isCollection) XToast.show("收藏成功");

      int index = _itemlist.indexOf(e);
      _itemlist[index].collect = isCollection;
    } else {
      XToast.showRequestError();
    }

    _viewModel.stopLoading(state);

    setState(() {});
  }

  void _onRefresh() {
    pageIndex = 1;
    _getDetailData();
  }

  //上拉加载
  _onLoadMore() async {
    pageIndex++;
    _getDetailData();
  }
}
