import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_viewmodel.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/normal_colors.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:32 下午
/// @Description:

typedef BaseViewBuilder<T extends DisposableInterface> = Widget Function(
    T controller);

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  const BaseView(
      {required this.builder,
      this.viewModel,
      this.init,
      this.global = true,
      this.autoRemove = true,
      this.assignId = false,
      this.initState,
      this.filter,
      this.tag,
      this.dispose,
      this.id,
      this.didChangeDependencies,
      this.didUpdateWidget,
      this.onReady,
      this.onTapErrorRefresh});

  final BaseViewBuilder<T> builder;
  final T? viewModel;
  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(GetBuilderState<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(GetBuilder oldWidget, GetBuilderState<T> state)?
      didUpdateWidget;
  final T? init;
  final void Function(T?, State state)? onReady;
  final void Function()? onTapErrorRefresh;

  @override
  _BaseViewState createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  // late ScreenUtil screenUtil = ScreenUtil();

  late T viewModel;

  @override
  void initState() {
    super.initState();
    //相当于 build 结束后的回调。
    if (widget.onReady != null) {
      var widgetsBinding = WidgetsBinding.instance;
      widgetsBinding!.addPostFrameCallback((callback) {
        debugPrint("addPostFrameCallback be invoke");
        widget.onReady!(widget.viewModel, this);
        // debugPrint( "ScreenUtil().screenWidth; " + ScreenUtil().screenWidth.toString() );
      });
    }
    if (widget.viewModel != null) {
      viewModel = widget.viewModel!;
    } else {
      viewModel = Get.find<T>();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  Widget loadingView(bool loadingBackground) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                height: (Get.height) * 0.5 - 150,
                width: double.infinity,
                color: Colors.transparent,
              ),
              Container(
                width: 100,
                height: 70,
                decoration: loadingBackground
                    ? BoxDecoration(
                        boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 22,
                                color: Color.fromARGB(13, 26, 34, 51),
                                spreadRadius: 22)
                          ],
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white)
                    : BoxDecoration(),
                child: SpinKitWave(
                  // color: iWriteTheme.textBlue,
                  size: 36,
                  itemCount: 7,
                  itemBuilder: (ctx, idx) {
                    // LoggerUtils.d(message: "idx is " + idx.toString());
                    return Container(
                      decoration: BoxDecoration(
                          color: NormalColor.textBlue,
                          borderRadius: BorderRadius.circular(5)),
                    );
                  },
                ),
              ),
              Expanded(
                  child: Container(
                color: Colors.transparent,
              ))
            ],
          ),
        ),
        Container(
          color: Colors.transparent,
        ),
      ],
    );
  }

  Widget errorView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          children: [
            // SizedBox(
            //   height: screenUtil.scaleHeight * 210,
            // ),
            XImage.load("assets/images/network_error.png"),
            const SizedBox(
              height: 21,
            ),
            const Text(
              "网络不见啦～",
              style: TextStyle(color: Color(0xFF6D7380)),
            ),
            const SizedBox(
              height: 11,
            ),
            const Text(
              "网络或者服务器出问题了，刷新试试吧",
              style: TextStyle(color: Color(0xFFB8BECC), fontSize: 12),
            ),
            const SizedBox(
              height: 26,
            ),
            MaterialButton(
              color: const Color(0xFF3274FA),
              textColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23.0),
              ),
              onPressed: () {
                if (widget.onTapErrorRefresh != null) {
                  widget.onTapErrorRefresh!();
                }
              },
              child: Text("点击刷新"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("widget.provider.pageState " + viewModel.pageState.toString());

    return GetBuilder<T>(
      builder: (_dx) {
        return Stack(
          children: [
            widget.builder(_dx),
            viewModel.pageState == LoadingStateEnum.LOADING
                ? loadingView(viewModel.loadingBackground)
                : (viewModel.pageState == LoadingStateEnum.ERROR
                    ? errorView()
                    : Container())
          ],
        );
      },
      init: widget.viewModel,
      global: widget.global,
      initState: widget.initState,
      autoRemove: widget.autoRemove,
      assignId: widget.assignId,
      filter: widget.filter,
      dispose: widget.dispose,
      tag: widget.tag,
      id: widget.id,
      didChangeDependencies: widget.didChangeDependencies,
      didUpdateWidget: widget.didUpdateWidget,
    );
  }
}
