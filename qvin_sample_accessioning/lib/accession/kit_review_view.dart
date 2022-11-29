import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class KitReviewView extends StatefulWidget {
  const KitReviewView({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const KitReviewView());
  }

  @override
  _KitReviewViewState createState() => _KitReviewViewState();
}

class _KitReviewViewState extends State<KitReviewView> {
  final _kitIDController = TextEditingController();
  MobileScannerController cameraController = MobileScannerController();
  bool isCameraApproved = false;
  bool isScanningCode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button.
        title: const Text(''),
        flexibleSpace: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.menu,
                  semanticLabel: "Menu",
                  color: Colors.white,
                ),
                iconSize: 24,
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              Image.asset("images/Qvin-small-logo.png", height: 24),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/account');
                },
                child: Row(
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 40,
                child: const VerticalDivider(
                  color: Colors.white,
                  thickness: 0.5,
                  width: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings_outlined,
                        size: 24,
                        semanticLabel: 'Settings',
                      ),
                    ],
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  )),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Container(
              alignment: Alignment.topCenter,
              constraints: BoxConstraints(
                maxWidth: 320,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Scan Pouch, Kit-ID or Strip ID",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 240,
                    child: TextField(
                      autofocus: true,
                      controller: _kitIDController,
                      decoration: const InputDecoration(labelText: 'kit ID'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () => {},
                      child: Text("Enter Kit ID"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCameraApproved = true;
                          isScanningCode = !isScanningCode;
                        });
                      },
                      child: Column(
                        children: [
                          if (isScanningCode == true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.exit_to_app),
                                Text("Close"),
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code),
                                Text("Scan"),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isCameraApproved == true)
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: Opacity(
                        opacity: isScanningCode == true ? 1 : 0,
                        child: MobileScanner(
                          allowDuplicates: false,
                          controller: cameraController,
                          onDetect: (barcode, args) {
                            if (barcode.rawValue == null) {
                              debugPrint('Failed to scan Barcode');
                            } else {
                              final String code = barcode.rawValue!;
                              _kitIDController.text = code;
                              debugPrint('Barcode found! $code');
                            }
                          },
                        ),
                      ),
                    )
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
