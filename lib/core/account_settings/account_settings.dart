import 'package:attendifyyy/utils/theme.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fnameController.text = 'Coco';
    lnameController.text = 'Mahtin';
    emailController.text = 'MahtinCoco@gmail.com';
    passwordController.text = 'imissu123';
    contactNoController.text = '096537439932';
    departmentController.text = 'Information Technology';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            color: TAppTheme.primaryColor,
          ),

          // Circular avatar and form fields
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile picture of the account
              Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Center(
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    child: const ClipOval(
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            NetworkImage('https://picsum.photos/250?image=9'),
                      ),
                    ),
                  ),
                ),
              ),

              // Form fields
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name Field
                    createLabel('First Name:'),
                    const SizedBox(height: 5),
                    createTextField(
                        fnameController, 'First Name', Icons.person),
                    const SizedBox(height: 12),

                    // Last Name Field
                    createLabel('Last Name:'),
                    const SizedBox(height: 5,),
                    createTextField(lnameController, 'Last Name', Icons.person),
                    const SizedBox(height: 12),

                    //Email Field
                    createLabel('Email:'),
                    const SizedBox(height: 5,),
                    createTextField(emailController, 'Email', Icons.email),
                    const SizedBox(height: 12),

                    // Password Field
                    // Need to be obscured so separate jud siya sa createTextField na widget
                    createLabel('Password:'),
                    const SizedBox(height: 5,),
                    createTextField(passwordController, 'Password', Icons.lock),
                    const SizedBox(height: 12),

                    // Contact Number Field
                    createLabel('Contact Number:'),
                    const SizedBox(height: 5,),
                    createTextField(
                        contactNoController, 'Contact No.', Icons.phone),
                    const SizedBox(height: 12),

                    // Department Field
                    createLabel('Department:'),
                    const SizedBox(height: 5,),
                    createTextField(
                        departmentController, 'Department', Icons.house),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size.fromHeight(60)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF081631)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'UPDATE',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for custom labels per field
Widget createLabel(label) {
  return Text(
    label,
    style: const TextStyle(
      color: Color(0xff081631),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );  
}

// Widget for form fields
Widget createTextField(valueController, label, icon) {
  return TextFormField(
    controller: valueController,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      labelStyle: const TextStyle(
        color: Color(0xFFABABAB),
        fontSize: 14,
      ),
      floatingLabelStyle: const TextStyle(color: Color(0xFF081631)),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 2, color: Color(0xFF081631)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Color(0xFFABABAB)),
      ),
    ),
  );
}
