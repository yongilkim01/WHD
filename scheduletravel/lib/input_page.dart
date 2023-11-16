import 'package:flutter/material.dart';
import 'output_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController1 = TextEditingController();
  DateTime startDate = DateTime.now(); // 시작 날짜 변수
  DateTime endDate = DateTime.now();   // 종료 날짜 변수
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
              decoration: const InputDecoration(labelText: '장소'),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectDate(context, isStartDate: true);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '출발 날짜',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${startDate.toLocal()}".split(' ')[0],
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectDate(context, isStartDate: false);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '복귀 날짜',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${endDate.toLocal()}".split(' ')[0],
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: textController3,
              decoration: const InputDecoration(labelText: '비용'),
            ),
            TextField(
              controller: textController4,
              decoration: const InputDecoration(labelText: '우선항목'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OutputPage(
                      text1: textController1.text,
                      text2: "시작: ${startDate.toLocal()} 종료: ${endDate.toLocal()}",
                      text3: textController3.text,
                      text4: textController4.text,
                    ),
                  ),
                );
              },
              child: const Text('여행 추천'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }
}
