import 'package:coding_go/start.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool ispasswordseen = true;
  bool _isLoading = false;
  String? _errorMessage;

  static const String baseUrl = 'https://your-api.com';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 함수
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage('이메일과 비밀번호를 모두 입력해주세요');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() => _isLoading = false);

        // 로그인 성공
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 성공!')),
          );

          Navigator.push(context, MaterialPageRoute(builder: (context) => const Start()));
        }
      } else if (response.statusCode == 401) {
        _showErrorMessage('이메일 또는 비밀번호가 올바르지 않습니다');
      } else {
        _showErrorMessage('로그인 실패. 다시 시도해주세요');
      }
    } catch (e) {
      _showErrorMessage('오류 발생: $e');    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Image.asset(
                'static/logo.png',
                width: 250,
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '이메일',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 50,
              width: 360,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '이메일을 입력해주세요',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFFA8A8A8),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFFF0CD73),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '비밀번호',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 50,
              width: 360,
              child: TextFormField(
                controller: _passwordController,
                obscureText: ispasswordseen,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력해주세요',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFFA8A8A8),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(0xFFF0CD73),
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      ispasswordseen
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        ispasswordseen = !ispasswordseen;
                      });
                    },
                  ),
                ),
              ),
            ),
            // 에러 메시지 표시
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
                  onPressed: _isLoading ? null : _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(340, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : Text(
                    '로그인',
                    style:
                    Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                text: '계정이 없다면',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary),
                children: [
                  TextSpan(
                    text: ' 회원가입 하기',
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
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}