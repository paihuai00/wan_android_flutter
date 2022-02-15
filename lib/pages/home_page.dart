import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/view_model/bottom_project_vm.dart';

import 'bottoms/bottom_home_page.dart';
import 'bottoms/bottom_mine_page.dart';
import 'bottoms/projects/bottom_project_page.dart';
import 'bottoms/square/bottom_square_page.dart';
import 'bottoms/wx/bottom_wx_page.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 9:04 下午
/// @Description:

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _defaultColor = Colors.grey;
  final _selectColor = Colors.blue;

  final String _home = "首页";
  final String _project = "项目";
  final String _square = "广场";
  final String _wx = "公众号";
  final String _mine = "我的";

  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Get.put(BottomProjectViewModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(), // 禁止滑动
            children: <Widget>[
              BottomHomePage(),
              BottomProjectPage(),
              BottomSquarePage(),
              BottomWxPage(),
              BottomMinePage()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            //单击事件
            _controller.jumpToPage(index);
            // print("AAAA   index $index , _currentIndex  = $_currentIndex");
          },
          items: _buildBottomItems(),
        ));
  }

  _buildBottomItems() {
    return [
      //1
      BottomNavigationBarItem(
          title: Text(
            _home,
            style: TextStyle(
                color: _currentIndex == 0 ? _selectColor : _defaultColor),
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
                color: _currentIndex == 1 ? _selectColor : _defaultColor),
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
                color: _currentIndex == 2 ? _selectColor : _defaultColor),
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
                color: _currentIndex == 3 ? _selectColor : _defaultColor),
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
                color: _currentIndex == 4 ? _selectColor : _defaultColor),
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
