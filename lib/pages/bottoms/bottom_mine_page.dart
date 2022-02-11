import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/user_model.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
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

class _BottomMinePageState extends State<BottomMinePage> {
  UserData? userData;
  int userId = -1;
  int rank = -1;

  @override
  void initState() {
    super.initState();
    userData = UserManager.getInstance().getUser();
  }

  @override
  void dispose() {
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
    XToast.show("点击了登录");
  }

  ///
  _buildList() {
    userData ??= UserManager.getInstance().getUser();
    int rank = -1;
    if (userData != null) {
      rank = userData!.rank!;
    }

    return Column(
      children: [
        MineListItemView(
          Icons.padding,
          "我的积分",
          integral: rank,
          mineItemViewClick: (title) {},
        ),
        MineListItemView(
          Icons.star,
          "我的收藏",
          integral: rank,
          mineItemViewClick: (title) {},
        ),
        MineListItemView(
          Icons.map,
          "我的文章",
          integral: rank,
          mineItemViewClick: (title) {},
        ),
        MineListItemView(
          Icons.network_wifi,
          "网站",
          integral: rank,
          mineItemViewClick: (title) {},
        ),
        MineListItemView(
          Icons.animation,
          "轻松一下",
          integral: rank,
          mineItemViewClick: (title) {},
        ),
        MineListItemView(
          Icons.settings,
          "设置",
          integral: rank,
          mineItemViewClick: (title) {},
        ),
      ],
    );
  }
}
