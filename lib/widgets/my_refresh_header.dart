/// @Author: cuishuxiang
/// @Date: 2022/3/14 1:28 下午
/// @Description:

// class MyRefreshHeader extends Header {
//   final Key? key;
//   final double displacement;
//
//   /// 颜色
//   final Animation<Color?>? valueColor;
//
//   /// 背景颜色
//   final Color? backgroundColor;
//
//   final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();
//
//   MyRefreshHeader({
//     this.key,
//     this.displacement = 40.0,
//     this.valueColor,
//     this.backgroundColor,
//     completeDuration = const Duration(seconds: 1),
//     bool enableHapticFeedback = false,
//   }) : super(
//           float: true,
//           extent: 70.0,
//           triggerDistance: 70.0,
//           completeDuration: completeDuration == null
//               ? const Duration(
//                   milliseconds: 300,
//                 )
//               : completeDuration +
//                   const Duration(
//                     milliseconds: 300,
//                   ),
//           enableInfiniteRefresh: false,
//           enableHapticFeedback: enableHapticFeedback,
//         );
//
//   @override
//   Widget contentBuilder(
//       BuildContext context,
//       RefreshMode refreshState,
//       double pulledExtent,
//       double refreshTriggerPullDistance,
//       double refreshIndicatorExtent,
//       AxisDirection axisDirection,
//       bool float,
//       Duration completeDuration,
//       bool enableInfiniteRefresh,
//       bool success,
//       bool noMore) {
//     linkNotifier.contentBuilder(
//         context,
//         refreshState,
//         pulledExtent,
//         refreshTriggerPullDistance,
//         refreshIndicatorExtent,
//         axisDirection,
//         float,
//         completeDuration,
//         enableInfiniteRefresh,
//         success,
//         noMore);
//
//
//   }
// }
