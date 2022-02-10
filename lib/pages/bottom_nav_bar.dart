import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/utils/log_util.dart';

import 'bottoms/bottom_home_page.dart';
import 'bottoms/bottom_mine_page.dart';
import 'bottoms/projects/bottom_project_page.dart';
import 'bottoms/square/bottom_square_page.dart';
import 'bottoms/wx/bottom_wx_page.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/6 10:08 上午
/// @Description:
///

class BottomState {
  //底部导航栏索引
  RxInt bottomIndex = 0.obs;
}

class GlobalBottomBarController extends GetxController {
  BottomState bottomState = BottomState();

  changeBottomBarIndex(int index) {
    bottomState.bottomIndex.value = index;
    XLog.d(message: "当前索引为：$index");
  }
}

class BottomNavPage extends StatelessWidget {
  //控制器
  late GlobalBottomBarController bottomBarController =
      Get.put(GlobalBottomBarController());

  late BottomState bottomState =
      Get.find<GlobalBottomBarController>().bottomState;

  late List<Widget> bodyPageList = [
    BottomHomePage(),
    BottomProjectPage(),
    BottomSquarePage(),
    BottomWxPage(),
    BottomMinePage()
  ];

  final _defaultColor = Colors.grey;
  final _selectColor = Colors.blue;

  final String _home = "首页";
  final String _project = "项目";
  final String _square = "广场";
  final String _wx = "公众号";
  final String _mine = "我的";

  BottomNavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //主题
        body: Obx(() => bodyPageList[bottomState.bottomIndex.value]),
        //底部导航条
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              // 当前菜单下标
              currentIndex: bottomState.bottomIndex.value,
              // 点击事件,获取当前点击的标签下标
              onTap: (int index) {
                bottomBarController.changeBottomBarIndex(index);
              },
              iconSize: 30.0,
              fixedColor: Colors.red,
              type: BottomNavigationBarType.fixed,
              items: _buildBottomItems(),
            )));
  }

  _buildBottomItems() {
    return [
      //1
      BottomNavigationBarItem(
          title: Text(
            _home,
            style: TextStyle(
                color: bottomState.bottomIndex.value == 0
                    ? _selectColor
                    : _defaultColor),
          ),
          icon: Icon(
            Icons.home,
            color: _defaultColor,
          ),
          activeIcon: Icon(
            Icons.home,
            color: _selectColor,
          )),

      //2
      BottomNavigationBarItem(
          title: Text(
            _project,
            style: TextStyle(
                color: bottomState.bottomIndex.value == 1
                    ? _selectColor
                    : _defaultColor),
          ),
          icon: Icon(
            Icons.bike_scooter,
            color: _defaultColor,
          ),
          activeIcon: Icon(
            Icons.bike_scooter,
            color: _selectColor,
          )),

      //3
      BottomNavigationBarItem(
          title: Text(
            _square,
            style: TextStyle(
                color: bottomState.bottomIndex.value == 2
                    ? _selectColor
                    : _defaultColor),
          ),
          icon: Icon(
            Icons.theater_comedy,
            color: _defaultColor,
          ),
          activeIcon: Icon(
            Icons.theater_comedy,
            color: _selectColor,
          )),

      //4
      BottomNavigationBarItem(
          title: Text(
            _wx,
            style: TextStyle(
                color: bottomState.bottomIndex.value == 3
                    ? _selectColor
                    : _defaultColor),
          ),
          icon: Icon(
            Icons.broken_image_rounded,
            color: _defaultColor,
          ),
          activeIcon: Icon(
            Icons.broken_image_rounded,
            color: _selectColor,
          )),
      //5
      BottomNavigationBarItem(
          title: Text(
            _mine,
            style: TextStyle(
                color: bottomState.bottomIndex.value == 4
                    ? _selectColor
                    : _defaultColor),
          ),
          icon: Icon(
            Icons.broken_image_rounded,
            color: _defaultColor,
          ),
          activeIcon: Icon(
            Icons.broken_image_rounded,
            color: _selectColor,
          )),
    ];
  }
}
