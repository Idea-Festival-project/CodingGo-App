import 'package:coding_go/bottombar.dart';
import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 5),
          Center(
            child: Column(
              children: [
                Transform.translate(
                  offset:Offset(0, 50),
                  child: Image.asset(
                      'static/logo.png',
                      width: 250,
                      height: 250,
                  ),
                ),
                Image.asset(
                  'static/icon.png',
                  width: 400,
                  height: 400,),
              ],
            ),
          ),
          const Spacer(flex: 3),
          Column(
            children: [
              FilledButton(onPressed: () {
                print('시작하기');

                Navigator.push(context, MaterialPageRoute(builder: (context) => const Bottombar()));
              },
                  style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      fixedSize: Size(340, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  ),
                  child: Text('시작하기',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white
                    )
                    ,)),
            ],
          ),
          const SizedBox(height: 40,),
          RichText(text: TextSpan(
            text: '이미 계정이 있다면',
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              TextSpan(
                  text: ' 로그인 하기',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationThickness: 3.0,
                      decorationColor: Theme.of(context).colorScheme.primary
                  )
              ),
            ],
          )),
          const SizedBox(height: 60,)
        ],
      ),
    );
  }
}