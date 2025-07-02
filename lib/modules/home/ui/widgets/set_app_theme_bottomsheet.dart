import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/data/theme/bloc/theme_cubit.dart';
import 'package:turnotask/widgets/bottom_sheet_mainframe.dart';

class SetAppThemeBottomSheet extends StatefulWidget {
  const SetAppThemeBottomSheet({super.key});

  @override
  State<SetAppThemeBottomSheet> createState() => _SetAppThemeBottomSheetState();
}

class _SetAppThemeBottomSheetState extends State<SetAppThemeBottomSheet> {
  String getSheetTitle() {
    return "App Theme";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BottomSheetMainFrame(
          label: getSheetTitle(),
          initialChildSize: 0.3,
          minChildSize: 0.2,
          content: (scrollController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: ThemeModeOption.values.map((option) {
                final label = {
                  ThemeModeOption.light: 'Light Theme',
                  ThemeModeOption.dark: 'Dark Theme',
                  ThemeModeOption.system: 'System Default',
                }[option]!;
                return RadioListTile<ThemeModeOption>(
                  value: option,
                  activeColor: AppColors.primary200,
                  groupValue: context.watch<ThemeCubit>().state.themeMode,
                  onChanged: (v) {
                    context.read<ThemeCubit>().setThemeMode(v!);
                    Navigator.pop(context);
                  },
                  title: Text(
                    label,
                    style: context.textTheme.bodySmall?.withAdaptiveColor(
                      context,
                      lightColor: AppColors.colorNeutral800,
                      darkColor: AppColors.colorNeutralDark800,
                      letterSpacing: 0,
                      height: 143 / 100,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
