import 'package:flutter/material.dart';

class KitReviewView extends StatefulWidget {
  const KitReviewView({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const KitReviewView());
  }

  @override
  _KitReviewViewState createState() => _KitReviewViewState();
}

class _KitReviewViewState extends State<KitReviewView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button.
        title: const Text('Sample Accession'),
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
    );
  }
}
