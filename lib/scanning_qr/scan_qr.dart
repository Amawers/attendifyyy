import 'dart:convert';

import 'package:attendifyyy/api_connection/api_connection.dart';
import 'package:attendifyyy/authentication/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  String? id;
  String firstName = '';
  String middleInitial = '';
  String lastName = '';

  List<dynamic> studentAttendanceData = [];
  List<dynamic> converted = [];

  // Initialization for subject selection
  // Remove lang ni pag implement nimos backend then puliha tung naa sa dropdown to the retrieved schedules.
  String? selectedSubject;
  String? selectedSectionName;
  List<String> subjects = [];

  @override
  void initState() {
    super.initState();
    getListOfSubjects();

    // To immediately be greeted with the pop up dialog when opening the QR Scanner
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
         await getListOfSubjects();
      _showSubjectSelectionDialog(context);
    });
  }

  Future<void> getListOfSubjects() async {
    Map<String, dynamic>? teacherInfo =
        await RememberUserPreferences.readUserInfo();

    String? teacherId = teacherInfo?['teacher_id'];
    if (teacherId != null && teacherId.isNotEmpty) {
      final response = await http
          .get(Uri.parse('${Api.listOfSubjects}?teacher_id=$teacherId'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          converted = jsonDecode(response.body);
          print('VALUE OF CONVERTED: $converted');
          setState(() {
            subjects = List<String>.from(converted
                .map((dynamic subject) => subject['subject_name'].toString()));
          });
          print("sulod sa subjects: $subjects");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No subjects")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to fetch subjects")));
      }
    } else {
      print("Error: Teacher ID is null or empty");
    }
  }

  Future<void> processResult(String? result) async {
    if (result != null) {
      List<String> attributes = result.split('\t');

      if (attributes.length == 5) {
        id = attributes[0];
        firstName = attributes[1];
        middleInitial = attributes[2]?.isNotEmpty == true ? attributes[2] : '';
        lastName = attributes[3];
        String course = attributes[4];
        // Values are printed inside the debug console to check if it has successfully retrieved information from a QR Code after scanning.
        print('Barcode Found!');
        print(
            'ID: $id\nFirst Name: $firstName\nMiddle Initial: ${middleInitial ?? ''}\nLast Name: $lastName\nCourse: $course');

        print(
            "BEFORE E PROCESS SELECTED SUBJECT: ${selectedSubject} & REFERENCE ID: ${id}");
        try {
          final response = await http.post(Uri.parse(Api.createAttendance),
              body: {'subject_name': selectedSubject, 'reference_number': id});
          if (response.statusCode == 200) {
            print(jsonDecode(response.body));
          }
        } catch (error) {
          print("Wala na process ang attendance");
        }

        setState(() {
          // To update the displayed scanned name
        });
      } else {
        print('Not valid.');
      }
    }
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
                    processResult(barcode.rawValue);
                  }
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
                  if (firstName.isNotEmpty || lastName.isNotEmpty)
                    Column(
                      children: [
                        // The displayed scanned name
                        Text(
                          concatenateScannedName(
                              firstName, middleInitial, lastName),
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
            items: subjects.map((String value) {
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

class ScanQrOverlay extends StatelessWidget {
  const ScanQrOverlay({Key? key, required this.overlayColour})
      : super(key: key);

  final Color overlayColour;

  @override
  Widget build(BuildContext context) {
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 430.0;
    return Stack(children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            overlayColour, BlendMode.srcOut), // This one will create the magic
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: scanArea,
                width: scanArea,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: CustomPaint(
          foregroundPainter: BorderPainter(),
          child: SizedBox(
            width: scanArea + 20,
            height: scanArea + 20,
          ),
        ),
      ),
    ]);
  }
}

// Creates the white borders
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    const radius = 20.0;
    const tRadius = 3 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    const clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Color(0xFF081631)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarReaderSize {
  static double width = 200;
  static double height = 200;
}

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(size.width - 44, size.height - 44), radius: 40))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}
