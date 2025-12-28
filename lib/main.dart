import 'package:coding_go/bottombar.dart';
import 'package:coding_go/login/email.dart';
import 'package:coding_go/id.dart';
import 'package:coding_go/login/login.dart';
import 'package:coding_go/login/passward.dart';
import 'package:coding_go/login/splash.dart';
import 'package:coding_go/name.dart';
import 'package:coding_go/privacy_policy.dart';
import 'package:coding_go/ranking.dart';
import 'package:coding_go/start.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bottombar(),
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
