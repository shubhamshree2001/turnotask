import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/modules/home/ui/widgets/primary_cta.dart';

class AtDialog extends StatelessWidget {
  final BuildContext dialogContext;
  final String title;
  final String content;
  final VoidCallback onButtonTap;
  final String buttonLabel;
  final Color? buttonColor;
  final bool? hasCancel;
  final String? imagePath;

  const AtDialog({
    super.key,
    required this.dialogContext,
    required this.title,
    required this.content,
    required this.onButtonTap,
    required this.buttonLabel,
    this.imagePath,
    this.buttonColor,
    this.hasCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      elevation: 8,
      insetPadding: EdgeInsets.all(20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null) Image.asset(imagePath!),
            if (imagePath != null) Gap(32.w),
            Text(
              title,
              style: context.textTheme.displayLarge?.withAdaptiveColor(context,
                  lightColor: AppColors.colorNeutral900,
                  darkColor: AppColors.colorNeutralDark900),
            ),
            Gap(8.w),
            Text(
              content,
              style: context.textTheme.bodySmall?.withAdaptiveColor(context,
                  lightColor: AppColors.colorNeutral800,
                  darkColor: AppColors.colorNeutralDark800),
            ),
            Gap(20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryCta(
                    onTap: onButtonTap,
                    label: buttonLabel,
                    color: buttonColor,
                  ),
                ),
                if (hasCancel ?? true) Gap(16.w),
                if (hasCancel ?? true)
                  Expanded(
                    child: SecondaryCta(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                      },
                      label: 'Cancel',
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}