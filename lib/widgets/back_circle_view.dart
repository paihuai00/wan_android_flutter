import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/17 1:25 下午
/// @Description: 带点击事件的 返回按钮
class BackCircleView extends StatelessWidget {
  final Widget defaultChild = const Icon(
    Icons.arrow_back_ios,
    color: Colors.white,
  );

  final Color defaultColor = Colors.blue;

  Function? onTab;
  Widget? child;
  Color? color;

  BackCircleView({Key? key, this.onTab, this.color, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTab?.call();
      },
      child: PhysicalShape(
        clipper: const ShapeBorderClipper(
            shape: CircleBorder(side: BorderSide.none)),
        color: color ?? defaultColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: child ?? defaultChild,
        ),
      ),
      highlightColor: Colors.lightBlueAccent,
    );
  }
}
