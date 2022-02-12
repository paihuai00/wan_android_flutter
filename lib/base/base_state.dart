import 'package:flutter/cupertino.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/11 5:07 下午
/// @Description:
abstract class BaseState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  var _wantKeepAlive = true;

  void setKeepAlive(bool keepLive) {
    setState(() {
      _wantKeepAlive = keepLive;
    });
  }

  @override
  bool get wantKeepAlive => _wantKeepAlive;
}
