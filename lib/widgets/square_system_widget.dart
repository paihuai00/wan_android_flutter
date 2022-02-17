import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/nav_detail_model.dart';
import 'package:wan_android_flutter/models/system_detail_model.dart';
import 'package:wan_android_flutter/utils/normal_colors.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 2:21 下午
/// @Description:

class SquareSystemWidget extends StatefulWidget {
  SystemDetailItem? systemDetailItem;
  SystemCallBack? callBack;
  SquareSystemWidget({Key? key, this.systemDetailItem, this.callBack})
      : super(key: key);

  @override
  _SquareSystemWidgetState createState() => _SquareSystemWidgetState();
}

class _SquareSystemWidgetState extends State<SquareSystemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: _buildList(),
          ),
        ],
      ),
    );
  }

  _buildTitle() {
    String title = widget.systemDetailItem!.name ?? "";

    return Text(
      title,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }

  _buildList() {
    List<Children> childList = widget.systemDetailItem!.children!;

    return childList
        .map(
          (children) => _getCommonWidget(children.name!, children: children),
        )
        .toList();
  }

  Widget _getCommonWidget(String title,
      {Articles? article, Children? children}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: const BoxDecoration(
        color: NormalColor.color_BDBDBD,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          _onItemClick(children, article);
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  ///回调
  _onItemClick(Children? children, Articles? articles) {
    widget.callBack?.call(widget.systemDetailItem, children);
  }
}

typedef SystemCallBack = Function(SystemDetailItem? item, Children? children);
