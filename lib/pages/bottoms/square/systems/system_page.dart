import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/models/system_detail_model.dart';
import 'package:wan_android_flutter/pages/bottoms/square/systems/system_detail_page.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_project_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description: 体系

class SystemPage extends StatefulWidget {
  SystemDetailItem? systemDetailItem;
  Children? currentChildren;

  SystemPage({this.systemDetailItem, this.currentChildren, Key? key})
      : super(key: key);

  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends BaseState<SystemPage>
    with TickerProviderStateMixin {
  final String _TAG = "SystemPage";

  late BaseViewModel _viewModel;

  final List<Children> _childrenList = [];

  late TabController _tabController;

  String title = "";

  @override
  void initState() {
    super.initState();
    XLog.d(message: "initState 执行", tag: _TAG);

    if (Get.arguments == null || Get.arguments! is Map) {
      Map map = Get.arguments;
      widget.systemDetailItem =
          SystemDetailItem.fromJson(jsonDecode(map["item"]));
      widget.currentChildren = Children.fromJson(jsonDecode(map["children"]));
    } else {
      XToast.show("数据有误！");
    }
  }

  @override
  void onBuildFinish() {
    _getTabData();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: BaseView<BottomProjectViewModel>(
        builder: (viewModel) {
          _viewModel = viewModel;

          return Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: _buildTabViews(),
              ),
            ],
          );
        },
        onTapErrorRefresh: () {
          _getTabData();
        },
        onTapEmptyRefresh: () {
          _getTabData();
        },
      ),
    );
  }

  //tab  数据
  _getTabData() async {
    _viewModel.startLoading(this);

    if (widget.systemDetailItem == null) {
      /// 数据请求失败
      XToast.show("请求失败,请重试！");
      _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
      setState(() {});
      return;
    }

    title = widget.systemDetailItem!.name ?? "";

    _childrenList.clear();
    if (widget.systemDetailItem!.children == null ||
        widget.systemDetailItem!.children!.isEmpty) {
      _viewModel.refreshRequestState(LoadingStateEnum.EMPTY, this);
    } else {
      _childrenList.addAll(widget.systemDetailItem!.children!);

      _tabController = TabController(length: _childrenList.length, vsync: this);
      _tabController.addListener(() {
        XLog.d(
            message:
                "_tabController 为: ${_tabController.index}，${_childrenList[_tabController.index]}",
            tag: _TAG);
      });
      _viewModel.stopLoading(this);
    }

    setState(() {});
  }

  Widget _buildTabBar() {
    if (_childrenList.isEmpty) return const SizedBox();

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
      tabs: _childrenList.map((e) => Tab(text: e.name)).toList(),
    );
  }

  _buildTabViews() {
    if (_childrenList.isEmpty) return const Text("暂无数据！");

    return TabBarView(
        controller: _tabController,
        children: _childrenList
            .map((e) => SystemDetailPage(e.id.toString()))
            .toList());
  }
}
