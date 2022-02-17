import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/pages/collections/collection_link_detail_page.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';

import 'collection_article_detail_page.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 3:29 下午
/// @Description:

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends BaseState<CollectionPage>
    with TickerProviderStateMixin {
  final String _TAG = "CollectionPage ";

  final List<String> _tabValues = ['文章', '网址'];

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
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  _buildTabBar(),
                  Expanded(flex: 1, child: _buildTabViews()),
                ],
              ),
            ),
          ),
          Positioned(
            child: InkWell(
                onTap: () {
                  NavigatorUtil.goBack(context);
                },
                child: const PhysicalShape(
                  clipper: ShapeBorderClipper(
                      shape: CircleBorder(side: BorderSide.none)),
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                )),
            left: 20,
            bottom: 20,
          )
        ],
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
          return _tabValues.indexOf(e) == 1
              ? CollectionLinkDetailPage(_tabValues.indexOf(e))
              : CollectionDetailPage(0);
        }).toList());
  }
}
