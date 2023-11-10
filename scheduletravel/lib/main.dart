import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();
  TextEditingController textController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff69665d),
        leading: Icon(Icons.list, color: Color(0xffc4a031), size: 37),
        title: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '가고싶은 여행지는?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffcba03)),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.manage_accounts, color: Color(0xffc4a031), size: 37)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textController1,
                decoration: InputDecoration(labelText: '여행지'),
              ),
              TextField(
                controller: textController2,
                decoration: InputDecoration(labelText: '경비'),
              ),
              TextField(
                controller: textController3,
                decoration: InputDecoration(labelText: '일자'),
              ),
              TextField(
                controller: textController4,
                decoration: InputDecoration(labelText: '우선사항'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPage(
                        text1: textController1.text,
                        text2: textController2.text,
                        text3: textController3.text,
                        text4: textController4.text,
                      ),
                    ),
                  );
                },
                child: Text('다음 페이지로 이동'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... 이전 코드 ...

class SecondPage extends StatelessWidget {
  final String text1, text2, text3, text4;

  SecondPage({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff69665d),
        leading: Icon(Icons.list, color: Color(0xffc4a031), size: 37),
        title: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '<제주도>',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffcba03)),
              ),
              TextSpan(
                text: ' 에 대해 추천해드릴게요!',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.manage_accounts, color: Color(0xffc4a031), size: 37)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("위는 제주도의 유명한 명소들의 사진입니다.", style: TextStyle(fontSize: 13)),
            Text("10월 20일 부터 10월 22일의 여행일정을 소개해드리겠습니다.",
                style: TextStyle(fontSize: 13)),
            Text("1일차 : 제주 시내 탐방",
                style: TextStyle(fontSize: 13, color: Color(0xffe04b3a))),
            Text("오전 : 제주 공항 도착 후 숙소 체크인", style: TextStyle(fontSize: 13)),
            Text("점심 : 제주 대표음식 “ 제주흑돼지” 레스토랑에서 식사",
                style: TextStyle(fontSize: 13)),
            Text("오후 : 제주 에코랜드 테마파크 순례", style: TextStyle(fontSize: 13)),
            Text("저녁 : 제주의 바다를 배경으로 한 해산물 요리 레스트랑에서 식사",
                style: TextStyle(fontSize: 13)),
            Text("2일차 : 서쪽 제주 탐험",
                style: TextStyle(fontSize: 13, color: Color(0xffe04b3a))),
            Text("아침 : 서귀포로 이동, 제주도의 아름다움을 경험할 수 있는 “한라산” 등반",
                style: TextStyle(fontSize: 13)),
            Text("점심 : 등반 후, 한라산 입구 근처 식당에서 정통 제주음식 먹기",
                style: TextStyle(fontSize: 13)),
            Text(
                "오후 및 저녁 : 제주도의 바다와 빈티지한 분위기를 즐길 수 있는 “용눈이오름” 방문 및 근처 항구에서 신선한 해산물 요리 먹기 !",
                style: TextStyle(fontSize: 13)),
            Text("3일차 : 제주에서 마지막 날",
                style: TextStyle(fontSize: 13, color: Color(0xffe04b3a))),
            Text("아침 : 숙소 체크아웃 후, 쇼핑 및 기념품가게 방문",
                style: TextStyle(fontSize: 13)),
            Text("점심 : 제주 대표음식 “갈치조림” 식당 방문", style: TextStyle(fontSize: 13)),
            Text("저녁 : 제주 공항으로 이동하여 귀국하기", style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ... 이후 코드 ...
