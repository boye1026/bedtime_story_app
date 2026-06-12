import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StoryListPage extends StatelessWidget {
  const StoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('故事库'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('睡前故事', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('点击收听', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle, color: AppTheme.primaryColor),
              ],
            ),
          );
        },
      ),
    );
  }
}
