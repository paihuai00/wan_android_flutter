import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/search_model.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';
import 'package:wan_android_flutter/utils/sp_utils.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/view_model/search_vm.dart';
import 'package:wan_android_flutter/widgets/search_bar_widget.dart';
import 'package:wan_android_flutter/widgets/search_result_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/22 11:05 上午
/// @Description: 搜索
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage> {
  late final _TAG = "SearchPage ";

  late final _viewModel = Get.find<SearchViewModel>();

  late final hotKeyWord = [
    '面试',
    '动画',
    '自定义View',
    '性能优化',
    'gradle',
    'Camera相机',
    '代码混淆',
    '加固'
  ];

  late final hotSearch = "热门搜索";
  late final historySearch = "历史搜索";
  late final clear = " 清除 ";

  late final historyKeyWord = <String, dynamic>{};

  //列表数据
  late final itemDataList = <SearchItemData>[];

  //列表
  int pageIndex = 0;

  var lastSearchKeyWord = "";

  late EasyRefreshController _easyRefreshController;

  //是否显示，搜索结果
  late var isShowResultWidget = false;

  late final ButtonStyle _buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white12),
      padding:
          MaterialStateProperty.all(const EdgeInsets.fromLTRB(15, 5, 15, 5)),
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)))));

  @override
  void initState() {
    super.initState();

    _easyRefreshController = EasyRefreshController();
  }

  @override
  void onBuildFinish() {
    _getHistoryData();
  }

  @override
  void dispose() {
    if (!_viewModel.cancelToken.isCancelled) {
      _viewModel.cancelToken.cancel();
    }

    _easyRefreshController.dispose();

    super.dispose();
  }

  //本地读取，历史数据
  _getHistoryData() {
    String mapJson = SpUtil.getInstance().getString(SpUtil.historySearchKey);

    var map = jsonDecode(mapJson);

    if (map is! Map<String, dynamic>) {
      XLog.d(message: "sp 读取数据有误，", tag: _TAG);
      return;
    }

    historyKeyWord.addAll(map);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<SearchViewModel>(builder: (vm) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              //搜索顶部 搜索栏
              SearchBarWidget(
                keyWord: lastSearchKeyWord,
                backCallBack: () {
                  NavigatorUtil.goBack(context);
                },
                searchClickCallBack: (searchContent) {
                  ///点击搜索
                  itemDataList.clear();
                  if (searchContent.isEmpty) {
                    lastSearchKeyWord = "";
                    isShowResultWidget = false;
                    setState(() {});
                    return;
                  }
                  _viewModel.startLoading(this);

                  _doSearch(searchContent);
                },
              ),
              Expanded(
                  child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: _buildSearchWidget(),
              )),
            ],
          ),
        );
      }),
    );
  }

  //搜索内容
  _buildSearchWidget() {
    //解决，清除result widget后，controller 被回收的 bug。
    _easyRefreshController = EasyRefreshController();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHotSearch(),
            const SizedBox(
              height: 20,
            ),
            _buildHistorySearch()
          ],
        ),
        isShowResultWidget ? _buildResultWidget() : const SizedBox(),
      ],
    );
  }

  //搜索
  void _doSearch(String str) async {
    lastSearchKeyWord = str;

    _dealHistorySpKey(str);

    //网络请求
    BaseDioResponse baseDioResponse = await _viewModel
        .getSearchData(pageIndex, str, cancelToken: _viewModel.cancelToken);

    List<SearchItemData> _tempList = [];

    if (baseDioResponse.ok) {
      SearchModel searchModel = SearchModel.fromJson(baseDioResponse.data);

      if (searchModel.data != null && searchModel.data!.datas != null) {
        _tempList.addAll(searchModel.data!.datas!);
      } else {
        XLog.d(message: "数据不存在！", tag: _TAG);
      }
    } else {
      XLog.d(message: "请求失败！", tag: _TAG);
    }

    if (pageIndex == 0) {
      _easyRefreshController.finishRefresh(
          success: baseDioResponse.ok, noMore: _tempList.length < 10);
    } else {
      _easyRefreshController.finishLoad(
          success: baseDioResponse.ok, noMore: _tempList.length < 10);
    }

    itemDataList.addAll(_tempList);

    isShowResultWidget = true;

    _viewModel.stopLoading(this);

    setState(() {});
  }

  //不包含的话，添加 并加入到 sp 中存储
  _dealHistorySpKey(String key) {
    if (historyKeyWord.containsKey(key)) {
      return;
    }
    historyKeyWord.putIfAbsent(key, () => "");

    SpUtil.getInstance()
        .set(SpUtil.historySearchKey, jsonEncode(historyKeyWord));
  }

  _buildHotSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotSearch,
          style: NormalStyle.getBlue18TextStyle(),
        ),
        Wrap(
          children: hotKeyWord
              .map((e) => _getCommonTextButton(e, () {
                    _doSearch(e);
                  }))
              .toList(),
          // alignment: WrapAlignment.spaceBetween,
        )
      ],
    );
  }

  _buildHistorySearch() {
    return historyKeyWord.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    historySearch,
                    style: NormalStyle.getBlue18TextStyle(),
                  )),
                  TextButton(
                    onPressed: () {
                      historyKeyWord.clear();
                      //清除 本地数据
                      SpUtil.getInstance().set(SpUtil.historySearchKey, "");
                      setState(() {});
                    },
                    style: _buttonStyle,
                    child: Text(
                      clear,
                      style: NormalStyle.getGrey18TextStyle(),
                    ),
                  )
                ],
              ),
              Wrap(
                children: _getHistoryWidgets(),
                // alignment: WrapAlignment.spaceBetween,
              )
            ],
          );
  }

  //通过map，构建 history widgets
  _getHistoryWidgets() {
    final List<Widget> widgets = <Widget>[];

    historyKeyWord.forEach((key, value) {
      widgets.add(_getCommonTextButton(key, () {
        _doSearch(key);
      }));
    });

    return widgets;
  }

  //搜索结果
  _buildResultWidget() {
    return SearchResultWidget<SearchItemData>(
      _easyRefreshController,
      datas: itemDataList,
      refreshCallBack: (isRefresh) {
        if (lastSearchKeyWord.isEmpty || !isShowResultWidget) {
          XLog.d(
              message:
                  "关键词：${lastSearchKeyWord.isEmpty} , 结果页面是否显示: $isShowResultWidget",
              tag: _TAG);
          if (pageIndex == 0) {
            _easyRefreshController.finishRefresh(success: false, noMore: true);
          } else {
            _easyRefreshController.finishLoad(success: false, noMore: true);
          }
          return;
        }

        if (isRefresh) {
          pageIndex = 0;
          itemDataList.clear();
        } else {
          pageIndex++;
        }

        _doSearch(lastSearchKeyWord);
      },
      emptyErrorCallBack: () {
        //
        _viewModel.startLoading(this);

        _doSearch(lastSearchKeyWord);
      },
      itemClickCallBack: <T>(itemData) {
        if (itemData is SearchItemData) {
          //点击事件回调
          String url = itemData.link ?? "";
          if (url.isEmpty) {
            XToast.show("文章链接不存在");
            return;
          }

          NavigatorUtil.jumpToWeb(url, itemData.title ?? url);
        } else {
          XToast.show("文章链接不存在");
        }
      },
    );
  }

  //通用的 tb
  TextButton _getCommonTextButton(String contentStr, VoidCallback onpress) {
    return TextButton(
      onPressed: onpress,
      style: _buttonStyle,
      child: Text(
        contentStr,
        style: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
    );
  }
}
