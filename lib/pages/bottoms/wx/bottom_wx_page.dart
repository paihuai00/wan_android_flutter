import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/wx_tab_model.dart';
import 'package:wan_android_flutter/requests/wx_request.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_wx_vm.dart';

import 'wx_detail_page.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomWxPage extends StatefulWidget {
  const BottomWxPage({Key? key}) : super(key: key);

  @override
  _BottomWxPageState createState() => _BottomWxPageState();
}

class _BottomWxPageState extends State<BottomWxPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final String _TAG = "BottomWxPage";

  late BaseViewModel _viewModel;

  late TabController _tabController;

  final List<WxTabItem> _wxTabList = [];

  @override
  void initState() {
    super.initState();
    XLog.d(message: "initState 执行", tag: _TAG);
    Get.put(BottomWxViewModel());

    //绘制完成，请求数据
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      XLog.d(message: "绘制完成,仅执行一次 ${timeStamp.toString()}", tag: _TAG);
      _getTabData();
    });
  }

  @override
  void dispose() {
    XLog.d(message: "dispose 执行", tag: _TAG);
    _viewModel.cancelRequest();
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BaseView<BottomWxViewModel>(
      builder: (vm) {
        _viewModel = vm;
        return Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: _buildTabViews(),
            ),
          ],
        );
      },
    ));
  }

  //tab  数据
  _getTabData() async {
    _viewModel.startLoading(this);

    BaseDioResponse baseDioResponse =
        await WxRequest().getWxTabData(cancelToken: _viewModel.cancelToken);

    if (baseDioResponse.ok) {
      WxTabModel wxTabModel = WxTabModel.fromJson(baseDioResponse.data);

      if (wxTabModel.data != null && wxTabModel.data!.isNotEmpty) {
        _wxTabList.clear();
        _wxTabList.addAll(wxTabModel.data!);
      } else {
        /// 数据请求失败
        XToast.showRequestError();

        _viewModel.pageState = LoadingStateEnum.ERROR;
      }
    }
    _tabController = TabController(length: _wxTabList.length, vsync: this);
    _tabController.addListener(() {
      XLog.d(
          message:
              "_tabController 为: ${_tabController.index}，${_wxTabList[_tabController.index]}",
          tag: _TAG);
    });

    _viewModel.stopLoading(this);

    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildTabBar() {
    if (_wxTabList.isEmpty) return const SizedBox();

    return TabBar(
      onTap: (tab) {
        XLog.d(message: "tab 为: ${tab}", tag: _TAG);
      },
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 14),
      isScrollable: true,
      controller: _tabController,
      labelColor: Colors.blue,
      indicatorWeight: 3,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 6),
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orangeAccent,
      tabs: _wxTabList.map((e) => Tab(text: e.name)).toList(),
    );
  }

  _buildTabViews() {
    if (_wxTabList.isEmpty) return const Text("暂无数据！");

    return TabBarView(
        controller: _tabController,
        children:
            _wxTabList.map((e) => WxDetailPage(e.id.toString())).toList());
  }
}
