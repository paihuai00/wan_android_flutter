import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/global_config.dart';
import 'package:wan_android_flutter/dios/http_client.dart';
import 'package:wan_android_flutter/models/user_coin_model.dart';
import 'package:wan_android_flutter/models/user_model.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';
import 'package:wan_android_flutter/widgets/input_dialog_view.dart';
import 'package:wan_android_flutter/widgets/mine_list_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/1/29 6:12 下午
/// @Description:

class BottomMinePage extends StatefulWidget {
  const BottomMinePage({Key? key}) : super(key: key);

  @override
  _BottomMinePageState createState() => _BottomMinePageState();
}

class _BottomMinePageState extends BaseState<BottomMinePage> {
  UserData? userData;
  UserInfoData? userInfoData;
  int userId = -1;
  String rank = ""; //排名
  int level = -1; //等级

  late final HttpDioClient _httpDioClient = Get.find<HttpDioClient>();

  final _commonHeightBox = const Divider(
    color: Colors.white10,
    height: 10,
  );

  @override
  void initState() {
    super.initState();
    userData = UserManager.getInstance().getUser();

    //退出登录监听
    eventBus.addListener(EventBusKey.loginOut, (arg) {
      userData = null;
      userInfoData = null;
      userId = -1;
      rank = "";
      level = -1;
      setState(() {});
    });

    //事件监听
    eventBus.addListener(EventBusKey.loginSuccess, (arg) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    eventBus.removeListener(EventBusKey.loginOut);
    eventBus.removeListener(EventBusKey.loginSuccess);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLogin(),
              const SizedBox(
                height: 50,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: _buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///登录，头像
  Widget _buildLogin() {
    userData ??= UserManager.getInstance().getUser();
    userInfoData ??= UserManager.getInstance().getUserInfoData();

    if (userData != null) {
      userId = userData!.id ??= -1;
    }

    if (userInfoData != null) {
      level = userInfoData!.level ??= -1;
      rank = userInfoData!.rank ?? "";
    }

    return GestureDetector(
      onTap: () {
        _clickLogin();
      },
      child: Container(
        color: Colors.blue,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: userData == null
                  ? Image.asset(
                      "assets/images/ic_default_head_fill.png",
                      width: 60,
                      height: 60,
                    )
                  : XImage.load(
                      userData!.icon!,
                      width: 60,
                      height: 60,
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            userData == null
                ? Text(
                    '请先登录',
                    style: NormalStyle.getWhite24TextStyle(),
                  )
                : Text(
                    userData!.nickname!,
                    style: NormalStyle.getWhite24TextStyle(),
                  ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "等级: $level",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "排名: $rank",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///点击 - 登录
  _clickLogin() {
    if (UserManager.getInstance().isLogin()) {
      return;
    }
    NavigatorUtil.jump(RouterConfig.loginPage);
  }

  /// 下面列表 item
  _buildList() {
    userData ??= UserManager.getInstance().getUser();
    userInfoData ??= UserManager.getInstance().getUserInfoData();
    String integral = "";
    if (userInfoData != null && userInfoData!.coinCount != null) {
      integral = userInfoData!.coinCount!.toString();
    }

    return Column(
      children: [
        MineListItemView(
          "assets/images/ic_coin.png",
          "我的积分",
          integral: integral,
          mineItemViewClick: (title) {
            NavigatorUtil.jump(RouterConfig.coinPage);
          },
        ),
        _commonHeightBox,
        MineListItemView(
          "assets/images/ic_collection.png",
          "我的收藏",
          mineItemViewClick: (title) {
            NavigatorUtil.jump(RouterConfig.mineCollectionPage);
          },
        ),
        _commonHeightBox,
        MineListItemView(
          "assets/images/ic_article.png",
          "我的文章",
          mineItemViewClick: (title) {},
        ),
        _commonHeightBox,
        MineListItemView(
          "assets/images/ic_web.png",
          "网站",
          mineItemViewClick: (title) {},
        ),
        _commonHeightBox,
        MineListItemView(
          "assets/images/ic_game.png",
          "轻松一下",
          mineItemViewClick: (title) {},
        ),
        _commonHeightBox,
        GestureDetector(
          onLongPress: () {
            if (!GlobalConfig.isDebug) {
              return;
            }
            //长按出代理弹框
            onLongPressedManualInput();
          },
          child: MineListItemView(
            "assets/images/ic_setting.png",
            "设置",
            mineItemViewClick: (title) {
              NavigatorUtil.jump(RouterConfig.settingPage);
            },
          ),
        ),
      ],
    );
  }

  void onLongPressedManualInput() {
    Future.delayed(const Duration(milliseconds: 100), () {
      TextEditingController _vc = TextEditingController();
      showDialog(
          context: context,
          useSafeArea: true,
          // barrierColor: Colors.transparent,
          builder: (context) {
            return InputDialog(
                contentWidget: InputDialogContent(
              title:
                  "请输入代理IP,当前代理为(端口8888)：${_httpDioClient.getCurrentProxy()}",
              okBtnTap: () {
                XToast.show("输入代理ip为${_vc.text}");
                _httpDioClient.setProxy(_vc.text);
              },
              vc: _vc,
              cancelBtnTap: () {},
            ));
          });
    });
  }
}
