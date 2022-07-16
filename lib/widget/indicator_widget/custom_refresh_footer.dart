import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';

class CustomRefreshFooter extends LoadIndicator {
  final TextStyle? textstyle;
  final Color? indicatorColor;

  const CustomRefreshFooter(
      {this.textstyle,
      this.indicatorColor,
      VoidCallback? onClick,
      LoadStyle loadStyle = LoadStyle.ShowAlways,
      double height = 80.0,
      Key? key})
      : super(
          key: key,
          loadStyle: loadStyle,
          height: height,
          onClick: onClick,
        );

  @override
  LoadIndicatorState<CustomRefreshFooter> createState() => _CustomRefreshFooterState();
}

class _CustomRefreshFooterState extends LoadIndicatorState<CustomRefreshFooter> {
  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    Widget content;
    if (mode == LoadStatus.noMore) {
      content = getNoMoreView();
    } else if (mode == LoadStatus.loading) {
      content = getLoadingView();
    } else if (mode == LoadStatus.canLoading) {
      content = getLoadingView(value: 1);
    } else {
      content = getLoadingView(value: 0);
    }
    return Container(alignment: Alignment.center, height: 40, child: content);
  }

  Widget getLoadingView({double? value}) {
    Color indicatorColor = widget.indicatorColor ?? Theme.of(context).primaryColor;
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: indicatorColor.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation(indicatorColor),
        strokeWidth: 4,
      ),
    );
  }

  Widget getNoMoreView() {
    TextStyle textStyle = widget.textstyle ?? Theme.of(context).textTheme.bodySmall!;
    return Row(
      children: [
        Container(height: 1, width: 50, color: textStyle.color?.withOpacity(0.3)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '没有更多了',
              style: textStyle,
            )),
        Container(height: 1, width: 50, color: textStyle.color?.withOpacity(0.3)),
      ],
    );
  }
}
