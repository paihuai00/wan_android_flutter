import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/bottoms/bottom_home_page.dart';
import 'package:wan_android_flutter/pages/bottoms/bottom_mine_page.dart';
import 'package:wan_android_flutter/pages/bottoms/projects/bottom_project_page.dart';
import 'package:wan_android_flutter/pages/bottoms/projects/project_detail_page.dart';
import 'package:wan_android_flutter/pages/bottoms/square/bottom_square_page.dart';
import 'package:wan_android_flutter/pages/bottoms/square/systems/system_page.dart';
import 'package:wan_android_flutter/pages/bottoms/wx/bottom_wx_page.dart';
import 'package:wan_android_flutter/pages/collections/mine_collection_pages.dart';
import 'package:wan_android_flutter/pages/home_page.dart';
import 'package:wan_android_flutter/pages/launch_pages.dart';
import 'package:wan_android_flutter/pages/mines/coin_page.dart';
import 'package:wan_android_flutter/pages/mines/login_page.dart';
import 'package:wan_android_flutter/pages/mines/register_page.dart';
import 'package:wan_android_flutter/pages/mines/setting_page.dart';
import 'package:wan_android_flutter/pages/searchs/search_page.dart';
import 'package:wan_android_flutter/pages/webviews/webview_page.dart';
import 'package:wan_android_flutter/routers/login_interceptor_router.dart';
import 'package:wan_android_flutter/view_model/bottom_home_vm.dart';
import 'package:wan_android_flutter/view_model/bottom_project_vm.dart';
import 'package:wan_android_flutter/view_model/bottom_wx_vm.dart';
import 'package:wan_android_flutter/view_model/coin_viewmodel.dart';
import 'package:wan_android_flutter/view_model/launch_vm.dart';
import 'package:wan_android_flutter/view_model/login_regist_vm.dart';
import 'package:wan_android_flutter/view_model/search_vm.dart';
import 'package:wan_android_flutter/view_model/square_system_vm.dart';

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

  static String loginPage = "/login_page";
  static String registerPage = "/register_page";
  static String settingPage = "/set_page";
  static String webViewPage = "/profile_webview";
  static String mineCollectionPage = "/mine_collection";
  static String coinPage = "/mine_coin";

  static String systemPage = "/system_page";
  static String searchPage = "/search_page";

  static final List<GetPage> getPages = [
    GetPage(
      name: launchPagePath,
      page: () => LaunchPages(),
      binding: BindingsBuilder(() => {Get.lazyPut(() => LaunchViewModel())}),
    ),

    GetPage(
      name: homePage,
      page: () => HomePage(),
      // binding: BindingsBuilder(() => {Get.lazyPut(() => HomeViewModel())}),
    ),

    //底部导航
    GetPage(
      name: bottomHomePage,
      page: () => BottomHomePage(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => BottomHomeViewModel())}),
    ),

    GetPage(
      name: bottomProjectPage,
      page: () => BottomProjectPage(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => BottomProjectViewModel())}),
    ),

    GetPage(
      name: bottomProjectDetailPage,
      page: () => ProjectDetailPage(""),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => BottomProjectViewModel())}),
    ),

    GetPage(
      name: bottomSquarePage,
      page: () => BottomSquarePage(),
      binding:
          BindingsBuilder(() => {Get.lazyPut(() => SquareSystemViewModel())}),
    ),

    GetPage(
      name: bottomWxPage,
      page: () => BottomWxPage(),
      binding: BindingsBuilder(() => {Get.lazyPut(() => BottomWxViewModel())}),
    ),

    GetPage(
      name: bottomMinePage,
      page: () => BottomMinePage(),
      // binding: BindingsBuilder(() => {Get.lazyPut(() => BottomMineViewModel())}),
    ),

    GetPage(
        name: loginPage,
        page: () => LoginPage(),
        binding: BindingsBuilder(
            () => {Get.lazyPut(() => LoginRegisterViewModel())})),

    GetPage(
        name: registerPage,
        page: () => RegisterPage(),
        binding: BindingsBuilder(
            () => {Get.lazyPut(() => LoginRegisterViewModel())})),

    GetPage(
        name: settingPage,
        page: () => SettingPage(),
        binding: BindingsBuilder(
            () => {Get.lazyPut(() => LoginRegisterViewModel())}),
        middlewares: [LoginInterceptorRouter()]),
    GetPage(
      name: webViewPage,
      page: () => WebViewPage(),
      binding: BindingsBuilder(() => {}),
    ),
    GetPage(
        name: mineCollectionPage,
        page: () => CollectionPage(),
        binding: BindingsBuilder(() => {}),
        middlewares: [LoginInterceptorRouter()]),

    GetPage(name: systemPage, page: () => SystemPage()),

    GetPage(
        name: searchPage,
        page: () => const SearchPage(),
        binding: BindingsBuilder(() => {Get.lazyPut(() => SearchViewModel())})),

    GetPage(
        name: coinPage,
        page: () => const CoinPage(),
        binding: BindingsBuilder(() => {Get.lazyPut(() => CoinViewModel())}),
        middlewares: [LoginInterceptorRouter()]),
  ];
}
