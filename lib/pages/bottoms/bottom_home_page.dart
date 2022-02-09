import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/banner_model.dart';
import 'package:wan_android_flutter/models/home_list_model.dart';
import 'package:wan_android_flutter/requests/home_request.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
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

class _BottomHomePageState extends State<BottomHomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final String _TAG = "BottomHomePage ";

  late BaseViewModel _viewModel;

  late final List<BannerData> _bannerList = [];

  late final List<HomeItemData> _dataItemList = [];

  late final SwiperControl _swiperControl = SwiperControl();

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  //首页列表数据
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();

    //getX 注入
    Get.put(BottomHomeViewModel());

    //绘制完成，请求数据
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      XLog.d(message: "绘制完成,仅执行一次 ${timeStamp.toString()}", tag: _TAG);
      getHomeDatas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BottomHomeViewModel>(
      builder: (vm) {
        _viewModel = vm;

        return Container(
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
        );
      },
    );
  }

  //请求首页banner数据
  getHomeDatas() async {
    //仅当第一页，刷新
    if (pageIndex == 1) {
      _viewModel.startLoading(this);

      BaseDioResponse json = await HomeRequest().getBannerList();

      XLog.d(
          message:
              "BottomHomeViewModel - getBannerDatas(): " + json.toString());

      BannerDatas bannerDatas = BannerDatas.fromJson(json.data);

      _bannerList.clear();
      _bannerList.addAll(bannerDatas.data);

      _viewModel.stopLoading(this);
    }

    //2,首页列表数据
    BaseDioResponse homeJson = await HomeRequest().getHomeList(pageIndex);

    HomeData homeData = HomeListData.fromJson(homeJson.data).data!;

    var hasMore = true;
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

    if (pageIndex == 1) {
      _easyRefreshController.finishRefresh(success: true);
    } else {
      _easyRefreshController.finishLoad(success: true, noMore: !hasMore);
    }

    setState(() {});
  }

  _buildBanner() {
    return Container(
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
                  XToast.show("点击了${_dataItemList.indexOf(e)}");
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
                                _doCollection(e);
                              },
                              child: NormalStyle.getLikeImage(e.collect!),
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

  void _doCollection(HomeItemData e) {
    XToast.show("点击了收藏，${e.title}");
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

  @override
  bool get wantKeepAlive => true;
}
