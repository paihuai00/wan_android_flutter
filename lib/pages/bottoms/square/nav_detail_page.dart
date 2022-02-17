import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/nav_detail_model.dart';
import 'package:wan_android_flutter/requests/square_request.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/square_nav_vm.dart';
import 'package:wan_android_flutter/widgets/square_nav_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 10:58 上午
/// @Description: 导航

class NavDetailPage extends StatefulWidget {
  int pageIndex = 0;

  NavDetailPage(this.pageIndex, {Key? key}) : super(key: key);

  @override
  _NavDetailPageState createState() => _NavDetailPageState();
}

class _NavDetailPageState extends BaseState<NavDetailPage> {
  final String _TAG = "NavDetailPage ";

  late BaseViewModel _viewModel;

  List<SquareNavWidget> widgetlist = [];

  @override
  void initState() {
    super.initState();

    Get.put(SquareNavViewModel());
  }

  @override
  void onBuildFinish() {
    _getTabData();
  }

  @override
  void dispose() {
    _viewModel.cancelRequest();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SquareNavViewModel>(
      builder: (vm) {
        _viewModel = vm;
        return SingleChildScrollView(
          child: Column(
            children: widgetlist,
          ),
        );
      },
      onTapErrorRefresh: () {
        _getTabData();
      },
      onTapEmptyRefresh: () {
        _getTabData();
      },
    );
  }

  void _getTabData() async {
    _viewModel.startLoading(this);

    //导航
    BaseDioResponse baseDioResponse =
        await SquareRequest().getNaviData(cancelToken: _viewModel.cancelToken);

    if (baseDioResponse.ok) {
      NaviDetailData naviDetailData =
          NaviDetailData.fromJson(baseDioResponse.data);

      widgetlist.clear();
      if (naviDetailData.data != null) {
        widgetlist.addAll(naviDetailData.data!
            .map((e) => SquareNavWidget(
                naviDetailItem: e,
                callBack: (item, article) {
                  XToast.show("点击了：${article!.title!}");
                }))
            .toList());
      }
    } else {
      XToast.showRequestError();
      _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
    }

    setState(() {
      eventBus.sendBroadcast(EventBusKey.SquareRequestSuccess);
    });

    _viewModel.stopLoading(this);
  }
}
