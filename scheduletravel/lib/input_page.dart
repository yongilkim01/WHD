import 'package:flutter/material.dart';
import 'output_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 정보 입력'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: textController1,
              decoration: InputDecoration(labelText: '장소'),
            ),
            TextField(
              controller: textController2,
              decoration: InputDecoration(labelText: '시간'),
            ),
            TextField(
              controller: textController3,
              decoration: InputDecoration(labelText: '비용'),
            ),
            TextField(
              controller: textController4,
              decoration: InputDecoration(labelText: '우선항목'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OutputPage(
                      text1: textController1.text,
                      text2: textController2.text,
                      text3: textController3.text,
                      text4: textController4.text,
                    ),
                  ),
                );
              },
              child: Text('여행 추천'),
            ),
          ],
        ),
      ),
    );
  }
}