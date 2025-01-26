import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:privvy/firebase_options.dart';
import 'package:privvy/providers/music_provider.dart';
import 'package:privvy/providers/privvy_generation_provider.dart';
import 'package:privvy/providers/profile_provider.dart';
import 'package:privvy/providers/timer_countdown_provider.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/authentication/login.dart';
import 'package:privvy/views/onboard/onboard.dart';
import 'package:privvy/views/splash/chill_experience_splash.dart';
import 'package:privvy/views/splash/splash.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .whenComplete(() {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => MusicProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PrivvyGenerationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => TimerCountdownProvider(),
      ),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppThemeConstants.APP_PRIMARY_COLOR),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/chill_experience': (context) => const ChillExperienceSplash(),
          '/onboard': (context) => const OnBoarding(),
          '/login': (context) => const Login(),
        },
      );
    });
  }
}
