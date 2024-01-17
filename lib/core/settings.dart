import 'package:attendifyyy/info_pages/privacy_policy.dart';
import 'package:flutter/material.dart';

// import '../info_pages/privacy_policy.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Settings')),
      ),
      body: ListView(padding: const EdgeInsets.all(14.0), children: [
        createSettingOptionCard(Icons.person, "Account", () {}, context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        createSettingOptionCard(Icons.privacy_tip, "Privacy Policy", const PrivacyPolicyScreen(), context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        createSettingOptionCard(
            Icons.contact_support, "Contact Support", () {}, context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        createSettingOptionCard(Icons.info, "About App", () {}, context),
        const Divider(
          color: Color(0xffeaeaea),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        TextButton(
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ))),
          onPressed: () {},
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
//
// Center(
// child: ElevatedButton(
// onPressed: () {
// // onTapSignOut(context);
// },
// child: const Text('SignOut'),
// ),
// ),
/*
 *
 * Widget components
 *
 *  */

Widget createSettingOptionCard(materialIcon, label, onClickAction, context) {
  return TextButton(
      style: ButtonStyle(
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ))),
      onPressed: () => {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => onClickAction),
      )
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
      ]));
}
