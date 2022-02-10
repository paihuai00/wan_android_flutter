import 'package:flutter/material.dart';
import 'package:wan_android_flutter/utils/log_util.dart';

import 'square_detail_page.dart';

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

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabValues.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildTabViews()),
        ],
      ),
    );
  }

  _buildTabBar() {
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
      tabs: _tabValues.map((e) => Tab(text: e)).toList(),
    );
  }

  _buildTabViews() {
    return TabBarView(
        controller: _tabController,
        children: _tabValues
            .map((e) => SquareDetailPage(_tabValues.indexOf(e)))
            .toList());
  }
}
