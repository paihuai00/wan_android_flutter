import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/22 11:09 上午
/// @Description:

typedef SearchBackCallBack = Function();
typedef SearchClickCallBack = Function(String searchContent);

class SearchBarWidget extends StatefulWidget {
  SearchBackCallBack? backCallBack;
  SearchClickCallBack? searchClickCallBack;

  String? keyWord;

  SearchBarWidget(
      {Key? key, this.backCallBack, this.searchClickCallBack, this.keyWord})
      : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _textEditingController =
      TextEditingController();

  var showClearIcon = false;

  @override
  Widget build(BuildContext context) {
    if (widget.keyWord != null && widget.keyWord!.isNotEmpty) {
      _textEditingController.text = widget.keyWord!;
      showClearIcon = true;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 50,
      color: Colors.blue,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              widget.backCallBack?.call();
            },
            child: const Padding(
              padding: EdgeInsets.all(1),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          _buildInputText(), //输入框
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              widget.searchClickCallBack
                  ?.call(_textEditingController.text.toString().trim());
            },
            child: const Padding(
              padding: EdgeInsets.all(1),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildInputText() {
    return Expanded(
        child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              maxLines: 1,
              onChanged: (contentStr) {
                showClearIcon = _textEditingController.text.isNotEmpty;
                setState(() {});
              },
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "用空格隔开多个关键词",
                hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                contentPadding:
                    EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (!showClearIcon) {
                return;
              }

              _textEditingController.clear();
              showClearIcon = false;

              widget.searchClickCallBack?.call("");

              setState(() {});
            },
            child: showClearIcon == false
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ),
          )
        ],
      ),
    ));
  }
}
