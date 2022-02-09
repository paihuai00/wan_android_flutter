import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomMinePage extends StatefulWidget {
  const BottomMinePage({Key? key}) : super(key: key);

  @override
  _BottomMinePageState createState() => _BottomMinePageState();
}

class _BottomMinePageState extends State<BottomMinePage> {
  // final controller = Get.find<BottomMineViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Text('55555'),
    );
    // return Container(child: BaseView<BottomMineViewModel>(
    //   builder: (_) {
    //     return Container(
    //       color: Colors.white,
    //       width: double.infinity,
    //       height: double.infinity,
    //       child: Text('55555'),
    //     );
    //   },
    // ));
  }
}
