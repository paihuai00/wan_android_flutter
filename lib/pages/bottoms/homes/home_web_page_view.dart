import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wan_android_flutter/models/article_list_model.dart';
import 'package:wan_android_flutter/pages/webviews/webview_page.dart';
import 'package:wan_android_flutter/utils/log_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/14 2:58 下午
/// @Description: 首页长按弹出的view

typedef OnHomePageViewCallBack = Function(int index);

class HomeWebPageView extends StatefulWidget {
  List<ArticleItemData> dataItemList;
  OnHomePageViewCallBack? onHomePageViewCallBack;

  HomeWebPageView(this.dataItemList, {this.onHomePageViewCallBack, Key? key})
      : super(key: key);

  @override
  _HomeWebPageViewState createState() => _HomeWebPageViewState();
}

class _HomeWebPageViewState extends State<HomeWebPageView> {
  final _TAG = "_HomeWebPageViewState";

  //控制器
  late final SwiperControl _swiperControl =
      const SwiperControl(color: Colors.transparent);

  var currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          _buildWebWidget(),
          const SizedBox(
            height: 10,
          ),
          _buildBottomWidget(),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _getWebWidget(ArticleItemData itemData) {
    return Container(
      color: Colors.white,
      child: WebViewPage(
        title: itemData.title,
        url: itemData.link,
        isOpenFromHome: true,
      ),
    );
  }

  _buildWebWidget() {
    return Expanded(
        child: Swiper(
      itemCount: widget.dataItemList.length,
      itemBuilder: (BuildContext context, int index) {
        return _getWebWidget(widget.dataItemList[index]);
      },
      viewportFraction: 0.8,
      //视差效果
      scale: 0.9,
      loop: false,
      //指示器
      pagination: const SwiperPagination(
          alignment: Alignment.bottomRight,
          builder: DotSwiperPaginationBuilder(
              activeColor: Colors.transparent,
              color: Colors.transparent,
              activeSize: 8,
              size: 8)),
      control: _swiperControl,
      onIndexChanged: (index) {
        currentIndex = index;
        XLog.d(message: "当前web角标为：$index", tag: _TAG);
      },
    ));
  }

  _buildBottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            widget.onHomePageViewCallBack?.call(currentIndex);
          },
          child: const SizedBox(
            width: 50,
            height: 50,
            child: Image(image: AssetImage("assets/images/close_fill.png")),
          ),
        )
      ],
    );
  }
}
