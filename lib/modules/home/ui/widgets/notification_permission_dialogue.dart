import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turnotask/modules/home/bloc/home_cubit.dart';
import 'package:turnotask/services/notification_helper.dart';
import 'package:turnotask/widgets/turno_dialogue.dart';

class NotificationPermissionDialogue extends StatelessWidget {
  final BuildContext dialogContext;

  const NotificationPermissionDialogue({
    super.key,
    required this.dialogContext,
  });

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AtDialog(
          dialogContext: dialogContext,
          title: 'Schedule Reminders',
          content:
              'It looks like you have turned off permissions required for this feature. It can be enabled under Phone Settings > Apps > Turno Task > Notifications & Alarms and Reminders',
          onButtonTap: () {
            if (Platform.isAndroid) {
              if (!homeCubit.state.hasNotificationPermissionAndroid) {
                NotificationHelper.openAppNotificationSettings();
                Navigator.pop(context);
              } else if (!homeCubit.state.hasExactAlarmNotificationPermission) {
                NotificationHelper.checkAndRequestExactAlarmPermission();
                Navigator.pop(context);
              }
            } else {
              NotificationHelper.openAppSettings();
              Navigator.pop(context);
            }
          },
          buttonLabel: 'Settings',
        );
      },
    );
  }
}
