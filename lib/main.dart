import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:untitled123/Providers/Role_Provider.dart';
import 'package:untitled123/Providers/StopWatch_Provider.dart';
import 'package:untitled123/UI_helper/Splash_Screen.dart';
import 'package:untitled123/firebase_options.dart';
import 'package:untitled123/homescreen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: myApp(), // Your main app widget
    ),
  ); // Run the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase App',
      home: SplashScreen(),
      theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context)
              .textTheme)), // Replace this with your main screen
    );
  }
}
