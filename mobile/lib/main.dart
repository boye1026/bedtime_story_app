import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 捕获所有错误并保存到文件
  FlutterError.onError = (FlutterErrorDetails details) async {
    final errorLog = '${DateTime.now()}\n${details.exception}\n${details.stack}\n---\n';
    await _saveErrorLog(errorLog);
  };
  
  runZonedGuarded(() async {
    runApp(const BedtimeStoryApp());
  }, (error, stack) async {
    final errorLog = '${DateTime.now()}\nGLOBAL ERROR: $error\n$stack\n---\n';
    await _saveErrorLog(errorLog);
  });
}

Future<void> _saveErrorLog(String log) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/crash_log.txt');
    await file.writeAsString(log, mode: FileMode.append);
  } catch (e) {
    // 忽略保存失败
  }
}

class BedtimeStoryApp extends StatelessWidget {
  const BedtimeStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '梦境故事屋',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFFDF6E3),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _nameController = TextEditingController();
  String _generatedStory = '';
  bool _isPlaying = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initTTS();
    _loadSavedName();
  }

  Future<void> _initTTS() async {
    try {
      await _flutterTts.setLanguage("zh-CN");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
      setState(() {
        _statusMessage = '语音引擎已就绪 ✨';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '语音引擎初始化失败，但您仍然可以阅读故事';
      });
    }
  }

  Future<void> _loadSavedName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('child_name');
      if (savedName != null && savedName.isNotEmpty) {
        _nameController.text = savedName;
      }
    } catch (e) {
      // 忽略错误
    }
  }

  Future<void> _saveName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('child_name', name);
    } catch (e) {
      // 忽略错误
    }
  }

  Future<void> _generateStory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _statusMessage = '请输入宝宝的名字 🌟';
      });
      return;
    }
    
    await _saveName(name);
    
    setState(() {
      _generatedStory = "从前有一个叫$name的小朋友，他/她非常勇敢善良。每天晚上都会听着故事进入甜美的梦乡。🌙✨\n\n故事开始：\n\n在梦境王国里，$name遇到了会说话的小星星。小星星说：'勇敢的小朋友，让我们一起去冒险吧！'\n\n$name开心地点点头，跟着小星星飞向了天空。他们穿过了棉花糖做的云朵，越过了彩虹桥，来到了月亮城堡。\n\n晚安，亲爱的$name，愿你今夜好梦。🌙✨";
      _statusMessage = '故事生成成功！';
    });
  }

  Future<void> _speakStory() async {
    if (_generatedStory.isEmpty) {
      setState(() {
        _statusMessage = '先生成一个故事吧 🪄';
      });
      return;
    }
    
    try {
      setState(() => _isPlaying = true);
      await _flutterTts.speak(_generatedStory);
      setState(() => _statusMessage = '正在播放故事 🎵');
    } catch (e) {
      setState(() => _statusMessage = '播放失败');
    }
  }

  Future<void> _stopStory() async {
    try {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = false;
        _statusMessage = '已停止播放';
      });
    } catch (e) {
      // 忽略错误
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _flutterTts.stop();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_statusMessage, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '宝宝的名字',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('✨ 生成故事 ✨', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_generatedStory.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(_generatedStory, style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _speakStory,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('播放'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: _stopStory,
                              icon: const Icon(Icons.stop),
                              label: const Text('停止'),
                            ),
                          ],
                        ),
                      ],
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
