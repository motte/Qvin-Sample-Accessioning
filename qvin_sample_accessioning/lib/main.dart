import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qvin_sample_accessioning/auth/login_view.dart';
import 'package:qvin_sample_accessioning/auth/register_view.dart';
import 'package:qvin_sample_accessioning/profile/account_view.dart';
import 'package:qvin_sample_accessioning/shared/constants.dart';
import 'package:qvin_sample_accessioning/splash/splash_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load env vars.
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qvin Sample Accessioning',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        if (supabase.auth.currentSession != null) {
          /// TODO: Consider a formal router and de-dupe (e.g. index path).
          /// Add authenticated routes here.
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashView());
            case '/account':
              return MaterialPageRoute(builder: (_) => const AccountView());
          }
        } else {
          /// Add public routes here.
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashView());
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginView());
            case '/register':
              return MaterialPageRoute(
                  builder: (_) => const RegisterView(isRegistering: false));
          }
        }
      },
    );
  }
}
