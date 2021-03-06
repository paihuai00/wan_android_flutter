import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/models/project_detail_model.dart';
import 'package:wan_android_flutter/requests/project_request.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_project_vm.dart';
import 'package:wan_android_flutter/widgets/compose_refresh_widget.dart';
import 'package:wan_android_flutter/widgets/project_card_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/9 2:36 下午
/// @Description: project  详情页面
class ProjectDetailPage extends StatefulWidget {
  String cid = "";

  ProjectDetailPage(this.cid, {Key? key}) : super(key: key);

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends BaseState<ProjectDetailPage> {
  final String _TAG = "ProjectDetailPage";

  late var cid = widget.cid;
  late BaseViewModel _viewModel;
  int pageIndex = 1;

  late CancelToken _cancelToken = CancelToken();

  late final List<ProjectDetailItem> _itemlist = [];

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  @override
  void initState() {
    super.initState();
    XLog.d(message: "获取到的 cid = $cid", tag: _TAG);
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
    return BaseView<BottomProjectViewModel>(builder: (vm) {
      _viewModel = vm;

      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: ComposeRefreshWidget(
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
        ),
      );
    });
  }

  void _getDetailData() async {
    // _viewModel.startLoading(this);

    var baseDioResponse = await ProjectRequest()
        .getDetailList(pageIndex, cid, cancelToken: _cancelToken);

    if (baseDioResponse.ok) {
      ProjectDetailModel projectDetailModel =
          ProjectDetailModel.fromJson(baseDioResponse.data);

      if (pageIndex == 1) {
        _itemlist.clear();
      }

      if (projectDetailModel.data != null &&
          projectDetailModel.data!.datas != null) {
        _itemlist.addAll(projectDetailModel.data!.datas!);
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
        .map((e) => ProjectCardViewWidget(
              e,
              callBack: (item) {
                //点击事件回调
                String url = item.link ?? "";
                if (url.isEmpty) {
                  XToast.show("文章链接不存在");
                  return;
                }
                NavigatorUtil.jumpToWeb(url, item.title ?? url);
              },
            ))
        .toList();
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
