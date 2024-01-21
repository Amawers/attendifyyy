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
  List<String> schedules = [];
  String? selectedSchedule;

  List<dynamic> studentAttendanceData = [];

  List<dynamic> converted = [];

  @override
  void initState() {
    super.initState();
    getListOfSchedules();
  }

  Future<void> getListOfSchedules() async {
    String? teacherId;
    try {
      Map<String, dynamic>? teacherInfo =
          await RememberUserPreferences.readUserInfo();

      teacherId = teacherInfo?['teacher_id'];
    } catch (error) {
      print("Error lods: $error");
    }

    final response = await http
        .get(Uri.parse('${Api.listOfSchedules}?teacher_id=$teacherId'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        converted = jsonDecode(response.body);
        print("list of schedules if nakuha ba: ${converted}");
        setState(() {
          schedules = List<String>.from(converted
              .map((dynamic subject) => subject['schedule_id'].toString()));
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No schedules")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to fetch schedules")));
    }
  }

  Future<void> processResult(String? result) async {
    if (result != null) {
      List<String> attributes = result.split('\t');

      if (attributes.length == 5) {
        id = attributes[0];
        String firstName = attributes[1];
        String? middleInitial =
            attributes[2]?.isNotEmpty == true ? attributes[2] : null;
        String lastName = attributes[3];
        String course = attributes[4];
        // Values are printed inside the debug console to check if it has successfully retrieved information from a QR Code after scanning.
        print('Barcode Found!');
        print(
            'ID: $id\nFirst Name: $firstName\nMiddle Initial: ${middleInitial ?? ''}\nLast Name: $lastName\nCourse: $course');

        try {
          final response = await http.post(Uri.parse(Api.createAttendance),
              body: {'schedule_id': selectedSchedule, 'reference_number': id});
          if (response.statusCode == 200) {
            print(jsonDecode(response.body));
          }
        } catch (error) {
          print("Wala na process ang attendance");
        }
      } else {
        print('Not valid.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Starting of AppBar Section with Logo
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        child: Column(
          children: [
            // Flex Container for the entirety of the body of the scan_page
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // // This is THE Scanner/Camera with scanning functionality using the pre-built onDetect function of the mobile_scanner package.
                  MobileScanner(
                    controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates),
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        processResult(barcode.rawValue);
                      }
                    },
                  ),
                  // Design overlay for the QR Scanner.
                  const ScanQrOverlay(
                      overlayColour: Color.fromARGB(255, 255, 255, 255)),

                  const SizedBox(
                    height: 50,
                    child: Text(
                      'Scan the QR code to check attendance',
                      style: TextStyle(color: Color(0xFF081631)),
                    ),
                  ),
                ],
              ),
            ),
            // Container where we can add elements below the QR scanner
            DropdownButton(
              items: schedules.map((String schedules) {
                return DropdownMenuItem(
                    value: schedules, child: Text(schedules));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSchedule = newValue;
                });
              },
              hint: Text('Select a schedules'),
            )
          ],
        ),
      ),
    );
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
