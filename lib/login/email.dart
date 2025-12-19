import 'package:flutter/material.dart';

class Email extends StatelessWidget {
  const Email({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 170),
          Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Coding Go에서 사용할\n'
                    '아이디를 입력해주세요.',
                  style: TextStyle(
                      fontFamily: 'Gmarket',
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              )
          ),
          SizedBox(height: 50,),
          Container(
              height: 50,
              width: 360,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '아이디를 입력해주세요',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Color(0xFFA8A8A8))
                  ), // 감싸기 이거 없으면 걍 글씨..
                  focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Color(0xFFF0CD73))
                  ),
                  suffixIcon: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 안에 버튼 하나 더 만들기
                      child: Container(
                        width: 80,
                        child: TextButton(onPressed: () {
                          print('중복확인 클릭');
                        }, style:TextButton.styleFrom(
                          side: BorderSide(color: Color(0xFFF0CD73), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                            child: Text('중복확인',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Gmarket',
                                  fontWeight: FontWeight.bold,
                                  color: Color( 0XFFF0CD73)
                              ),)),
                      )
                  ),
                ),
              )) , Spacer(flex: 3),
          Column(
            children: [
              FilledButton(onPressed: () {
                print('넘어가기');
              },
                  style: FilledButton.styleFrom(
                      backgroundColor: Color(0xFFF0CD73),
                      fixedSize: Size(340, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  ),
                  child: Text('다음으로',
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
          SizedBox(height: 60,)
        ],
      ),
    );
  }
}
