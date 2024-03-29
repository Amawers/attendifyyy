import 'package:attendifyyy/authentication/log_in.dart';
import 'package:attendifyyy/core/account_settings/account_settings.dart';
import 'package:attendifyyy/core/info_pages/about_app.dart';
import 'package:attendifyyy/core/info_pages/contact_support.dart';
import 'package:attendifyyy/core/info_pages/privacy_policy.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Starting of AppBar Section with Logo
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Container(
            padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 90,
              height: 200,
            ),
          ),
        ),
      ), // Ending of AppBar Section

      // Body with Settings Options
      body: ListView(padding: const EdgeInsets.all(14.0), children: [
        createSettingOptionCard(
            Icons.person, "Account", const AccountSettings(), context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        createSettingOptionCard(Icons.privacy_tip, "Privacy Policy",
            const PrivacyPolicyScreen(), context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        createSettingOptionCard(Icons.contact_support, "Contact Support",
            const ContactSupport(), context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        createSettingOptionCard(
            Icons.info, "About App", const AboutApp(), context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        // Log out Button
        TextButton(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogIn()),
            );
          },
          child: const Row(children: [
            Icon(Icons.logout, color: Color(0xFFFF0000)),
            SizedBox(width: 14.0),
            Text("Log out",
                style: TextStyle(
                  color: Color(0xFFFF0000),
                  fontSize: 18.0,
                )),
          ]),
        ),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ]),
    );
  }
}

// Function to create setting option card
Widget createSettingOptionCard(materialIcon, label, onClickAction, context) {
  return TextButton(
    style: ButtonStyle(
      padding: const MaterialStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => onClickAction),
      );
    },
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Icon(materialIcon, color: const Color(0xFF081631)),
        const SizedBox(width: 14.0),
        Text(label,
            style: const TextStyle(
              color: Color(0xff081631),
              fontSize: 18.0,
            )),
      ]),
      const Icon(Icons.navigate_next, color: Color(0xFF081631))
    ]),
  );
}
