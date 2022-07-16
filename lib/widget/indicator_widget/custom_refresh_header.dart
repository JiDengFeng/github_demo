import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme, CircularProgressIndicator;

class CustomRefreshHeader extends RefreshIndicator {
  const CustomRefreshHeader({
    Key? key,
    this.readyToRefresh,
    this.endRefresh,
    this.onOffsetChange,
    this.onModeChange,
    this.onResetValue,
    this.color,
    double height = 60.0,
    Duration completeDuration = const Duration(milliseconds: 600),
    RefreshStyle refreshStyle = RefreshStyle.UnFollow,
  }) : super(
            key: key,
            completeDuration: completeDuration,
            refreshStyle: refreshStyle,
            height: height);

  final VoidFutureCallBack? readyToRefresh;

  final VoidFutureCallBack? endRefresh;

  final OffsetCallBack? onOffsetChange;

  final ModeChangeCallBack<RefreshStatus>? onModeChange;

  final VoidCallback? onResetValue;

  final Color? color;

  @override
  RefreshIndicatorState<CustomRefreshHeader> createState() => _CustomRefreshHeaderState();
}

class _CustomRefreshHeaderState extends RefreshIndicatorState<CustomRefreshHeader> {
  double _offset = 0;
  final double _indicatorShowHeight = 40;
  Color get color => widget.color ?? Theme.of(context).primaryColor;

  @override
  void onOffsetChange(double offset) {
    _offset = offset;
    if (offset >= 0 && mode == RefreshStatus.idle) {
      update();
    }
    widget.onOffsetChange?.call(offset);
    super.onOffsetChange(offset);
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    widget.onModeChange?.call(mode);
    super.onModeChange(mode);
  }

  @override
  Future<void> readyToRefresh() {
    if (widget.readyToRefresh != null) {
      return widget.readyToRefresh!();
    }
    return super.readyToRefresh();
  }

  @override
  Future<void> endRefresh() {
    if (widget.endRefresh != null) {
      return widget.endRefresh!();
    }
    return super.endRefresh();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    double? indicatorValue;
    if (mode == RefreshStatus.idle) {
      double headerTriggerDistance = RefreshConfiguration.of(context)?.headerTriggerDistance ?? 80;
      indicatorValue = _offset < _indicatorShowHeight
          ? 0
          : min(
              (_offset - _indicatorShowHeight) / (headerTriggerDistance - _indicatorShowHeight), 1);
    } else if (mode == RefreshStatus.refreshing) {
      indicatorValue = null;
    } else {
      indicatorValue = 1;
    }
    return Container(
      height: widget.height,
      alignment: Alignment.center,
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          value: indicatorValue,
          backgroundColor: color.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation(color),
          strokeWidth: 4,
        ),
      ),
    );
  }
}
