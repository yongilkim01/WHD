import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'input_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: HomePage(), // 다른 파일에서 가져온 Dart 파일의 클래스 사용
    );
  }
}