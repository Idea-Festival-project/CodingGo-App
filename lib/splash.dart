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
              FilledButton(onPressed: () {
                print('시작하기');
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
                  ),
                  )
              ),
          const SizedBox(height: 40,),
             RichText(text: TextSpan(
            text: '이미 계정이 있다면',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary
            ),
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