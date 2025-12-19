import 'package:coding_go/login/email.dart';
import 'package:coding_go/login/id.dart';
import 'package:coding_go/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Id(),
      
      theme: ThemeData(
        useMaterial3: true,
        
        //색상 지정햇음
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF0CD73),
            primary: const Color(0xFFF0CD73),
            secondary: const Color(0xFFA8A8A8)
        ),

        //텍스트 지정햇음
        textTheme: const TextTheme(
          labelLarge: TextStyle(
            fontFamily: 'Gmarket',
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }
}
