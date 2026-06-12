import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/story_list_page.dart';
import 'pages/story_generate_page.dart';
import 'pages/membership_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BedtimeStoryApp());
}

class BedtimeStoryApp extends StatelessWidget {
  const BedtimeStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: MaterialApp(
        title: 'AI睡前故事',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/stories': (context) => const StoryListPage(),
          '/generate': (context) => const StoryGeneratePage(),
          '/membership': (context) => const MembershipPage(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      ),
    );
  }
}
