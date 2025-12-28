import 'package:coding_go/login/passward.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isCodeSent = false;
  bool _isLoading = false;
  bool _isVerified = false;
  String? _errorMessage;

  // API 기본 URL (본인 서버 주소로 변경)
  static const String baseUrl = 'https://your-api.com';

  // 1. 인증번호 요청
  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorMessage('이메일을 입력해주세요');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isCodeSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증번호가 이메일로 전송되었습니다')),
        );
      } else {
        _showErrorMessage('인증번호 전송 실패');
      }
    } catch (e) {
      _showErrorMessage('오류 발생: $e');
    }
  }

  // 2. 인증번호 확인
  Future<void> _verifyCode() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      _showErrorMessage('인증번호를 입력해주세요');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _isLoading = false;
          _isVerified = true;
        });

        // 인증 성공 시 다음 페이지로 이동
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이메일 인증 성공!')),
          );
          // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
        }
      } else {
        _showErrorMessage('인증번호가 올바르지 않습니다');
      }
    } catch (e) {
      _showErrorMessage('오류 발생: $e');
    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

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
              child: Text(
                'Coding Go에서 사용할\n이메일을 인증해주세요.',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 20, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 23),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('이메일',
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 50,
            width: 360,
            child: TextFormField(
              controller: _emailController,
              enabled: !_isCodeSent,
              decoration: InputDecoration(
                hintText: '이메일을 입력해주세요',
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Color(0xFFA8A8A8), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Color(0xFFF0CD73), width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 23),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('인증번호',
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 50,
            width: 360,
            child: TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: '인증번호를 입력해주세요',
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Color(0xFFA8A8A8), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Color(0xFFF0CD73), width: 1.5),
                ),
                suffixIcon: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Container(
                    width: 80,
                    child: TextButton(
                      onPressed: _isCodeSent && !_isLoading
                          ? _verifyCode
                          : _sendVerificationCode,
                      style: TextButton.styleFrom(
                        side: BorderSide(
                            color:
                            Theme.of(context).colorScheme.primary,
                            width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: _isLoading
                          ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                          : Text(
                        _isCodeSent ? '인증확인' : '요청',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                          fontSize: 13,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(left: 23, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          const Spacer(flex: 3),
          Column(
            children: [
              FilledButton(
                onPressed: _isVerified
                    ? () {
                  // 인증 성공했을 때만 다음 페이지로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('다음 페이지로 이동합니다')),
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordPage()));
                }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor:
                  Theme.of(context).colorScheme.primary,
                  fixedSize: Size(340, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  '다음으로',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 17, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          RichText(
            text: TextSpan(
              text: '이미 계정이 있다면',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary),
              children: [
                TextSpan(
                  text: ' 로그인 하기',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor:
                    Theme.of(context).colorScheme.primary,
                    decorationThickness: 3,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}