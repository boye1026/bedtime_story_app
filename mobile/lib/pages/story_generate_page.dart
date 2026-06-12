import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StoryGeneratePage extends StatelessWidget {
  const StoryGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成故事'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '宝宝信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '宝宝的名字',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.child_care),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '宝宝年龄',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.cake),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              '兴趣爱好',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                '恐龙', '太空', '动物', '公主', '汽车', '魔法'
              ].map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('生成故事', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
