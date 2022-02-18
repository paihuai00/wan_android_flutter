import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/article_list_model.dart';
import 'package:wan_android_flutter/models/banner_model.dart';
import 'package:wan_android_flutter/requests/home_request.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/net_utils.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_home_vm.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomHomePage extends StatefulWidget {
  BottomHomePage({Key? key}) : super(key: key);

  @override
  _BottomHomePageState createState() => _BottomHomePageState();
}

class _BottomHomePageState extends BaseState<BottomHomePage>
    with TickerProviderStateMixin {
  final String _TAG = "BottomHomePage ";

  late BottomHomeViewModel _viewModel;

  late final List<BannerData> _bannerList = [];

  late final List<ArticleItemData> _dataItemList = [];

  late final SwiperControl _swiperControl = const SwiperControl();

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  //首页列表数据
  int pageIndex = 1;

  var currentPageIsVisible = false;
  var _needRefreshPage = false;

  ArticleItemData? currentClickData;

  @override
  void initState() {
    super.initState();
    Get.put(BottomHomeViewModel()); //getX 注入

    //事件监听
    eventBus.addListener(EventBusKey.loginSuccess, (arg) {
      _needRefreshPage = true; //登录成功，刷新页面
    });
  }

  //绘制完成，请求数据
  @override
  void onBuildFinish() {
    getHomeDatas();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    eventBus.removeListener(EventBusKey.loginSuccess);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BottomHomeViewModel>(
      onTapErrorRefresh: () {
        pageIndex = 1;
        _easyRefreshController.callRefresh();
      },
      builder: (vm) {
        _viewModel = vm;

        //监听当前页面，是否可见
        return VisibilityDetector(
            key: const Key(""),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: EasyRefresh(
                enableControlFinishLoad: true,
                enableControlFinishRefresh: true,
                controller: _easyRefreshController,
                child: ListView(
                  children: [
                    _buildBanner(),
                    const Text(
                      "文章列表",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildList(),
                  ],
                ),
                onRefresh: () async {
                  _onRefresh();
                },
                onLoad: () async {
                  _onLoadMore();
                },
              ),
            ),
            onVisibilityChanged: (info) {
              currentPageIsVisible = info.visibleFraction == 1.0;

              if (_needRefreshPage && currentPageIsVisible) {
                _easyRefreshController.callRefresh();
                _needRefreshPage = false;
              }

              XLog.d(
                  message:
                      "onVisibilityChanged - 当前页面是否可见 $currentPageIsVisible",
                  tag: _TAG);
            });
      },
    );
  }

  //请求首页banner数据
  getHomeDatas() async {
    bool isNetConnect = await NetWorkUtils.isNetWorkAvailable();

    if (!isNetConnect) {
      XToast.showNetError();

      _easyRefreshController.finishRefresh(
          success: false, noMore: pageIndex != 1);
      return;
    }

    //仅当第一页，刷新
    if (pageIndex == 1) {
      _viewModel.startLoading(this);

      BaseDioResponse json = await HomeRequest().getBannerList();
      if (json.ok) {
        BannerDatas bannerDatas = BannerDatas.fromJson(json.data);
        _bannerList.clear();
        _bannerList.addAll(bannerDatas.data);
        XLog.d(
            message:
                "BottomHomeViewModel - getBannerDatas(): " + json.toString());
      } else {
        XLog.d(message: "BottomHomeViewModel - getBannerDatas(): 请求失败");
      }

      _viewModel.stopLoading(this);
    }

    //2,首页列表数据
    BaseDioResponse homeJson = await HomeRequest().getHomeList(pageIndex);

    var hasMore = false;
    if (homeJson.ok) {
      ArticleData homeData = ArticleListDataModel.fromJson(homeJson.data).data!;

      if (homeData.datas != null && homeData.datas!.isNotEmpty) {
        if (pageIndex == 1) {
          _dataItemList.clear();
        }

        if (homeData.datas!.length < 10) {
          hasMore = true;
        }

        _dataItemList.addAll(homeData.datas!);
      } else {
        hasMore = false;
      }
    } else {
      XToast.showRequestError();
      _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
    }

    if (pageIndex == 1) {
      _easyRefreshController.finishRefresh(success: homeJson.ok);
    } else {
      _easyRefreshController.finishLoad(success: homeJson.ok, noMore: !hasMore);
    }

    setState(() {});
  }

  _buildBanner() {
    return SizedBox(
      height: 200,
      child: _bannerList.isEmpty
          ? Image.asset("assets/images/ic_placeholder.png")
          : Swiper(
              itemCount: _bannerList.length,
              itemBuilder: (BuildContext context, int index) {
                return XImage.load(_bannerList[index].imagePath!);
              },
              viewportFraction: 0.8,
              scale: 0.9,
              //指示器
              pagination: const SwiperPagination(),
              control: _swiperControl,
              autoplay: true,
              onTap: (index) {
                BannerData item = _bannerList[index];
                //点击事件回调
                String url = item.url ?? "";
                if (url.isEmpty) {
                  XToast.show("文章链接不存在");
                  return;
                }

                NavigatorUtil.jumpToWeb(url, item.title ?? url);
              },
            ),
    );
  }

  _buildList() {
    if (_dataItemList.isEmpty) {
      return const Center(
        child: Text("暂无数据"),
      );
    }

    return ListView(
      shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
      physics: const NeverScrollableScrollPhysics(), //禁用滑动事件
      children: _dataItemList
          .map((e) => GestureDetector(
                onTap: () {
                  currentClickData = e;
                  String url = currentClickData!.link ?? "";
                  if (url.isEmpty) {
                    XToast.show("文章链接不存在");
                    return;
                  }
                  var arg = {"url": url, "title": currentClickData!.title!};

                  NavigatorUtil.jump(RouterConfig.webViewPage, arguments: arg);
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            (e.prefix == null || e.prefix!.isEmpty)
                                ? const SizedBox()
                                : Text(
                                    e.prefix!,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.redAccent),
                                  ),
                            (e.prefix == null || e.prefix!.isEmpty)
                                ? const SizedBox()
                                : const SizedBox(
                                    width: 10,
                                  ),
                            Text(
                              e.author!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              e.niceDate!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          e.title!,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              e.superChapterName!,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            const Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                currentClickData = e;
                                _viewModel.doCollection(!e.collect!, e, this);
                              },
                              child: NormalStyle.getLikeImage(dealIsLike(e)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  //下拉刷新
  _onRefresh() async {
    pageIndex = 1;
    getHomeDatas();
  }

  //上拉加载
  _onLoadMore() async {
    pageIndex++;
    getHomeDatas();
  }

  //判断是否收藏
  bool dealIsLike(ArticleItemData data) {
    if (currentClickData == null) {
      return data.collect!;
    }
    if (currentClickData!.id == data.id) {
      return _viewModel.isCollection.value;
    }

    return data.collect!;
  }
}
