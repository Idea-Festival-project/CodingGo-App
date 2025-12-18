import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 5),
          Center(
            child: Image.asset(
              'static/logo.png',
              width: 250,
              height: 250,
            ),
          ),
          const Spacer(flex: 3),
          Column(
            children: [
              FilledButton(onPressed: () {
                print('시작하기');
              },
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFFF0CD73),
                    fixedSize: Size(340, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    )
                  ),
                  child: Text('시작하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gmarket',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),)),
            ],
          ),
          SizedBox(height: 40,),
          RichText(text: TextSpan(
            text: '이미 계정이 있다면',
            style: TextStyle(
              color: Color(0xFFA8A8A8),
              fontFamily: 'Gmarket',
              fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                text: ' 로그인 하기',
                style: TextStyle(
                  color: Color(0xFFF0CD73),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFF0CD73),
                  decorationThickness: 3,
                )
              ),
            ],
          )),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}