import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/bottoms/bottom_home_page.dart';
import 'package:wan_android_flutter/pages/bottoms/bottom_mine_page.dart';
import 'package:wan_android_flutter/pages/bottoms/projects/bottom_project_page.dart';
import 'package:wan_android_flutter/pages/bottoms/projects/project_detail_page.dart';
import 'package:wan_android_flutter/pages/bottoms/square/bottom_square_page.dart';
import 'package:wan_android_flutter/pages/bottoms/wx/bottom_wx_page.dart';
import 'package:wan_android_flutter/pages/home_page.dart';
import 'package:wan_android_flutter/pages/launch_pages.dart';
import 'package:wan_android_flutter/view_model/bottom_home_vm.dart';
import 'package:wan_android_flutter/view_model/bottom_project_vm.dart';
import 'package:wan_android_flutter/view_model/bottom_square_vm.dart';
import 'package:wan_android_flutter/view_model/bottom_wx_vm.dart';
import 'package:wan_android_flutter/view_model/launch_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 9:00 下午
/// @Description:

class RouterConfig {
  static String Banner1Demo = "/my_banner1_demo";
  static String Banner2Demo = "/my_banner2_demo";
  static String Banner3Demo = "/my_banner3_demo";

  static String launchPagePath = "/launch_page";

  static String homePage = "/home_page";

  //底部导航
  static String bottomHomePage = "/bottom_home_page";
  static String bottomProjectPage = "/bottom_project_page";
  static String bottomProjectDetailPage = "/bottom_project_detail_page";
  static String bottomSquarePage = "/bottom_square_page";
  static String bottomWxPage = "/bottom_wx_page";
  static String bottomMinePage = "/bottom_mine_page";

  static final List<GetPage> getPages = [
    GetPage(
        name: launchPagePath,
        page: () => LaunchPages(),
        binding: BindingsBuilder(() => {Get.lazyPut(() => LaunchViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    GetPage(
        name: homePage,
        page: () => HomePage(),
        // binding: BindingsBuilder(() => {Get.lazyPut(() => HomeViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    //底部导航
    GetPage(
        name: bottomHomePage,
        page: () => BottomHomePage(),
        binding:
            BindingsBuilder(() => {Get.lazyPut(() => BottomHomeViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    GetPage(
        name: bottomProjectPage,
        page: () => BottomProjectPage(),
        binding: BindingsBuilder(
            () => {Get.lazyPut(() => BottomProjectViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    GetPage(
        name: bottomProjectDetailPage,
        page: () => ProjectDetailPage(""),
        binding: BindingsBuilder(
            () => {Get.lazyPut(() => BottomProjectViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    GetPage(
        name: bottomSquarePage,
        page: () => BottomSquarePage(),
        binding:
            BindingsBuilder(() => {Get.lazyPut(() => BottomSquareViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    GetPage(
        name: bottomWxPage,
        page: () => BottomWxPage(),
        binding:
            BindingsBuilder(() => {Get.lazyPut(() => BottomWxViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),

    GetPage(
        name: bottomMinePage,
        page: () => BottomMinePage(),
        // binding: BindingsBuilder(() => {Get.lazyPut(() => BottomMineViewModel())}),
        transitionDuration: Duration(milliseconds: 0)),
  ];
}
