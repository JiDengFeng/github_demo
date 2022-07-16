import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SureDialogWidget extends StatelessWidget {
  const SureDialogWidget(
      {required this.title,
      required this.content,
      this.sureStr,
      this.cancelStr,
      this.showCancel = true,
      Key? key})
      : super(key: key);

  final String title;
  final String content;
  final bool showCancel;
  final String? sureStr;
  final String? cancelStr;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        width: Get.width * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall)
                .paddingOnly(top: 24),
            Text(content, style: Theme.of(context).textTheme.bodyMedium)
                .paddingSymmetric(horizontal: 16, vertical: 16),
            const SizedBox(height: 8),
            const Divider(height: 1),
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showCancel)
                    Expanded(
                        child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 40,
                            onPressed: () => Get.back(),
                            child: Text(cancelStr ?? '取消',
                                style: Theme.of(context).textTheme.bodyMedium))),
                  if (showCancel) const VerticalDivider(width: 1),
                  Expanded(
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 40,
                          onPressed: () => Get.back(result: true),
                          child:
                              Text(sureStr ?? '确定', style: Theme.of(context).textTheme.bodyMedium)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
