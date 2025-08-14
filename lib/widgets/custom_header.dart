import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  const CustomHeader({super.key});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomHeaderState extends State<CustomHeader> {
  Map<String, dynamic>? user;
  bool menuOpen = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.tnesports.kr/me'),
        headers: {'Accept': 'application/json'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          user = data['user'];
        });
      } else {
        setState(() => user = null);
      }
    } catch (e) {
      setState(() => user = null);
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    await http.post(Uri.parse('https://api.tnesports.kr/logout'));
    setState(() => user = null);
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 1,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/'),
            child: Row(
              children: [
                Text(
                  '급식평가',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(59, 130, 246, 1),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'beta',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(59, 130, 246, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // 데스크탑 모드 가정 (반응형 처리 가능)
        if (user != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '${user!['username']}님 안녕하세요!',
                style: const TextStyle(
                  color: Color.fromRGBO(59, 130, 246, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => _handleLogout(context),
            child: const Text('로그아웃'),
          ),
        ] else ...[
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('로그인'),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            style: TextButton.styleFrom(
              backgroundColor: Color.fromRGBO(59, 130, 246, 1), // 배경색
              textStyle: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              ), // 텍스트 색상
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 둥근 모서리
              ),
            ),
            child: const Text('회원가입'),
          ),
        ],

        // 햄버거 메뉴
        IconButton(
          icon: Icon(
            menuOpen ? Icons.close : Icons.menu,
            color: Color.fromRGBO(59, 130, 246, 1),
            size: 28,
          ),
          onPressed: () => setState(() => menuOpen = !menuOpen),
        ),
      ],
      bottom: menuOpen
          ? PreferredSize(
              preferredSize: const Size.fromHeight(200),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                        setState(() => menuOpen = false);
                      },
                      child: const Text('Home'),
                    ),
                    if (user != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${user!['username']}님 안녕하세요!',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(59, 130, 246, 1),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _handleLogout(context);
                          setState(() => menuOpen = false);
                        },
                        child: const Text('로그아웃'),
                      ),
                    ] else ...[
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                          setState(() => menuOpen = false);
                        },
                        child: const Text('로그인'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                          setState(() => menuOpen = false);
                        },
                        child: const Text('회원가입'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
