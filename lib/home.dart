import 'package:flutter/material.dart';

void main() {
  runApp(const CodingGoApp());
}

class CodingGoApp extends StatelessWidget {
  const CodingGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gmarket', // Gmarket 폰트 적용
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coding Go!', style: TextStyle(color: Color(0xFFFFB011), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 인사말 섹션
            const Text('안녕하세요, 류수연님!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('오늘은 무슨 문제를 풀어볼까요?', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),

            // 2. 오늘의 목표 카드 (웹 디자인 유지)
            _buildGoalCard(),
            const SizedBox(height: 20),

            // 3. 바로가기 버튼 섹션 (해결한 문제수/정답률 대체)
            Row(
              children: [
                Expanded(
                  child: _buildNavCard('랭킹 바로가기', Icons.leaderboard, const Color(0xFFFFB011), () {
                    // 랭킹 페이지 이동 로직
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNavCard('커뮤니티 바로가기', Icons.forum, const Color(0xFF4CAF50), () {
                    // 커뮤니티 페이지 이동 로직
                  }),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 4. 오늘의 추천 문제 헤더
            const Row(
              children: [
                Icon(Icons.code, size: 20, color: Color(0xFFFFB011)),
                SizedBox(width: 8),
                Text('오늘의 추천 문제', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // 5. 언어별 문제 풀이 카드
            _buildLanguageCard('Python 풀러가기', '가장 인기 있는 언어', '🐍', Colors.blue[50]!),
            const SizedBox(height: 12),
            _buildLanguageCard('C언어 풀러가기', '기초부터 탄탄하게', '💻', Colors.grey[100]!),
            const SizedBox(height: 12),
            _buildLanguageCard('Java 풀러가기', '객체지향의 정석', '☕', Colors.red[50]!),

            const SizedBox(height: 30),

            // 로그아웃 버튼 (웹 사이드바 하단 메뉴 반영)
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.grey, size: 18),
                label: const Text('로그아웃', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 오늘의 목표 카드 위젯
  Widget _buildGoalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('오늘의 목표', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('66%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange[400])),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: 0.66,
            backgroundColor: Colors.grey[100],
            color: const Color(0xFFFFB011),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 15),
          const Text('2/3 문제 해결', style: TextStyle(fontSize: 13, color: Colors.grey)),
          const Text('목표 달성까지 단 1문제 남았어요!', style: TextStyle(fontSize: 13, color: Color(0xFFFFB011), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 바로가기 네비게이션 카드 위젯
  Widget _buildNavCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 언어별 문제 풀이 카드 위젯
  Widget _buildLanguageCard(String title, String subtitle, String emoji, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}