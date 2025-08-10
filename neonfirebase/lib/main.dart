import 'package:flutter/material.dart';
import 'package:neonfirebase/screens/home_screen.dart';
import 'package:neonfirebase/utils/inits/firebase_initialize.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase'i ve servisleri başlat
  await FirebaseInitialize.firebaseInit();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}