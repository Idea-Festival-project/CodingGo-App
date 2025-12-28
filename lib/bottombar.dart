import 'package:flutter/material.dart';
import 'package:coding_go/home.dart';
import 'package:coding_go/community.dart';
import 'package:coding_go/problem.dart';
import 'package:coding_go/ranking.dart';
import 'package:coding_go/profile.dart';

// API 기본 주소 정의
const String API_BASE_URL = 'https://codinggo.com/api'; // 실제 서버 주소로 변경하세요

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const CommunityPage(),
      const ProblemPage(),
      const RankingPage(baseUrl: API_BASE_URL),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFFB011),
        unselectedItemColor: const Color(0xFFE1E1E1),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Gmarket',
        ),
        unselectedLabelStyle: const TextStyle(
            fontFamily: 'Gmarket'
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: '문제',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}