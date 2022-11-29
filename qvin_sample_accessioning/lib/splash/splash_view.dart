import 'package:flutter/material.dart';
import 'package:qvin_sample_accessioning/shared/constants.dart';
import 'package:qvin_sample_accessioning/profile/account_view.dart';
import 'package:qvin_sample_accessioning/auth/login_view.dart';

/// First route of the app that shows a loader.
///
/// Used to load required information before loading functional UI (auth) and redirect to appropriate page based on initial auth state.
class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }
  
  Future<void> _redirect() async {
    /// await for the widget to mount.  Avoids flashing screen.
    await Future.delayed(Duration.zero);
    
    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacementNamed('/account');
      // Navigator.of(context).pushAndRemoveUntil(AccountView.route(), (route) => false);
      // context.router.replace(const LoginView());
    } else {
      // Navigator.of(context).pushAndRemoveUntil(LoginView.route(), (route) => false);
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: InkWell(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.fromLTRB(0, 4, 0, 4)),
                  Text("Click to Reload"),
                ],
              ),
              onTap: () {
                _redirect();
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
