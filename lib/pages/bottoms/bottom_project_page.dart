import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/project_tab_model.dart';
import 'package:wan_android_flutter/pages/bottoms/project_detail_page.dart';
import 'package:wan_android_flutter/requests/project_request.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_project_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description: 项目

class BottomProjectPage extends StatefulWidget {
  const BottomProjectPage({Key? key}) : super(key: key);

  @override
  _BottomProjectPageState createState() => _BottomProjectPageState();
}

class _BottomProjectPageState extends State<BottomProjectPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final String _TAG = "BottomProjectPage";

  late BaseViewModel _viewModel;

  final List<ProjectTabItem> _tabProjectList = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    XLog.d(message: "initState 执行", tag: _TAG);

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
    return Scaffold(
      body: BaseView<BottomProjectViewModel>(builder: (viewModel) {
        _viewModel = viewModel;

        return Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: _buildTabViews(),
            ),
          ],
        );
      }),
    );
  }

  //tab  数据
  _getTabData() async {
    _viewModel.startLoading(this);

    BaseDioResponse baseDioResponse = await ProjectRequest()
        .getProjectTabList(cancelToken: _viewModel.cancelToken);

    if (baseDioResponse.ok) {
      ProjectTabData projectTabData =
          ProjectTabData.fromJson(baseDioResponse.data);

      XLog.d(message: "tab数据为: ${projectTabData.data}", tag: _TAG);

      if (projectTabData.data != null && projectTabData.data!.isNotEmpty) {
        _tabProjectList.clear();
        _tabProjectList.addAll(projectTabData.data!);
      } else {
        /// 数据请求失败
        XToast.show("请求失败,请重试！");

        _viewModel.pageState = LoadingStateEnum.ERROR;
      }
    }
    _tabController = TabController(length: _tabProjectList.length, vsync: this);
    _tabController.addListener(() {
      XLog.d(
          message:
              "_tabController 为: ${_tabController.index}，${_tabProjectList[_tabController.index]}",
          tag: _TAG);
    });

    _viewModel.stopLoading(this);

    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildTabBar() {
    if (_tabProjectList.isEmpty) return SizedBox();

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
      tabs: _tabProjectList.map((e) => Tab(text: e.name)).toList(),
    );
  }

  _buildTabViews() {
    if (_tabProjectList.isEmpty) return const Text("暂无数据！");

    return TabBarView(
        controller: _tabController,
        children: _tabProjectList
            .map((e) => ProjectDetailPage(e.id.toString()))
            .toList());
  }
}
