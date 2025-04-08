import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/provider/loading_model.dart';
import 'package:tiktokclone/views/pages/auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => LoadingModel())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tik tok demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme().copyWith(
          bodySmall: const TextStyle(fontFamily: "Tiktok_Sans"),
          bodyMedium: const TextStyle(fontFamily: "Tiktok_Sans"),
          bodyLarge: const TextStyle(fontFamily: "Tiktok_Sans"),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
