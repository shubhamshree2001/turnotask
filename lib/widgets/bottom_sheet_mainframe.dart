import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';

class BottomSheetMainFrame extends StatelessWidget {
  final Widget Function(ScrollController controller)? content;
  final VoidCallback? onCtaClick;
  final String? ctaLabel;
  final String? label;
  final Widget? labelWidget;
  final double? initialChildSize;
  final double? minChildSize;
  final VoidCallback? onCloseClick;

  const BottomSheetMainFrame({
    super.key,
    this.content,
    this.onCtaClick,
    this.ctaLabel,
    this.label,
    this.labelWidget,
    this.initialChildSize,
    this.minChildSize,
    this.onCloseClick,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialChildSize ?? 0.8,
      minChildSize: minChildSize ?? 0.75,
      maxChildSize: 0.9,
      snap: false,
      // snapAnimationDuration: Duration(seconds: 1),
      // snapSizes: const [0.0, 0.9],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: context.isLightTheme
                ? AppColors.white
                : AppColors.bgColorDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 80.w,
                  height: 4.h,
                  decoration: const BoxDecoration(
                    color: AppColors.colorNeutral200,
                  ),
                ),
              ),
              Gap(8.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  labelWidget != null
                      ? labelWidget!
                      : Text(
                          label.toString(),
                          style: context.textTheme.displayLarge
                              ?.withAdaptiveColor(
                                context,
                                lightColor: AppColors.colorNeutral900,
                                darkColor: AppColors.colorNeutralDark900,
                                height: 152 / 100,
                                letterSpacing: 0,
                              ),
                        ),
                  InkWell(
                    onTap: onCloseClick != null
                        ? onCloseClick!
                        : () {
                            Navigator.pop(context);
                          },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: content?.call(scrollController) ?? const SizedBox(),
                ),
              ),
              // if (onCtaClick != null) Gap(18.w),
              // if (onCtaClick != null)
              //   PrimaryCta(label: ctaLabel.toString(), onTap: onCtaClick!),
            ],
          ),
        );
      },
    );
  }
}
