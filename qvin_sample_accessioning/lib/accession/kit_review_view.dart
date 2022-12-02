import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qvin_sample_accessioning/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final MobileScannerController _cameraController = MobileScannerController();
  bool isCameraApproved = false;
  bool isScanningCode = false;
  bool _loading = true;
  Map<dynamic, dynamic> _currentKit = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.stop();
    _cameraController.dispose();
  }

  void _toggleScanner() {
    /// TODO: Consider destroying MobileScannerController() when camera is hidden, so the red recording dot disappears when the camera is gone.  A simple _cameraController.start() and .stop() seems to break the camera.
    setState(() {
      isCameraApproved = true;
      isScanningCode = !isScanningCode;
    });
  }

  Future<void> _getKit() async {
    setState(() {
      _loading = true;
    });

    try {
      final inputId = _kitIDController.text.toLowerCase();

      /// Search for object.
      if (inputId.startsWith("q") == true) {
        /// This inputId seems to be a Q-Pad id, so search Kit.
        final data = await supabase
            .from('kit')
            .select()
            .ilike('kit_id', '%' + inputId + '%')
            .single() as Map;

        print(data);
        // Store kit object.
        // _currentKit = data;
      } else if (inputId.startsWith("s") == true) {
        /// This inputId seems to be a strip id, so search Strip.
        final data =
            await supabase.from('strip').select().eq('strip_id', inputId);
        print(data);
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'An unexpected exception occurred');
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _getStripsBy(List<String> ids,
      ValueSetter<List<Map<dynamic, dynamic>>> onSuccess) async {
    /// TODO: Determine if there are typesets or type aliases to replace ValueSetter<List<Map<dynamic, dynamic>>> to something like ValueSetListMap.
    try {
      final inputId = _kitIDController.text.toLowerCase();
      List<String> stripIds = ids;
      List<Map<dynamic, dynamic>> listResult = [];

      for (var id in ids) {
        String stripId = id.toLowerCase();
        if (stripId.startsWith("s") == true) {
          /// If this is a valid strip Id.
          /// TODO: Obviously need to know what a valid stripID looks like, so edit in future.
          stripIds.add(stripId);
        } else {
          /// If this does not seem to be a valid strip id.
          /// TODO: Do something about invalid strip ids.
          print(
              "Invalid strip id " + stripId + "was removed from being pulled.");
        }
      }

      if (stripIds.isNotEmpty) {
        /// Search for strip objects by list of ids.
        final data = await supabase
            .from('strip')
            .select()
            .in_('strip_id', ids)
            .limit(stripIds.length);

        /// callback with data.
        onSuccess(data);
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'An unexpected exception occurred');
    }
  }

  Future<void> _getStripBy(
      String id, ValueSetter<Map<dynamic, dynamic>> onSuccess) async {
    try {
      final inputId = _kitIDController.text.toLowerCase();

      /// Search for object.
      if (inputId.startsWith("s")) {
        /// This inputId seems to be a strip id, so search Strip.
        final data =
            await supabase.from('strip').select().eq('strip_id', inputId);
        onSuccess(data);
      } else {
        /// TODO: Need to handle invalid strip ids in _getStripBy().
        print("This doesn't seem to be a valid strip id.");
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'An unexpected exception occurred');
    }
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
              Image(
                  image: AssetImage("images/Qvin-small-logo-dark.png"),
                  height: 24),
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
        child: Center(
          child: new ListView(
            shrinkWrap: true,
            children: [
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
                        onPressed: () => {_getKit()},
                        child: Row(
                          children: [
                            const Spacer(),
                            if (_loading == true)
                              Container(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.white,
                                  ))),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Search"),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 240,
                      child: TextButton(
                        onPressed: () {
                          _toggleScanner();
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
                          child: Row(
                            children: [
                              Expanded(
                                child: MobileScanner(
                                  fit: BoxFit.fitHeight,
                                  allowDuplicates: false,
                                  controller: _cameraController,
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
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
