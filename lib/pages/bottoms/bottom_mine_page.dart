import 'package:flutter/material.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/models/user_coin_model.dart';
import 'package:wan_android_flutter/models/user_model.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/event_bus.dart';
import 'package:wan_android_flutter/utils/event_bus_const_key.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';
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
  UserCoinData? userCoinData;
  int userId = -1;
  int rank = -1;

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
      userCoinData = null;
      userId = -1;
      rank = -1;
      setState(() {});
    });
  }

  @override
  void dispose() {
    eventBus.removeListener(EventBusKey.loginOut);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLogin(),
              const SizedBox(
                height: 50,
              ),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  ///登录，头像
  Widget _buildLogin() {
    userData ??= UserManager.getInstance().getUser();

    if (userData != null) {
      userId = userData!.id!;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: userData == null
              ? Image.asset(
                  "assets/images/ic_default_head.png",
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
          width: 10,
        ),
        InkWell(
          onTap: () {
            _clickLogin();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userData == null
                  ? const Text(
                      '请先登录',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  : Text(
                      userData!.nickname!,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "id: $userId",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "排名: $rank",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }

  ///点击 - 登录
  _clickLogin() {
    if (UserManager.getInstance().isLogin()) {
      return;
    }
    NavigatorUtil.jump(RouterConfig.loginPage);
  }

  ///
  _buildList() {
    userData ??= UserManager.getInstance().getUser();
    userCoinData ??= UserManager.getInstance().getUserCoin();
    String rank = "";
    if (userCoinData != null && userCoinData!.rank != null) {
      rank = userCoinData!.rank!;
    }

    return Column(
      children: [
        MineListItemView(
          Icons.padding,
          "我的积分",
          integral: rank,
          mineItemViewClick: (title) {
            NavigatorUtil.jump(RouterConfig.coinPage);
          },
        ),
        _commonHeightBox,
        MineListItemView(
          Icons.star,
          "我的收藏",
          mineItemViewClick: (title) {
            NavigatorUtil.jump(RouterConfig.mineCollectionPage);
          },
        ),
        _commonHeightBox,
        MineListItemView(
          Icons.map,
          "我的文章",
          mineItemViewClick: (title) {},
        ),
        _commonHeightBox,
        MineListItemView(
          Icons.network_wifi,
          "网站",
          mineItemViewClick: (title) {},
        ),
        _commonHeightBox,
        MineListItemView(
          Icons.animation,
          "轻松一下",
          mineItemViewClick: (title) {},
        ),
        _commonHeightBox,
        MineListItemView(
          Icons.settings,
          "设置",
          mineItemViewClick: (title) {
            NavigatorUtil.jump(RouterConfig.settingPage);
          },
        ),
      ],
    );
  }
}
