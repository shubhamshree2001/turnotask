import 'package:flutter/material.dart';
import 'package:turnotask/services/notification_service.dart';
import 'package:turnotask/widgets/turno_dialogue.dart';

class NotificationPermissionDialogue extends StatelessWidget {
  final BuildContext dialogContext;

  const NotificationPermissionDialogue({super.key, required this.dialogContext});

  @override
  Widget build(BuildContext context) {
    return AtDialog(
      dialogContext: dialogContext,
      title: 'Schedule Reminders',
      content:
      'It looks like you have turned off permissions required for this feature. It can be enabled under Phone Settings > Apps > Turno Task > Alarms and Reminders',
      onButtonTap: () {
        NotificationService().requestExactAlarmPermission();
        Navigator.pop(context);
      },
      buttonLabel: 'Settings',
    );
  }
}
