import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人中心'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 20),
            const Text('个人中心', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('正在开发中...', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
