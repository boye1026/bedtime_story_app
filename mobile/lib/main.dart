import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

void main() async {
  // 确保 Flutter 初始化完成
  WidgetsFlutterBinding.ensureInitialized();
  
  // 全局错误捕获
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  runZonedGuarded(() {
    runApp(const BedtimeStoryApp());
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stack');
  });
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
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 延迟跳转，确保初始化完成
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.nightlight_round, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 30),
              const Text(
                '梦境故事屋',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                '宝宝睡前故事',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _nameController = TextEditingController();
  String _generatedStory = '';
  bool _isPlaying = false;
  String _statusMessage = '';
  bool _isLoading = false;
  bool _ttsAvailable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initTTS();
    _loadSavedName();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterTts.stop();
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
      debugPrint('加载保存的名字失败: $e');
    }
  }

  Future<void> _saveName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('child_name', name);
    } catch (e) {
      debugPrint('保存名字失败: $e');
    }
  }

  Future<void> _initTTS() async {
    try {
      await _flutterTts.setLanguage("zh-CN");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
      setState(() {
        _ttsAvailable = true;
        _statusMessage = '语音引擎已就绪 ✨';
      });
    } catch (e) {
      setState(() {
        _ttsAvailable = false;
        _statusMessage = '语音引擎初始化失败，但您仍然可以阅读故事';
      });
      debugPrint('TTS 初始化失败: $e');
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
      _isLoading = true;
      _statusMessage = 'AI 正在为你创作故事...';
    });
    
    // 模拟 AI 生成
    await Future.delayed(const Duration(seconds: 2));
    
    final story = '''
🌟 给 $name 的睡前故事 🌟

在一个遥远的梦境王国里，住着一个勇敢善良的小朋友，名字叫 $name。

这一天，$name 在梦中遇到了一只会说话的小星星。小星星闪闪发光，温柔地说："勇敢的小朋友，你愿意和我一起去冒险吗？"

$name 开心地点点头，跟着小星星飞向了天空。他们穿过了棉花糖做的云朵，越过了彩虹桥，来到了月亮城堡。

月亮城堡里住着温柔的月亮公主，她为 $name 准备了一个特别的礼物——一个装满美梦的魔法盒子。

"每天晚上，你都可以从这个盒子里取一个美梦，"月亮公主微笑着说，"让甜美的梦伴你入睡。"

$name 抱着魔法盒子，感到无比幸福。从那以后，每天晚上都有美丽的梦境陪伴着他/她。

晚安，亲爱的 $name，愿你今夜好梦。🌙✨

—— 梦境故事屋
''';

    setState(() {
      _generatedStory = story;
      _isLoading = false;
      _statusMessage = '故事生成成功！点击播放按钮听故事 📖';
    });
  }

  Future<void> _speakStory() async {
    if (!_ttsAvailable) {
      setState(() {
        _statusMessage = '语音引擎不可用，请阅读故事';
      });
      return;
    }
    
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
      setState(() {
        _statusMessage = '播放失败，请重试';
        _isPlaying = false;
      });
      debugPrint('TTS 播放失败: $e');
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
      debugPrint('停止播放失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('梦境故事屋', style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                  ),
                ),
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_statusMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(_statusMessage.contains('成功') ? Icons.check_circle : Icons.info_outline,
                            color: const Color(0xFF8B5CF6), size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text(_statusMessage, style: const TextStyle(color: Color(0xFF6B21A8)))),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.child_care, size: 30, color: Color(0xFF8B5CF6)),
                            SizedBox(width: 12),
                            Text('宝宝信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: '宝宝的名字',
                            hintText: '请输入宝宝的名字',
                            prefixIcon: const Icon(Icons.star, color: Color(0xFF8B5CF6)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFFDF6E3),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _generateStory,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: _isLoading
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                : const Text('✨ 生成故事 ✨', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_generatedStory.isNotEmpty)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_stories, color: Color(0xFF8B5CF6)),
                              SizedBox(width: 12),
                              Text('你的故事', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF6E3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SelectableText(_generatedStory, style: const TextStyle(fontSize: 16, height: 1.6)),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _ttsAvailable ? _speakStory : null,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('播放故事'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: _stopStory,
                                icon: const Icon(Icons.stop),
                                label: const Text('停止'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF59E0B),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
