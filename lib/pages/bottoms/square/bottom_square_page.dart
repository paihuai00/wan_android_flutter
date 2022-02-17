import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/log_util.dart';

import 'nav_detail_page.dart';
import 'system_detail_page.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomSquarePage extends StatefulWidget {
  const BottomSquarePage({Key? key}) : super(key: key);

  @override
  _BottomSquarePageState createState() => _BottomSquarePageState();
}

class _BottomSquarePageState extends State<BottomSquarePage>
    with TickerProviderStateMixin {
  final String _TAG = "BottomSquarePage ";

  final List<String> _tabValues = ['体系', '导航'];

  late TabController _tabController;

  var currentPageIsVisible = false;
  var _needRefreshPage = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabValues.length, vsync: this);

    //事件监听
    eventBus.addListener(EventBusKey.SquareRequestSuccess, (arg) {
      _needRefreshPage = true; //登录成功，刷新页面
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    eventBus.removeListener(EventBusKey.SquareRequestSuccess);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: VisibilityDetector(
            key: const Key(""),
            child: Column(
              children: [
                _buildTabBar(),
                Expanded(flex: 1, child: _buildTabViews()),
              ],
            ),
            onVisibilityChanged: (info) {
              currentPageIsVisible = info.visibleFraction == 1.0;

              if (_needRefreshPage && currentPageIsVisible) {
                setState(() {
                  //刷新一下页面
                });
                _needRefreshPage = false;
              }

              XLog.d(
                  message:
                      "onVisibilityChanged - 当前页面是否可见 $currentPageIsVisible",
                  tag: _TAG);
            }),
      ),
    );
  }

  _buildTabBar() {
    return TabBar(
      onTap: (tab) {
        XLog.d(message: "tab 为: ${tab}", tag: _TAG);
        _tabController.animateTo(tab);
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
      tabs: _tabValues.map((e) => Tab(text: e)).toList(),
    );
  }

  _buildTabViews() {
    return TabBarView(
        controller: _tabController,
        children: _tabValues.map((e) {
          int index = _tabValues.indexOf(e);
          if (index == 0) {
            return SquareDetailPage(index);
          } else {
            return NavDetailPage(index);
          }
        }).toList());
  }
}
