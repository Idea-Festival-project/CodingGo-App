import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 170),
          Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('회원가입이 완료되었어요!\n'
                    '본격적으로 시작하기 전에..',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 20,
                        color: Colors.black
                    )
                ),
              )
          ),
          const Spacer(flex: 3),
          Column(
            children: [
              FilledButton(onPressed: () {
                print('넘어가기');
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
                          fontSize: 17,
                          color: Colors.white
                      ))),
            ],
          ),
          SizedBox(height: 40,),
          RichText(text: TextSpan(
            text: '이미 계정이 있다면',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary
            ),
            children: [
              TextSpan(
                  text: ' 로그인 하기',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    decorationThickness: 3,
                  )
              )
            ],
          )),
          SizedBox(height: 60,)
        ],
      ),
    );
  }
}
