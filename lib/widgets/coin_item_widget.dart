import 'package:flutter/material.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/24 11:20 上午
/// @Description: 积分列表 item
class CoinItemWidget extends StatelessWidget {
  String? reason;
  String? time;
  int? coinNum;

  CoinItemWidget({this.reason, this.time, this.coinNum, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reason ?? "",
                style: NormalStyle.getTitleTextStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                time ?? "",
                style: NormalStyle.getSubTitleTextStyle(),
              )
            ],
          )),
          Text(
            "+${coinNum ?? ""}",
            style: NormalStyle.getBlue18TextStyle(),
          )
        ],
      ),
    );
  }
}
