import 'dart:io';

import 'package:dio/dio.dart';
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
import 'package:wan_android_flutter/pages/bottoms/homes/home_web_page_view.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/net_utils.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';
import 'package:wan_android_flutter/utils/permission_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/bottom_home_vm.dart';
import 'package:wan_android_flutter/widgets/compose_refresh_widget.dart';

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

  late final SwiperControl _swiperControl =
      const SwiperControl(color: Colors.transparent);

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  late double padTop = MediaQuery.of(context).padding.top;

  //首页列表数据
  int pageIndex = 1;

  var currentPageIsVisible = false;
  var _needRefreshPage = false;

  //是否显示PageView
  var isShowPageView = false;

  ArticleItemData? currentClickData;

  late final CancelToken _bannerCancelToken = CancelToken();
  late final CancelToken _topCancelToken = CancelToken();

  final normalHeight20SizeBox = const SizedBox(
    height: 20,
  );

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

    if (!_viewModel.cancelToken.isCancelled) {
      _viewModel.cancelToken.cancel();
    }
    if (!_bannerCancelToken.isCancelled) {
      _bannerCancelToken.cancel();
    }
    if (!_topCancelToken.isCancelled) {
      _topCancelToken.cancel();
    }

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
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: _buildContentWidget(),
                    ),
                  ],
                ),
                isShowPageView
                    ? HomeWebPageView(
                        _dataItemList,
                        onHomePageViewCallBack: (index) {
                          setState(() {
                            isShowPageView = false;
                          });
                        },
                      )
                    : const SizedBox()
              ],
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

  _doSearch() {
    NavigatorUtil.jump(RouterConfig.searchPage);
  }

  _buildTopBar() {
    return Container(
      height: 50 + padTop,
      width: double.infinity,
      color: Colors.blue,
      padding: EdgeInsets.only(top: padTop),
      child: Stack(
        children: [
          Positioned(
              left: 10,
              child: SizedBox(
                height: 50,
                width: 50,
                child: InkWell(
                  onTap: () {
                    _doScan();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child:
                        Image(image: AssetImage("assets/images/ic_scan.png")),
                  ),
                ),
              )),
          const Center(
              child: Text(
            "首页",
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
          Positioned(
              right: 10,
              child: InkWell(
                onTap: () {
                  _doSearch();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ///内容 widget
  _buildContentWidget() {
    return ComposeRefreshWidget(
      ListView(
        children: [
          _buildBanner(),
          const Text(
            "文章列表",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildList(),
        ],
      ),
      callBack: (isRefresh) {
        if (isRefresh) {
          _onRefresh();
        } else {
          _onLoadMore();
        }
      },
      controller: _easyRefreshController,
    );
  }

  //请求首页 数据
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

      BaseDioResponse json =
          await _viewModel.getBannerList(cancelToken: _bannerCancelToken);
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

    if (pageIndex == 1) {
      _dataItemList.clear();
    }

    //2.置顶数据（手动解析一下）
    BaseDioResponse topResponse =
        await _viewModel.getTopArticleData(cancelToken: _topCancelToken);
    if (topResponse.ok) {
      Map<String, dynamic> map = topResponse.data;
      if (map.containsKey("data") && map['data'] is List) {
        for (var element in (map['data'] as List)) {
          ArticleItemData tempItem = ArticleItemData.fromJson(element);
          tempItem.isTopArticle = true;
          _dataItemList.add(tempItem);
        }
      }
    }

    //3,首页列表数据
    BaseDioResponse homeJson = await _viewModel.getHomeList(pageIndex,
        cancelToken: _viewModel.cancelToken);

    var hasMore = false;
    if (homeJson.ok) {
      ArticleData homeData = ArticleListDataModel.fromJson(homeJson.data).data!;

      if (homeData.datas != null && homeData.datas!.isNotEmpty) {
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
              // viewportFraction: 0.8,//视差效果
              // scale: 0.9,
              //指示器
              pagination: const SwiperPagination(
                  alignment: Alignment.bottomRight,
                  builder: DotSwiperPaginationBuilder(
                      activeColor: Colors.blue,
                      color: Colors.grey,
                      activeSize: 8,
                      size: 8)),
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
                onLongPress: () {
                  setState(() {
                    isShowPageView = !isShowPageView;
                  });
                },
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
                        normalHeight20SizeBox,
                        Text(
                          e.title!,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        normalHeight20SizeBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //置顶标识
                            e.isTopArticle!
                                ? const Text(
                                    "置顶  ",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  )
                                : const SizedBox(),
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

  ///扫描
  void _doScan() async {
    var requestNameList = [PermissionName.camera];
    if (Platform.isAndroid) {
      requestNameList.add(PermissionName.storage);
    } else if (GetPlatform.isIOS) {
      requestNameList.add(PermissionName.photos);
      requestNameList.add(PermissionName.storage);
    }

    //1，请求相机权限
    var isAllGrant = await XPermission.getInstance().requests(requestNameList,
        onGrantCallBack: (name, obj) {
      XLog.d(message: "onGrantCallBack 权限为：$name, obj = ${obj ?? ""}");
    }, onDeniedCallBack: (name, isNeverAsk) {
      XLog.d(message: "onDeniedCallBack 权限为：$name, isNeverAsk = $isNeverAsk");
      if (isNeverAsk) {
        PermissionUtils.showOpenSetDialog(context,
            permissionStr: name.getString());
      }
    }, onErrorCallBack: (name, obj) {
      XLog.d(message: "onErrorCallBack 权限为：$name, obj = ${obj ?? ""}");
    });

    if (isAllGrant) {
      NavigatorUtil.jump(RouterConfig.scanPage);
    }
  }
}
