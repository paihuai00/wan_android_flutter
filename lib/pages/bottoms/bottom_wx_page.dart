import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomWxPage extends StatefulWidget {
  const BottomWxPage({Key? key}) : super(key: key);

  @override
  _BottomWxPageState createState() => _BottomWxPageState();
}

class _BottomWxPageState extends State<BottomWxPage> {
  // final controller = Get.find<BottomWxViewModel>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Text('44444'),
    );
    // return Container(child: BaseView<BottomWxViewModel>(
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
