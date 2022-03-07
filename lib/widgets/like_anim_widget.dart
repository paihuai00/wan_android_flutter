import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/24 4:42 下午
/// @Description: 点赞，带有动画

class LikeAnimWidget extends StatefulWidget {
  String? unLikeIconPath;
  String? likeIconPath;
  bool? isLike;

  LikeAnimWidget({
    Key? key,
    this.isLike = false,
    this.likeIconPath = "assets/images/ic_like.png",
    this.unLikeIconPath = "assets/images/ic_un_like.png",
  }) : super(key: key);

  @override
  _LikeAnimWidgetState createState() => _LikeAnimWidgetState();
}

class _LikeAnimWidgetState extends State<LikeAnimWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  late Animation<double> _circleAnimation;

  late final Duration _animDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animDuration);

    // _iconAnimation = Tween(begin: 1.0, end: 1.3).animate(_animationController);
    _iconAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.3)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_animationController);

    _circleAnimation =
        Tween(begin: 1.0, end: 0.0).animate(_animationController);


  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLikeIcon();
  }

  ///构建 点赞 icon
  Widget _buildLikeIcon() {
    return ScaleTransition(
      scale: _iconAnimation,
      child: (widget.isLike ?? false)
          ? IconButton(
              icon: Image.asset(widget.likeIconPath ?? ""),
              onPressed: () {
                _clickIcon();
              },
            )
          : IconButton(
              icon: Image.asset(widget.unLikeIconPath ?? ""),
              onPressed: () {
                _clickIcon();
              },
            ),
    );
  }

  void _clickIcon() {
    if (_iconAnimation.status == AnimationStatus.forward ||
        _iconAnimation.status == AnimationStatus.reverse) {
      return;
    }
    setState(() {
      widget.isLike = !widget.isLike!;
    });

    if (_iconAnimation.status == AnimationStatus.dismissed) {
      _animationController.forward();
    } else if (_iconAnimation.status == AnimationStatus.completed) {
      _animationController.reverse();
    }
  }

  ///圆环
  _buildCircle() {
    return !widget.isLike!
        ? const SizedBox()
        : AnimatedBuilder(
            animation: _circleAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color:
                          Color(0xFF5FA0EC).withOpacity(_circleAnimation.value),
                      width: _circleAnimation.value * 8),
                ),
                child: _buildLikeIcon(),
              );
            });
  }
}
