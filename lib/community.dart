import 'package:flutter/material.dart';

// 1. 댓글 데이터 모델
class Comment {
  final String name;
  final String content;
  final DateTime createdAt;
  int likes;
  bool isLiked; // 사용자가 좋아요를 눌렀는지 추적

  Comment({
    required this.name,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
  });
}

// 2. 게시글 데이터 모델
class Post {
  final String name;
  final String category;
  final String content;
  final DateTime createdAt;
  int likes;
  bool isLiked; // 사용자가 좋아요를 눌렀는지 추적
  List<Comment> comments;

  Post({
    required this.name,
    required this.category,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.comments = const [],
  });
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String selectedCategory = '전체';
  final List<String> categories = ['전체', '도움요청', '피드백', 'c언어'];

  // 샘플 데이터
  List<Post> posts = [
    Post(
      name: '류수연',
      category: '도움요청',
      content: '자동 시간 기록 기능을 테스트 중입니다!',
      createdAt: DateTime.now(),
      likes: 5,
      comments: [
        Comment(
          name: '김철수',
          content: '좋은 기능이네요!',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likes: 2,
        ),
      ],
    ),
  ];

  String formatAbsoluteTime(DateTime time) {
    String year = time.year.toString();
    String month = time.month.toString().padLeft(2, '0');
    String day = time.day.toString().padLeft(2, '0');
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');

    return "$year-$month-$day $hour:$minute";
  }

  void _navigateToWritePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WritePostPage()),
    );

    if (result != null && result is Post) {
      setState(() {
        posts.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Post> filteredPosts = selectedCategory == '전체'
        ? posts
        : posts.where((post) => post.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('커뮤니티', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category, style: TextStyle(fontFamily: 'Gmarket', color: selectedCategory == category ? Colors.black : Colors.grey[600])),
                      selected: selectedCategory == category,
                      onSelected: (selected) => setState(() => selectedCategory = category),
                      selectedColor: const Color(0xFFFFB011),
                      backgroundColor: Colors.grey[100],
                      side: BorderSide(color: selectedCategory == category ? const Color(0xFFFFB011) : Colors.grey[300]!),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) => _buildPostItem(filteredPosts[index], index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToWritePage,
        backgroundColor: const Color(0xFFFFB011),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildPostItem(Post post, int postIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Color(0xFFFFB011), child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
                  Text('${post.category} · ${formatAbsoluteTime(post.createdAt)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500], fontFamily: 'Gmarket')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content, style: const TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Gmarket')),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (post.isLiked) {
                      post.likes--;
                      post.isLiked = false;
                    } else {
                      post.likes++;
                      post.isLiked = true;
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 16,
                      color: post.isLiked ? const Color(0xFFFFB011) : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${post.likes}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsPage(post: post, postIndex: postIndex, parentSetState: setState),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.comment_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${post.comments.length}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- 댓글 페이지 ---
class CommentsPage extends StatefulWidget {
  final Post post;
  final int postIndex;
  final Function(VoidCallback) parentSetState;

  const CommentsPage({
    super.key,
    required this.post,
    required this.postIndex,
    required this.parentSetState,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      widget.post.comments.add(
        Comment(
          name: '류수연',
          content: _commentController.text,
          createdAt: DateTime.now(),
          likes: 0,
          isLiked: false,
        ),
      );
      _commentController.clear();
    });

    widget.parentSetState(() {});
  }

  String formatAbsoluteTime(DateTime time) {
    String year = time.year.toString();
    String month = time.month.toString().padLeft(2, '0');
    String day = time.day.toString().padLeft(2, '0');
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');

    return "$year-$month-$day $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('댓글', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 댓글 입력 창 (맨 위)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      hintStyle: const TextStyle(fontFamily: 'Gmarket'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addComment,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB011),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          // 원본 게시글
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(backgroundColor: Color(0xFFFFB011), radius: 20, child: Icon(Icons.person, color: Colors.white, size: 16)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post.name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket', fontSize: 13)),
                        Text(formatAbsoluteTime(widget.post.createdAt),
                            style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'Gmarket')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.post.content, style: const TextStyle(fontSize: 13, color: Colors.black87, fontFamily: 'Gmarket')),
              ],
            ),
          ),
          const Divider(height: 1),
          // 댓글 리스트
          Expanded(
            child: ListView.builder(
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.post.comments[index];
                return _buildCommentItem(comment, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment, int commentIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket', fontSize: 13)),
                  Text(formatAbsoluteTime(comment.createdAt),
                      style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'Gmarket')),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (comment.isLiked) {
                      comment.likes--;
                      comment.isLiked = false;
                    } else {
                      comment.likes++;
                      comment.isLiked = true;
                    }
                  });
                  widget.parentSetState(() {});
                },
                child: Row(
                  children: [
                    Icon(
                      comment.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 14,
                      color: comment.isLiked ? const Color(0xFFFFB011) : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${comment.likes}', style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.content, style: const TextStyle(fontSize: 13, color: Colors.black87, fontFamily: 'Gmarket')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

// --- 글쓰기 페이지 ---
class WritePostPage extends StatefulWidget {
  const WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _controller = TextEditingController();
  String selectedKeyword = '도움요청';
  final List<String> keywords = ['도움요청', '피드백', 'c언어'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('글 쓰기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.trim().isEmpty) return;

              Navigator.pop(
                context,
                Post(
                  name: '류수연',
                  category: selectedKeyword,
                  content: _controller.text,
                  createdAt: DateTime.now(),
                ),
              );
            },
            child: const Text('등록', style: TextStyle(color: Color(0xFFFFB011), fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Gmarket')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('키워드 선택', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Gmarket')),
            const SizedBox(height: 12),
            Row(
              children: keywords.map((kw) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(kw, style: const TextStyle(fontFamily: 'Gmarket')),
                  selected: selectedKeyword == kw,
                  onSelected: (val) => setState(() => selectedKeyword = kw),
                  selectedColor: const Color(0xFFFFB011),
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontFamily: 'Gmarket'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}