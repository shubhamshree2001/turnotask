import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/data/utils/string_extension.dart';
import 'package:turnotask/data/values/app_images.dart';

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

void showCenterSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.45,
      left: 20.w,
      right: 20.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImages.doneIcon.toSvg(height: 64.w, width: 64.w),
              Gap(4.h),
              Text(
                message,
                style: context.textTheme.displayLarge?.withAdaptiveColor(
                  context,
                  lightColor: AppColors.colorNeutral900,
                  darkColor: AppColors.colorNeutral900,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
