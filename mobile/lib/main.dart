import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '梦境故事屋',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  String _generatedStory = '';

  void _generateStory() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入宝宝的名字')),
      );
      return;
    }
    setState(() {
      _generatedStory = "从前有一个叫 $name 的小朋友，他/她非常勇敢善良。每天晚上都会听着故事进入甜美的梦乡。🌙✨";
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('梦境故事屋'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '宝宝的名字',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('✨ 生成故事 ✨', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_generatedStory.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Text(
                        _generatedStory,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
