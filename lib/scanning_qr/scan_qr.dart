// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/api_connection/api_services.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:attendifyyy/scanning_qr/scan_qr_overlay.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {

  List<dynamic> studentAttendanceData = [];
  // List<dynamic> converted = [];

  // Initialization for subject selection
  // Remove lang ni pag implement nimos backend then puliha tung naa sa dropdown to the retrieved schedules.
  String? selectedSubject;
  String? selectedSectionName;

  @override
  void initState() {
    super.initState();
    ApiServices.getListOfSubjectSpecial();

    // To immediately be greeted with the pop up dialog when opening the QR Scanner
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await ApiServices.getListOfSubjectSpecial();
      _showSubjectSelectionDialog(context);
    });
  }

  // Method to concatenate the scanned name to Full Name
  String concatenateScannedName(String fName, String mInitial, String lName) {
    return '$fName ${mInitial.isNotEmpty ? '$mInitial ' : ''}$lName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // THE QR Scanner
            Positioned.fill(
              top: -150,
              child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                ),
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    ApiServices.processResult(context: context, selectedSubject: selectedSubject, result: barcode.rawValue);
                    
                  }
                  setState(() {
                    
                  });
                },
              ),
            ),

            // Design overlay for the QR Scanner.
            const Positioned.fill(
              top: -150,
              child: ScanQrOverlay(
                overlayColour: Color.fromARGB(255, 255, 255, 255),
              ),
            ),

            // Text directly below the QR Scanner
            const Positioned(
              bottom: 180,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scan the QR code to check attendance',
                    style: TextStyle(
                      color: Color(0xFF081631),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Text above the QR Scanner (Subject Name)
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedSubject != null
                        ? '$selectedSubject'
                        : 'Choose a subject',
                    style: const TextStyle(
                      color: Color(0xff081631),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Scanned Name Display
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ApiServices.ScanfirstName.isNotEmpty || ApiServices.ScanlastName.isNotEmpty)
                    Column(
                      children: [
                        // The displayed scanned name
                        Text(
                          concatenateScannedName(
                              ApiServices.ScanfirstName, ApiServices.middleInitial, ApiServices.ScanlastName),
                          style: const TextStyle(
                            color: Color(0xff081631),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // "PRESENT" Text
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_pin_rounded,
                                color: Color.fromARGB(255, 50, 216, 55),
                                size: 16),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'PRESENT',
                              style: TextStyle(
                                color: Color.fromARGB(255, 50, 216, 55),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ],
              ),
            ),

            // Change Subject Button way below the QR Scanner
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  _showSubjectSelectionDialog(context);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size.fromHeight(50),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF081631)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Change Subject',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // The "Select Subject" pop up dialog with the Dropdown menu
  void _showSubjectSelectionDialog(BuildContext context) async {
    final selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text(
            "Select Subject",
            style: TextStyle(
              color: Color(0xff081631),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          // Diri sulod sa content i change pang backend nimo
          content: DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xff081631),
                ),
              ),
            ),
            value: selectedSubject,
            onChanged: (String? newValue) {
              setState(() {
                selectedSubject = newValue;
              });
              Navigator.pop(context, newValue);
            },
            items: ApiServices.subjectsSpecial.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: const Text('Select subject'),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedSubject = selected;
      });
    }
  }
}
