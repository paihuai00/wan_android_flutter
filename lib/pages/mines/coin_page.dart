import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/base/base_view.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/dios/http_response.dart';
import 'package:wan_android_flutter/models/coin_model.dart';
import 'package:wan_android_flutter/utils/time_util.dart';
import 'package:wan_android_flutter/utils/user_manager.dart';
import 'package:wan_android_flutter/view_model/coin_viewmodel.dart';
import 'package:wan_android_flutter/widgets/coin_item_widget.dart';
import 'package:wan_android_flutter/widgets/compose_refresh_widget.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/24 10:30 上午
/// @Description: 我的积分

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends BaseState<CoinPage> {
  final _TAG = "_CoinPageState";

  late String _totalCoin;

  late CancelToken cancelToken = CancelToken();

  late final EasyRefreshController _easyRefreshController =
      EasyRefreshController();

  late final List<CoinItemData> _itemlist = [];

  int pageIndex = 0;

  late CoinViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _totalCoin = UserManager.getInstance().getUser()!.coinCount!.toString();
  }

  @override
  void onBuildFinish() {
    _easyRefreshController.callRefresh();
  }

  @override
  void dispose() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }

    _easyRefreshController.dispose();

    super.dispose();
  }

  void getData() async {
    BaseDioResponse baseDioResponse =
        await _viewModel.getCoinListData(pageIndex);

    if (baseDioResponse.ok) {
      CoinModel coinModel = CoinModel.fromJson(baseDioResponse.data);

      if (coinModel.data != null && coinModel.data!.datas != null) {
        _itemlist.addAll(coinModel.data!.datas!);
      }

      if (pageIndex == 0 && _itemlist.isEmpty) {
        _viewModel.refreshRequestState(LoadingStateEnum.EMPTY, this);
      }
    } else {
      if (pageIndex == 0) {
        _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
      }
    }

    if (pageIndex == 0) {
      if (!baseDioResponse.ok) {
        _viewModel.refreshRequestState(LoadingStateEnum.ERROR, this);
      }
      _easyRefreshController.finishRefresh(
          success: baseDioResponse.ok, noMore: !baseDioResponse.ok);
    } else {
      _easyRefreshController.finishLoad(
          success: baseDioResponse.ok, noMore: !baseDioResponse.ok);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "我的积分",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: BaseView<CoinViewModel>(
        builder: (vm) {
          _viewModel = vm;
          return Column(
            children: [
              Container(
                color: Colors.blue,
                height: 150,
                child: Center(
                  child: Text("积分：$_totalCoin",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white)),
                ),
              ),
              Expanded(
                  child: ComposeRefreshWidget(
                ListView(
                  children: _buildList(),
                ),
                callBack: (isRefresh) {
                  if (isRefresh) {
                    _onRefresh();
                  } else {
                    _onLoadMore();
                  }
                },
                controller: _easyRefreshController,
              ))
            ],
          );
        },
      ),
    );
  }

  _buildList() {
    return _itemlist
        .map((e) => CoinItemWidget(
              reason: e.reason,
              time: e.date == null ? e.desc : TimeUtil.getTime(e.date!),
              coinNum: e.coinCount,
            ))
        .toList();
  }

  void _onRefresh() {
    pageIndex = 0;
    getData();
  }

  void _onLoadMore() {
    pageIndex++;
    getData();
  }
}
