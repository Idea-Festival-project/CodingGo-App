import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_data_manager.dart'; // 새로 만든 파일 import

class RankingPage extends StatefulWidget {
  final String baseUrl;

  const RankingPage({
    super.key,
    required this.baseUrl,
  });

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final UserDataManager _userDataManager = UserDataManager();

  // --- [데이터] 나(본인)의 정보 ---
  Map<String, dynamic> myData = {
    "id": 0,
    "name": "류수연",
    "points": 5200,
    "level": 14,
    "isMe": true
  };

  // 테스트 데이터: 친구 목록
  List<dynamic> _myFriends = [
    {"id": 101, "name": "김철수", "points": 1250, "level": 15},
    {"id": 102, "name": "이영희", "points": 980, "level": 12},
    {"id": 103, "name": "박민수", "points": 1100, "level": 14},
    {"id": 104, "name": "최지우", "points": 850, "level": 10},
    {"id": 105, "name": "정해인", "points": 920, "level": 11},
  ];

  // 테스트 데이터: 받은 친구 요청
  List<dynamic> _receivedRequests = [
    {"id": 201, "name": "강하늘"},
    {"id": 202, "name": "이순신"},
  ];

  List<dynamic> _searchResults = [];
  List<dynamic> _allRankings = [];

  bool _isLoading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeToken();
    _loadUserData();
    _updateRankingData();
  }

  // SharedPreferences에서 사용자 데이터 불러오기
  Future<void> _loadUserData() async {
    final points = await _userDataManager.getPoints();
    final name = await _userDataManager.getName();
    final level = await _userDataManager.getLevel();

    setState(() {
      myData = {
        "id": 0,
        "name": name,
        "points": points,
        "level": level,
        "isMe": true
      };
    });

    _updateRankingData();
  }

  // 페이지가 다시 보일 때마다 데이터 새로고침
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _initializeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('jwt_token');

      if (_token == null) {
        _token = 'test_token_12345';
        await prefs.setString('jwt_token', _token!);
        _showSnackBar('테스트 토큰이 저장되었습니다.');
      }

      _loadInitialData();
    } catch (e) {
      _showSnackBar('토큰 로드 실패: $e');
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      await _fetchMyFriends();
      await _fetchReceivedRequests();
      _updateRankingData();
    } catch (e) {
      _showSnackBar('초기 데이터 로드 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMyFriends() async {
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/friends?page=1&limit=100'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _myFriends = List<dynamic>.from(data['data'] ?? []);
        });
      } else {
        print('친구 목록 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('친구 목록 조회 에러: $e');
    }
  }

  Future<void> _fetchReceivedRequests() async {
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/friends/requests'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _receivedRequests = List<dynamic>.from(data['data'] ?? []);
        });
      } else {
        print('받은 요청 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('받은 요청 조회 에러: $e');
    }
  }

  void _updateRankingData() {
    List<dynamic> allParticipants = List.from(_myFriends);
    allParticipants.add(myData);
    allParticipants.sort((a, b) => (b['points'] ?? 0).compareTo(a['points'] ?? 0));
    setState(() {
      _allRankings = allParticipants;
    });
  }

  Future<void> _acceptFriendRequest(dynamic request) async {
    try {
      final response = await http.post(
        Uri.parse('${widget.baseUrl}/friends/requests/${request['id']}/accept'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _receivedRequests.removeWhere((req) => req['id'] == request['id']);
          _myFriends.add({
            "id": request['id'],
            "name": request['name'],
            "points": 0,
            "level": 1,
          });
        });
        _updateRankingData();
        _showSnackBar('${request['name']}님과 친구가 되었습니다.');
      } else {
        throw Exception('친구 요청 수락 실패: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('친구 수락 실패: $e');
    }
  }

  Future<void> _rejectFriendRequest(int requestId) async {
    try {
      final response = await http.post(
        Uri.parse('${widget.baseUrl}/friends/requests/$requestId/reject'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _receivedRequests.removeWhere((req) => req['id'] == requestId);
        });
        _showSnackBar('요청을 거절했습니다.');
      } else {
        throw Exception('친구 요청 거절 실패: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('거절 실패: $e');
    }
  }

  Future<void> _deleteFriend(int friendId) async {
    try {
      final response = await http.delete(
        Uri.parse('${widget.baseUrl}/friends/$friendId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _myFriends.removeWhere((f) => f['id'] == friendId);
        });
        _updateRankingData();
        _showSnackBar('친구를 삭제했습니다.');
      } else {
        throw Exception('친구 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('삭제 실패: $e');
    }
  }

  Future<void> _searchFriends(String friendId) async {
    if (friendId.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/friends/search?friend_id=$friendId&limit=20'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = List<dynamic>.from(data['data'] ?? []);
        });
      } else {
        setState(() {
          _searchResults = [
            {"id": 301, "name": "최민준", "level": 13},
            {"id": 302, "name": "이다은", "level": 12},
            {"id": 303, "name": "박준호", "level": 14},
          ];
        });
        print('검색 실패: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _searchResults = [
          {"id": 301, "name": "최민준", "level": 13},
          {"id": 302, "name": "이다은", "level": 12},
          {"id": 303, "name": "박준호", "level": 14},
        ];
      });
      print('검색 에러: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendFriendRequest(int friendId) async {
    try {
      final response = await http.post(
        Uri.parse('${widget.baseUrl}/friends/requests'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'friend_id': friendId}),
      );

      if (response.statusCode == 200) {
        _showSnackBar('친구 요청을 보냈습니다.');
        setState(() {
          _searchResults.removeWhere((u) => u['id'] == friendId);
        });
      } else {
        throw Exception('친구 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('요청 실패: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('커뮤니티', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFFB011),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFFFB011),
          labelStyle: const TextStyle(fontFamily: 'Gmarket', fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [Tab(text: '친구 랭킹'), Tab(text: '내 친구'), Tab(text: '친구 찾기')],
        ),
      ),
      body: _isLoading && _myFriends.isEmpty && _receivedRequests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildRankingTab(),
          _buildMyFriendsTab(),
          _buildSearchTab(),
        ],
      ),
    );
  }

  Widget _buildRankingTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_allRankings.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_allRankings.length >= 2)
                    Expanded(child: _buildTopRankCard(rank: 2, name: _allRankings[1]['name'], points: _allRankings[1]['points'], color: const Color(0xFFC0C0C0), height: 130, isMe: _allRankings[1]['isMe'] == true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTopRankCard(rank: 1, name: _allRankings[0]['name'], points: _allRankings[0]['points'], color: const Color(0xFFFFD54F), height: 170, showCrown: true, isMe: _allRankings[0]['isMe'] == true)),
                  const SizedBox(width: 8),
                  if (_allRankings.length >= 3)
                    Expanded(child: _buildTopRankCard(rank: 3, name: _allRankings[2]['name'], points: _allRankings[2]['points'], color: const Color(0xFFCD7F32), height: 100, isMe: _allRankings[2]['isMe'] == true)),
                ],
              ),
            ),
          _buildSectionTitle('종합 랭킹 순위 (나 포함)'),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _allRankings.length > 3 ? _allRankings.length - 3 : 0,
            itemBuilder: (context, index) {
              final person = _allRankings[index + 3];
              return _buildRankingListCard(rank: index + 4, name: person['name'], points: person['points'], level: person['level'] ?? 1, isMe: person['isMe'] == true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyFriendsTab() {
    return Column(
      children: [
        if (_receivedRequests.isNotEmpty) ...[
          _buildSectionTitle('받은 친구 요청'),
          ..._receivedRequests.map((req) => _buildReceivedItem(req)).toList(),
        ],
        _buildSectionTitle('내 친구 목록 (${_myFriends.length})'),
        Expanded(
          child: _myFriends.isEmpty
              ? const Center(child: Text('아직 친구가 없습니다.'))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _myFriends.length,
            itemBuilder: (context, index) => _buildFriendListItem(_myFriends[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => _searchFriends(value),
            decoration: InputDecoration(
              hintText: '친구 ID 검색',
              prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB011)),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
              ? Center(child: Text(_searchController.text.isEmpty ? '아이디로 친구를 찾아보세요!' : '검색 결과가 없습니다.'))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) => _buildSearchResultItem(_searchResults[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Gmarket'))),
    );
  }

  Widget _buildTopRankCard({required int rank, required String name, required int points, required Color color, required double height, bool showCrown = false, bool isMe = false}) {
    return Column(
      children: [
        if (showCrown) const Text('👑', style: TextStyle(fontSize: 20)),
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: isMe ? Border.all(color: Colors.blueAccent, width: 3) : null,
          ),
          child: Center(child: Text('$rank', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Gmarket'))),
        ),
        const SizedBox(height: 8),
        Text(isMe ? "나" : name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: isMe ? FontWeight.w900 : FontWeight.bold, color: isMe ? Colors.blueAccent : Colors.black, fontFamily: 'Gmarket')),
        Text('$points pts', style: const TextStyle(fontSize: 11, color: Color(0xFFFFB011), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRankingListCard({required int rank, required String name, required int points, required int level, bool isMe = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFE3F2FD) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isMe ? Colors.blueAccent : Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
          const SizedBox(width: 15),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(isMe ? "$name (나)" : name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
                Text('Lv. $level', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ])),
          Text('$points pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFB011))),
        ],
      ),
    );
  }

  Widget _buildFriendListItem(dynamic data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.grey[100], child: const Icon(Icons.person, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(child: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket'))),
          IconButton(onPressed: () => _deleteFriend(data['id']), icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
        ],
      ),
    );
  }

  Widget _buildReceivedItem(dynamic req) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFFF9EB), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: Text('${req['name']}님의 친구 요청', style: const TextStyle(fontSize: 12, fontFamily: 'Gmarket'))),
          TextButton(onPressed: () => _acceptFriendRequest(req), child: const Text('수락', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
          TextButton(onPressed: () => _rejectFriendRequest(req['id']), child: const Text('거절', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(dynamic user) {
    final isFriend = _myFriends.any((f) => f['id'] == user['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.grey[100], child: const Icon(Icons.person, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
            if (user['level'] != null) Text('Lv. ${user['level']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
          if (isFriend)
            const Chip(label: Text('친구됨', style: TextStyle(fontSize: 10)))
          else
            ElevatedButton(
              onPressed: () => _sendFriendRequest(user['id']),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB011), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
              child: const Text('요청', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}