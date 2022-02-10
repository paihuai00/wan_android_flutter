import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/nav_detail_model.dart';
import 'package:wan_android_flutter/models/system_detail_model.dart';
import 'package:wan_android_flutter/requests/square_request.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_square_vm.dart';
import 'package:wan_android_flutter/widgets/square_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 10:58 上午
/// @Description:

class SquareDetailPage extends StatefulWidget {
  int pageIndex = 0;

  SquareDetailPage(this.pageIndex, {Key? key}) : super(key: key);

  @override
  _SquareDetailPageState createState() => _SquareDetailPageState();
}

class _SquareDetailPageState extends State<SquareDetailPage>
    with AutomaticKeepAliveClientMixin {
  final String _TAG = "SquareDetailPage ";

  late BaseViewModel _viewModel;

  List<SquareWidget> widgetlist = [];

  @override
  void initState() {
    super.initState();

    Get.put(BottomSquareViewModel());

    //绘制完成，请求数据
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      XLog.d(message: "绘制完成,仅执行一次 ${timeStamp.toString()}", tag: _TAG);
      _getTabData();
    });
  }

  @override
  void dispose() {
    _viewModel.cancelRequest();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BottomSquareViewModel>(builder: (vm) {
      _viewModel = vm;
      return Container(
          child: ListView(
        children: widgetlist,
      ));
    });
  }

  void _getTabData() async {
    _viewModel.startLoading(this);

    late BaseDioResponse baseDioResponse;

    //体系
    if (widget.pageIndex == 0) {
      baseDioResponse = await SquareRequest()
          .getSystemData(cancelToken: _viewModel.cancelToken);

      if (baseDioResponse.ok) {
        SystemDetailModel systemDetailModel =
            SystemDetailModel.fromJson(baseDioResponse.data);

        widgetlist.clear();
        if (systemDetailModel.data != null) {
          widgetlist.addAll(systemDetailModel.data!
              .map((e) => SquareWidget(widget.pageIndex, systemDetailItem: e))
              .toList());
        }
      } else {
        XToast.showRequestError();
        _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
      }
    } else {
      //导航
      baseDioResponse = await SquareRequest()
          .getNaviData(cancelToken: _viewModel.cancelToken);

      if (baseDioResponse.ok) {
        NaviDetailData naviDetailData =
            NaviDetailData.fromJson(baseDioResponse.data);

        widgetlist.clear();
        if (naviDetailData.data != null) {
          widgetlist.addAll(naviDetailData.data!
              .map((e) => SquareWidget(widget.pageIndex, naviDetailItem: e))
              .toList());
        }
      } else {
        XToast.showRequestError();
        _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
      }
    }

    setState(() {});

    _viewModel.stopLoading(this);
  }

  @override
  bool get wantKeepAlive => true;
}
