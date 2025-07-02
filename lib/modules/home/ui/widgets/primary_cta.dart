import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';

class PrimaryCta extends StatelessWidget {
  const PrimaryCta({
    super.key,
    required this.onTap,
    required this.label,
    this.color,
    this.isButtonDisable = false,
  });

  final VoidCallback onTap;
  final String label;
  final Color? color;
  final bool isButtonDisable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: AppColors.black.withOpacity(0.1),
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: isButtonDisable
            ? context.isLightTheme
                  ? AppColors.colorNeutral500
                  : AppColors.colorNeutralDark500
            : color ?? AppColors.primary400,
        textStyle: context.textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
      ),
      onPressed: isButtonDisable ? () {} : onTap,
      child:
           Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
                child: Text(
                  label.toString(),
                  style: context.textTheme.bodySmall?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutral50,
                    darkColor: AppColors.white,
                  ),
                ),
              ),
            )

    );
  }
}
