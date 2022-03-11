import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/11 2:27 下午
/// @Description:

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _TAG = "_ScanPageState";

  late final ScanController controller = ScanController();

  var _lightOpen = false; //手电开关

  //图片选择器
  late final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScanView(
            controller: controller,
            scanAreaScale: .7,
            scanLineColor: Colors.green,
            onCapture: (data) {
              //扫描结果
              XLog.d(message: "扫描结果：$data", tag: _TAG);
              //处理结果
              _dealScanResult(data);
            },
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: _buildLight(),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: _buildAlbumImagePicker(),
          ),
          _buildCloseImage(),
        ],
      ),
    );
  }

  ///闪光灯
  _buildLight() {
    return InkWell(
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle, //圆形
            color: _lightOpen ? Colors.white : Colors.white10),
        child: Image(
          width: 20,
          height: 20,
          image: AssetImage(_lightOpen
              ? "assets/images/ic_flashlight_on.png"
              : "assets/images/ic_flashlight_off.png"),
        ),
      ),
      onTap: () {
        _lightOpen = !_lightOpen;
        controller.toggleTorchMode();

        setState(() {});
      },
    );
  }

  ///相册选择
  _buildAlbumImagePicker() {
    return InkWell(
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, //圆形
            color: Colors.white10),
        child: const Image(
          width: 20,
          height: 20,
          image: AssetImage("assets/images/ic_image_fill.png"),
        ),
      ),
      onTap: () {
        _dealImagePicker();
      },
    );
  }

  //默认扫描结果页面
  void _dealScanResult(String data) {
    if (data.isNotEmpty && data.startsWith("http")) {
      //跳转h5
      NavigatorUtil.jumpToWeb(data, data)!.then((value) => controller.resume());
      return;
    }

    XToast.show("长按屏幕即可复制扫描内容");

    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('扫描结果'),
          ),
          body: GestureDetector(
            child: Container(
              color: Colors.white38,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(data),
              ),
            ),
            onLongPress: () async {
              if (data.isEmpty) {
                XLog.d(message: "暂无内容！", tag: _TAG);
                return;
              }

              ///长按复制
              Clipboard.setData(ClipboardData(text: data));

              var clipboardData = await Clipboard.getData('text/plain');
              if (clipboardData!.text!.isNotEmpty) {
                XToast.show("复制成功");
              } else {
                XToast.show("暂无内容");
              }
            },
          ),
        );
      },
    )).then((value) {
      controller.resume();
    });
  }

  ///图片选择逻辑 image selection logic
  void _dealImagePicker() async {
    var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      XToast.show("无效图片");
      return;
    }

    XLog.d(message: "图片选择地址：${pickedImage.path}", tag: _TAG);

    var result = await Scan.parse(pickedImage.path);

    if (result == null || result.isEmpty) {
      XToast.show("无效二维码");
      return;
    }

    _dealScanResult(result);
  }

  ///左上角关闭按钮
  _buildCloseImage() {
    return Positioned(
      top: 80,
      left: 20,
      child: InkWell(
        child: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(10),
          color: Colors.transparent,
          child: const Image(
            width: 20,
            height: 20,
            image: AssetImage("assets/images/close_fill.png"),
          ),
        ),
        onTap: () {
          NavigatorUtil.goBack(context);
        },
      ),
    );
  }
}
