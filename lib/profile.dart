import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- 데이터 모델 ---
class Item {
  final String id, name, imagePath;
  final int price;
  Item(this.id, this.name, this.price, this.imagePath);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int userPoints = 5200;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String selectedAccessory = 'none';
  Set<String> ownedItems = {'none'};

  final List<Item> accessories = [
    Item('none', '없음', 0, 'static/icon.png'),
    Item('hat', '모자', 500, 'static/hat.png'),
    Item('glasses', '안경', 300, 'static/glass.png'),
    Item('bowtie', '넥타이', 400, 'static/ribonn.png'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPoints();
  }

  // SharedPreferences에서 포인트 불러오기
  Future<void> _loadUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPoints = prefs.getInt('user_points') ?? 5200;
    });
  }

  // SharedPreferences에 포인트 저장하기
  Future<void> _saveUserPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', points);
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text('프로필 사진 설정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFFFB011)),
              title: const Text('갤러리에서 가져오기', style: TextStyle(fontFamily: 'Gmarket')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFFB011)),
              title: const Text('카메라로 직접 찍기', style: TextStyle(fontFamily: 'Gmarket')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source, maxWidth: 500, imageQuality: 80);
        if (pickedFile != null) setState(() => _profileImage = File(pickedFile.path));
      } catch (e) {
        debugPrint("이미지 선택 에러: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('마이페이지', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        elevation: 0, backgroundColor: Colors.white, centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFB011), width: 3),
                      image: _profileImage != null ? DecorationImage(image: FileImage(_profileImage!), fit: BoxFit.cover) : null,
                    ),
                    child: _profileImage == null
                        ? Center(
                      child: Image.asset(
                        accessories.firstWhere((e) => e.id == selectedAccessory).imagePath,
                        width: 80, height: 80,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                    )
                        : null,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFFFFB011), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('류수연', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFFFF9E6), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFB011))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB011), size: 18),
                  const SizedBox(width: 6),
                  Text('$userPoints P', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFA500))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuCard(
                    title: '내 캐릭터 꾸미기',
                    subtitle: '포인트로 새로운 아이템을 구매하세요',
                    icon: Icons.auto_awesome,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterShopPage(
                            currentPoints: userPoints,
                            initialAcc: selectedAccessory,
                            allItems: accessories,
                            ownedItems: ownedItems,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          userPoints = result['points'] ?? userPoints;
                          selectedAccessory = result['acc'] ?? selectedAccessory;
                          ownedItems = result['owned'] ?? ownedItems;
                        });
                        // 포인트 저장
                        await _saveUserPoints(userPoints);
                        print('포인트 저장됨: $userPoints');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(title: '코딩테스트 학습하기', icon: Icons.code, onTap: () {}),
                  const SizedBox(height: 12),
                  _buildMenuCard(title: '나의 랭킹 확인하기', icon: Icons.leaderboard, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({required String title, String? subtitle, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFFFB011).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFFFFB011)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket', fontSize: 15)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      tileColor: const Color(0xFFF8F9FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}

class CharacterShopPage extends StatefulWidget {
  final int currentPoints;
  final String initialAcc;
  final List<Item> allItems;
  final Set<String> ownedItems;

  const CharacterShopPage({
    super.key,
    required this.currentPoints,
    required this.initialAcc,
    required this.allItems,
    required this.ownedItems,
  });

  @override
  State<CharacterShopPage> createState() => _CharacterShopPageState();
}

class _CharacterShopPageState extends State<CharacterShopPage> {
  late int tempPoints;
  late String tempAcc;
  late Set<String> tempOwnedItems;

  @override
  void initState() {
    super.initState();
    tempPoints = widget.currentPoints;
    tempAcc = widget.initialAcc;
    tempOwnedItems = Set.from(widget.ownedItems);
  }

  void _selectItem(Item item) {
    if (tempOwnedItems.contains(item.id)) {
      setState(() => tempAcc = item.id);
      return;
    }

    if (tempPoints < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('포인트가 부족합니다!'), backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이템 구매', style: TextStyle(fontFamily: 'Gmarket')),
        content: Text('${item.name}을(를) ${item.price}P에 구매하시겠습니까?', style: const TextStyle(fontFamily: 'Gmarket')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tempPoints -= item.price;
                tempOwnedItems.add(item.id);
                tempAcc = item.id;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name}을(를) 구매했습니다!'), backgroundColor: Colors.green),
              );
            },
            child: const Text('구매'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('캐릭터 상점', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('$tempPoints P', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFA500))),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 180, height: 180, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  Image.asset(
                    widget.allItems.firstWhere((e) => e.id == tempAcc).imagePath,
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('악세서리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Gmarket')),
                  const SizedBox(height: 15),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: widget.allItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.allItems[index];
                        bool isSelected = tempAcc == item.id;
                        bool isOwned = tempOwnedItems.contains(item.id);

                        return GestureDetector(
                          onTap: () => _selectItem(item),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFF9E6) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFFB011) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      item.imagePath,
                                      width: 40,
                                      height: 40,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(item.name, style: const TextStyle(fontSize: 11, fontFamily: 'Gmarket')),
                                    Text(
                                      isOwned ? '보유중' : (item.price == 0 ? '무료' : '${item.price}P'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isOwned ? Colors.green : Colors.grey,
                                        fontWeight: isOwned ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFB011),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'points': tempPoints,
                        'acc': tempAcc,
                        'owned': tempOwnedItems,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB011),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('저장하고 나가기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}