import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';

Future kAppShowModalBottomSheet(
  BuildContext context,
  Widget content, {
  EdgeInsets? padding,
  bool isDismissible = true,
  VoidCallback? whenComplete,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.r),
        topRight: Radius.circular(40.r),
      ),
    ),
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: true,
    barrierColor: context.isLightTheme
        ? AppColors.colorNeutralDark100.withOpacity(0.1)
        : AppColors.colorNeutral100.withOpacity(0.1),
    backgroundColor: context.isLightTheme
        ? AppColors.colorNeutralDark100.withOpacity(0.1)
        : AppColors.colorNeutral100.withOpacity(0.1),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: content,
      );
    },
  ).whenComplete(() => whenComplete?.call());
}

Future<T?> kAppShowDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  VoidCallback? whenComplete,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: context.isLightTheme
        ? null
        : AppColors.colorNeutral100.withOpacity(0.1),
    barrierLabel: barrierLabel,
    builder: builder,
  ).whenComplete(() => whenComplete?.call());
}

SnackBar customSnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primaryColor, width: 2.w),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: context.textTheme.displaySmall?.withAdaptiveColor(
                context,
                lightColor: AppColors.colorNeutral900,
                darkColor: AppColors.colorNeutral900,
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
    margin: EdgeInsets.only(left: 6.w, right: 10.w, bottom: 1.sh - 175.w),
    elevation: 0,
  );
}
