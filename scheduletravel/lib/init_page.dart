import 'package:flutter/material.dart';
import 'input_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // 초기 화면을 SplashScreen으로 지정
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 일정 시간이 지난 후에 홈페이지로 이동하는 코드 추가
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFFC5DDFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // 로고 이미지의 경로에 따라 수정
              width: 300.0,
              height: 300.0,
            ),
          ],
        ),
      ),
    );
  }
}