import 'package:flutter/material.dart';
import 'package:wan_android_flutter/utils/normal_colors.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 1:45 下午
/// @Description: 封装，通用的 widget

typedef MineItemViewClick = Function(String title);

class MineListItemView extends StatefulWidget {
  MineItemViewClick? mineItemViewClick;
  String iconAssetPath;
  String title;
  String integral; //积分
  Color iconColor;

  MineListItemView(this.iconAssetPath, this.title,
      {Key? key,
      this.mineItemViewClick,
      this.integral = "",
      this.iconColor = Colors.grey})
      : super(key: key);

  @override
  _MineListItemViewState createState() => _MineListItemViewState();
}

class _MineListItemViewState extends State<MineListItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.mineItemViewClick?.call(widget.title);
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.iconAssetPath,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const Expanded(child: SizedBox()),
                widget.integral.isEmpty
                    ? const SizedBox()
                    : Text(
                        "当前积分:${widget.integral}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: NormalColor.color_BDBDBD,
                ),
              ],
            ),
            // const Divider(
            //   color: NormalColor.color_BDBDBD,
            // ),
          ],
        ),
      ),
    );
  }
}
