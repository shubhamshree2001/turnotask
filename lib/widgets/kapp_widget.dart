import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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

void kAppShowGlassmorphicSnackbar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Material(
        color: AppColors.transparent,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: GlassmorphicSnackbar(message: message),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

class GlassmorphicSnackbar extends StatelessWidget {
  final String message;
  final bool errorIcon;

  const GlassmorphicSnackbar({
    super.key,
    required this.message,
    this.errorIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
          decoration: BoxDecoration(
            color: AppColors.colorNeutralDark400.withAlpha(
              (255.0 * 0.15).round(),
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.colorNeutral200.withAlpha((255.0 * 0.2).round()),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                errorIcon ? Icons.error_outline : Icons.info_outline,
                color: context.isDarkTheme
                    ? AppColors.colorNeutral50
                    : AppColors.colorNeutral900,
              ),
              Gap(12.w),
              Expanded(
                child: Text(
                  message,
                  style: context.textTheme.bodySmall?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutral900,
                    darkColor: AppColors.colorNeutral50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
