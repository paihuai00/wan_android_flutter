import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomSquarePage extends StatefulWidget {
  const BottomSquarePage({Key? key}) : super(key: key);

  @override
  _BottomSquarePageState createState() => _BottomSquarePageState();
}

class _BottomSquarePageState extends State<BottomSquarePage> {
  // final controller = Get.find<BottomSquareViewModel>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Text('333333'),
    );
    // return Container(child: BaseView<BottomSquareViewModel>(
    //   builder: (_) {
    //     return Container(
    //       color: Colors.white,
    //       width: double.infinity,
    //       height: double.infinity,
    //       child: Text('333333'),
    //     );
    //   },
    // ));
  }
}
