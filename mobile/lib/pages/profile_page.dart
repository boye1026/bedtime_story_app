import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 头像区域
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '小读者',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '普通用户',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 统计卡片
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.book, '故事数', '3'),
                  _buildStatItem(Icons.favorite, '收藏', '2'),
                  _buildStatItem(Icons.star, '积分', '120'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 菜单列表
            _buildMenuItem(Icons.history, '我的故事', () {}),
            _buildMenuItem(Icons.favorite, '我的收藏', () {}),
            _buildMenuItem(Icons.auto_awesome, 'VIP会员', () {}),
            _buildMenuItem(Icons.settings, '设置', () {}),
            _buildMenuItem(Icons.help, '帮助中心', () {}),
            
            const SizedBox(height: 20),
            
            // 退出按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('退出登录', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
  
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
