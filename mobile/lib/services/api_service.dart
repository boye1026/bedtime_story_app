import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
  ));

  Future<Map<String, dynamic>> generateStory({
    required String childName,
    required int childAge,
    required List<String> interests,
    required String style,
  }) async {
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 2));
      
      // 返回模拟数据（避免网络请求失败导致闪退）
      return {
        'success': true,
        'content': '这是一个测试故事。\n\n从前有个小朋友叫$childName，今年$childAge岁。\n\n晚安，好梦！✨',
        'title': '${childName}的睡前故事'
      };
    } catch (e) {
      throw Exception('生成故事失败: $e');
    }
  }

  Future<Map<String, dynamic>> getVIPStatus() async {
    return {
      'is_vip': false,
      'remaining_free_count': 5,
      'vip_expire_date': null,
      'remaining_days': 0
    };
  }

  Future<List<dynamic>> getVIPPlans() async {
    return [
      {'plan_type': 'monthly', 'name': '月度会员', 'price': 29.9, 'description': '30天VIP权益'},
      {'plan_type': 'quarterly', 'name': '季度会员', 'price': 79.9, 'description': '90天VIP权益，节省20%'},
      {'plan_type': 'yearly', 'name': '年度会员', 'price': 299.9, 'description': '365天VIP权益，节省50%'},
    ];
  }

  Future<Map<String, dynamic>> activateVIP(String planType) async {
    return {'success': true, 'message': '购买成功'};
  }
}
