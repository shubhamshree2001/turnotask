import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/values/font_constants.dart';
import 'package:turnotask/data/values/font_size.dart';

class TurnoTextStyle {
  // Inter Text styles -----------

  static TextStyle aller12Inter400 = TextStyle(
    color: AppColors.colorNeutral900,
    fontSize: AppFontSize.heading12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontsConstant.inter,
    letterSpacing: 0,
    height: 1.44,
  );

  static TextStyle aller14Inter400 = TextStyle(
    color: AppColors.colorNeutral900,
    fontSize: AppFontSize.heading14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: FontsConstant.inter,
    letterSpacing: 0,
  );

  static TextStyle aller14Inter600 = TextStyle(
    color: AppColors.colorNeutral900,
    fontSize: AppFontSize.heading14.sp,
    fontWeight: FontWeight.w600,
    fontFamily: FontsConstant.inter,
    height: 143 / 100,
    letterSpacing: 0,
  );

  static TextStyle aller16Inter600 = TextStyle(
    color: AppColors.colorNeutral900,
    fontSize: AppFontSize.heading16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: FontsConstant.inter,
    height: 143 / 100,
    letterSpacing: 0,
  );
  static TextStyle aller18Inter600 = TextStyle(
    color: AppColors.colorNeutral900,
    fontSize: AppFontSize.heading18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: FontsConstant.inter,
    height: 143 / 100,
    letterSpacing: 0,
  );
}
