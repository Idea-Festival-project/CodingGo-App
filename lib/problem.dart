import 'package:flutter/material.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  String selectedLang = 'c언어';
  final List<String> languages = ['c언어', 'java', '파이썬', 'c++'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // 세련된 연회색 배경
      appBar: AppBar(
        title: const Text('코딩 도장깨기',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. 커뮤니티 스타일의 깔끔한 상단 바
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: languages.map((lang) {
                  final bool isSelected = selectedLang == lang;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: true,
                      checkmarkColor: Colors.black,
                      label: Text(lang,
                          style: TextStyle(
                              fontFamily: 'Gmarket',
                              color: isSelected ? Colors.black : Colors.grey[500])),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => selectedLang = lang),
                      selectedColor: const Color(0xFFFFB011),
                      backgroundColor: const Color(0xFFF1F3F5),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // 2. 세련된 로드맵 영역
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 40),
              itemCount: 3,
              itemBuilder: (context, index) {
                int stageNum = index + 1;
                // 지그재그 오프셋
                double xOffset = (stageNum == 2) ? -0.4 : (stageNum == 3 ? 0.4 : 0.0);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  alignment: Alignment(xOffset, 0),
                  child: _buildModernStage(selectedLang, stageNum),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 3. 세련된 네모 카드 버튼 디자인
  Widget _buildModernStage(String lang, int num) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showStartModal(lang, num),
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이콘 포인트
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB011).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Color(0xFFFFB011), size: 28),
                ),
                const SizedBox(height: 12),
                Text('단계 $num',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Gmarket')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('$lang 마스터하기',
            style: TextStyle(color: Colors.grey[400], fontSize: 12, fontFamily: 'Gmarket')),
      ],
    );
  }

  // 4. 시작하기 바텀 시트 (백엔드 연결 시점)
  void _showStartModal(String lang, int num) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$lang $num단계 도전!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
            const SizedBox(height: 10),
            const Text('서버에서 최신 문제를 가져올까요?', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB011),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('시작하기',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}