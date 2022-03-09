import 'package:flutter/material.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';
import 'package:wan_android_flutter/utils/screen_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/8 4:17 下午
/// @Description:
class DialogUtil {
  /// 标题、确定、取消
  static void showCommonDialog(BuildContext context,
      {String title = "提示",
      String leftContent = "取消",
      String content = "",
      String rightContent = "确定",
      bool autoDismiss = true,
      Function? leftTab,
      Function? rightTab}) {
    showDialog(
        context: context,
        barrierDismissible: autoDismiss,
        builder: (BuildContext context) {
          return Material(
            // color: Colors.transparent,
            // shadowColor: Colors.transparent,
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                width: ScreenUtils.getScreenHeight(context) * 0.4,
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                height: 150,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (content.isEmpty)
                      const SizedBox()
                    else
                      Text(
                        content,
                        style: NormalStyle.getBlack16TextStyle(),
                      ),
                    const Spacer(),
                    if (content.isEmpty)
                      const SizedBox()
                    else
                      const SizedBox(
                        height: 10,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                                child: Center(
                                  child: Text(
                                    leftContent,
                                    style: NormalStyle.getGrey14TextStyle(),
                                  ),
                                ),
                                onTap: () {
                                  //左侧点击事件
                                  if (leftTab != null) {
                                    leftTab.call();
                                  } else {
                                    Navigator.pop(context);
                                  }
                                })),
                        Expanded(
                            child: InkWell(
                                child: Center(
                                  child: Text(
                                    rightContent,
                                    style: NormalStyle.getBlue14TextStyle(),
                                  ),
                                ),
                                onTap: () {
                                  //右侧点击事件
                                  rightTab?.call();
                                })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
