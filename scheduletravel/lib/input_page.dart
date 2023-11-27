// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'output_page.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController1 = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();


  double costSliderValue = 0.3; // 비용 슬라이더의 기본 값
  double prioritySliderValue = 0.3; // 우선항목 슬라이더의 기본 값
  double foodSliderValue = 0.4; // 먹거리 슬라이더의 기본 값
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '여행 정보 입력',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC5DDFF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textController1,
                decoration: InputDecoration(
                  labelText: '장소',
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context, isStartDate: true);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: '출발 날짜',
                          contentPadding: const EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${startDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const Icon(Icons.calendar_today, size: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context, isStartDate: false);
                      },
                      child: InputDecorator(

                        decoration: InputDecoration(
                          labelText: '복귀 날짜',
                          contentPadding: const EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
              // 비용 슬라이더
              Column(
                children: [
                  Text('비용: ${costSliderValue.toStringAsFixed(1)}'),
                  Slider(
                    value: costSliderValue,
                    onChanged: (value) {
                      setState(() {
                        costSliderValue = _clampValue(value);
                      });
                    },
                  ),
                ],
              ),
              TextField(
                controller: textController4,
                decoration: const InputDecoration(labelText: '관광'),
              ),
              // 우선항목 슬라이더
              Column(
                children: [
                  Text('관광: ${prioritySliderValue.toStringAsFixed(1)}'),
                  Slider(
                    value: prioritySliderValue,
                    onChanged: (value) {
                      setState(() {
                        prioritySliderValue = _clampValue(value);
                      });
                    },
                  ),
                ],
              ),
              // 먹거리 슬라이더
              TextField(
                decoration: const InputDecoration(labelText: '먹거리'),
              ),
              Column(
                children: [
                  Text('먹거리: ${foodSliderValue.toStringAsFixed(1)}'),
                  Slider(
                    value: foodSliderValue,
                    onChanged: (value) {
                      setState(() {
                        foodSliderValue = _clampValue(value);
                      });
                    },
                  ),
                ],
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0), backgroundColor: const Color(0xFFC5DDFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ), // 새로운 테마 컬러
                ),
                child: const Text(
                  '여행 추천',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
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
