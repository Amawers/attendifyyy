import 'package:attendifyyy/utils/theme.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: TAppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
