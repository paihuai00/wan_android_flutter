import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/system_detail_model.dart';
import 'package:wan_android_flutter/requests/square_request.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/square_system_vm.dart';
import 'package:wan_android_flutter/widgets/square_system_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 10:58 上午
/// @Description:

class SquareDetailPage extends StatefulWidget {
  int pageIndex = 0;

  SquareDetailPage(this.pageIndex, {Key? key}) : super(key: key);

  @override
  _SquareDetailPageState createState() => _SquareDetailPageState();
}

class _SquareDetailPageState extends BaseState<SquareDetailPage> {
  final String _TAG = "SquareDetailPage ";

  late BaseViewModel _viewModel;

  List<SquareSystemWidget> widgetlist = [];

  final List<SystemDetailItem> systemItemListData = [];

  @override
  void initState() {
    super.initState();

    Get.put(SquareSystemViewModel());
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
    return BaseView<SquareSystemViewModel>(
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

    //体系

    BaseDioResponse baseDioResponse = await SquareRequest()
        .getSystemData(cancelToken: _viewModel.cancelToken);

    if (baseDioResponse.ok) {
      SystemDetailModel systemDetailModel =
          SystemDetailModel.fromJson(baseDioResponse.data);

      widgetlist.clear();
      if (systemDetailModel.data != null) {
        systemItemListData.clear();
        systemItemListData.addAll(systemDetailModel.data!);

        widgetlist.addAll(systemItemListData
            .map((e) => SquareSystemWidget(
                  systemDetailItem: e,
                  callBack: (item, children) {
                    if (children == null) {
                      return;
                    }

                    // SystemDetailItem data=systemItemListData.e;
                  },
                ))
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
