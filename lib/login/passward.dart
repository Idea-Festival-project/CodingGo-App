import 'package:coding_go/login/login.dart';
import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  // 1. 입력값을 제어할 컨트롤러 선언
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool ispasswordseen = true;

  // 2. 컨트롤러 메모리 해제
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 키보드가 올라올 때 레이아웃이 깨지지 않도록 함
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 170),
              Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Coding Go에서 사용할\n비밀번호를 입력해주세요.',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 50),

              // --- 비밀번호 입력창 ---
              _buildInputLabel('비밀번호'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요',
                obscureText: ispasswordseen,
                suffixIcon: IconButton(
                  icon: Icon(ispasswordseen ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => ispasswordseen = !ispasswordseen),
                ),
              ),

              const SizedBox(height: 20),

              // --- 비밀번호 확인 입력창 ---
              _buildInputLabel('비밀번호 확인'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: '비밀번호를 다시 입력해주세요',
                obscureText: true, // 확인 창은 보통 숨김 고정
              ),

              const Spacer(flex: 3),

              // --- 다음으로 버튼 ---
              FilledButton(
                onPressed: () {
                  // 3. 일치 여부 확인 로직
                  if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                    _showSnackBar('비밀번호를 모두 입력해주세요.');
                  } else if (_passwordController.text == _confirmPasswordController.text) {
                    print('비밀번호 일치! 다음 페이지로 이동');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                  } else {
                    _showSnackBar('비밀번호가 일치하지 않습니다.');
                  }
                },
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: const Size(340, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('다음으로', style: TextStyle(fontSize: 17, color: Colors.white)),
              ),

              const SizedBox(height: 40),
              _buildLoginLink(context),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }

  // --- 위젯 분리 (중복 코드 방지) ---

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 50,
      width: 360,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFA8A8A8), width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFF0CD73), width: 1.5)),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '이미 계정이 있다면',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey),
        children: [
          TextSpan(
            text: ' 로그인 하기',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationThickness: 3,
            ),
          )
        ],
      ),
    );
  }
}