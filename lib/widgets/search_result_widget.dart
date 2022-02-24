import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wan_android_flutter/models/search_model.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

import 'compose_refresh_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/22 4:08 下午
/// @Description: 搜索结果

typedef SearchReTryCallBack = Function();
typedef SearchItemClickCallBack = Function<T>(T t);

class SearchResultWidget<T> extends StatefulWidget {
  List<T>? datas;
  ComposeRefreshCallBack? refreshCallBack;
  SearchReTryCallBack? emptyErrorCallBack;
  SearchItemClickCallBack? itemClickCallBack;
  final EasyRefreshController _easyRefreshController;

  SearchResultWidget(this._easyRefreshController,
      {Key? key,
      this.datas,
      this.refreshCallBack,
      this.emptyErrorCallBack,
      this.itemClickCallBack})
      : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  final emptyHint = "暂无数据";
  final emptyIconPath = "assets/images/ic_empty.png";

  final errorHint = "暂无数据";
  final errorIconPath = "assets/images/network_error.png";

  final _commonTextStyle = const TextStyle(fontSize: 16, color: Colors.blue);

  final normalHeightBox = const SizedBox(
    height: 15,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // widget._easyRefreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.datas == null || widget.datas!.isEmpty)
        ? _buildEmptyErrorWidget()
        : SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ComposeRefreshWidget(
              _buildListWidget(),
              controller: widget._easyRefreshController,
              callBack: widget.refreshCallBack,
            ),
          );
  }

  Widget _buildListWidget() {
    List<Widget> widgets = [];

    for (var element in widget.datas!) {
      if (element is SearchItemData) {
        widgets.add(_buildItemWidget(element));
      }
    }

    return ListView(
      children: widgets,
    );
  }

  _buildItemWidget(SearchItemData itemData) {
    return GestureDetector(
      onTap: () {
        widget.itemClickCallBack?.call<SearchItemData>(itemData);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  itemData.author ?? "",
                  style: NormalStyle.getGrey14TextStyle(),
                ),
                _buildTags(itemData),
                const Expanded(child: SizedBox()),
                Text(
                  itemData.niceDate ?? "",
                  style: NormalStyle.getGrey14TextStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Html(
              data: itemData.title ?? "",
            ), //富文本加载
            normalHeightBox,
            Row(
              children: [
                Text(
                  itemData.chapterName ?? "",
                  style: NormalStyle.getGrey14TextStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              height: 0.5,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  //空、错误页面
  _buildEmptyErrorWidget() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: () {
            widget.emptyErrorCallBack?.call();
          },
          child: Column(
            children: [
              Image.asset(
                widget.datas == null ? errorIconPath : emptyIconPath,
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.datas == null ? errorHint : emptyHint,
                style: _commonTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  ///标签
  _buildTags(SearchItemData itemData) {
    if (itemData.tags != null && itemData.tags!.isNotEmpty) {
      SearchItemDataTag tag = itemData.tags![0];

      return Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Text(
          tag.name!,
          style: NormalStyle.getBlue14TextStyle(),
        ),
      );
    }

    return const SizedBox();
  }
}
