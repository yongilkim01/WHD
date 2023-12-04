// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  late TextEditingController textController1 = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int selectedMaxPlaces = 1;

  late TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();
  double prioritySliderValue = 0.25;
  double foodSliderValue = 0.25;
  double shoppingSliderValue = 0.25;
  double restSliderValue = 0.25;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController3 = TextEditingController();
    textController1.addListener(_updateButtonColor);
    textController3.addListener(_updateButtonColor);
  }

  @override
  void dispose() {
    textController1.dispose();
    textController3.dispose();
    super.dispose();
  }

  void _updateButtonColor() {
    setState(() {}); // 입력 필드 변경 감지 시 상태를 업데이트하여 리렌더링 유도
  }


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
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: selectedMaxPlaces,
                onChanged: (value) {
                  setState(() {
                    selectedMaxPlaces = value!;
                  });
                },
                items: List.generate(5, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  );
                }),
                decoration: InputDecoration(
                  labelText: '일 최대 방문 장소 수',
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: textController3,
                decoration: InputDecoration(
                  labelText: '비용',
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '휴양',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text('(낮음)'),
                      Expanded(
                        child: Slider(
                          value: restSliderValue,
                          onChanged: (value) {
                            setState(() {
                              restSliderValue = _clampValue(value);
                              _adjustWeights();
                            });
                          },
                        ),
                      ),
                      const Text('(높음)'),
                    ],
                  ),
                ]
              ),
              const SizedBox(height: 8.0),
              const Text(
                '관광',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text('(낮음)'),
                      Expanded(
                        child: Slider(
                          value: prioritySliderValue,
                          onChanged: (value) {
                            setState(() {
                              prioritySliderValue = _clampValue(value);
                              _adjustWeights();
                            });
                          },
                        ),
                      ),
                      const Text('(높음)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                '먹거리',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text('(낮음)'),
                      Expanded(
                        child: Slider(
                          value: foodSliderValue,
                          onChanged: (value) {
                            setState(() {
                              foodSliderValue = _clampValue(value);
                              _adjustWeights();
                            });
                          },
                        ),
                      ),
                      const Text('(높음)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                '쇼핑',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text('(낮음)'),
                      Expanded(
                        child: Slider(
                          value: shoppingSliderValue,
                          onChanged: (value) {
                            setState(() {
                              shoppingSliderValue = _clampValue(value);
                              _adjustWeights();
                            });
                          },
                        ),
                      ),
                      const Text('(높음)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isInputValid()
                    ? () {
                  String test_question = "Hi chat GPT";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OutputPage(
                        text1: textController1.text,
                        text2:
                        "시작: ${startDate.toLocal()} 종료: ${endDate.toLocal()}",
                        text3: textController3.text,
                        selectedMaxPlaces: selectedMaxPlaces,
                        prioritySliderValue: prioritySliderValue,
                        foodSliderValue: foodSliderValue,
                        shoppingSliderValue: shoppingSliderValue,
                        restSliderValue: restSliderValue,
                        questionValue: test_question,
                      ),
                    ),
                  );
                }
                    : null,

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor:
                  _isInputValid() ? const Color(0xFFB3E5FC) : Colors.grey,

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

  double _clampValue(double value) {
    const double minValue = 0.0;
    const double maxValue = 1.0;

    return value.clamp(minValue, maxValue);
  }

  void _adjustWeights() {
    const double totalWeight = 1.0;

    double currentPriorityWeight = prioritySliderValue;
    double currentFoodWeight = foodSliderValue;
    double currentShoppingWeight = shoppingSliderValue;
    double currentRestWeight = restSliderValue;

    double currentTotalWeight =
        currentPriorityWeight + currentFoodWeight + currentShoppingWeight + currentRestWeight;

    if (currentTotalWeight != 0) {
      prioritySliderValue = (currentPriorityWeight / currentTotalWeight) * totalWeight;
      foodSliderValue = (currentFoodWeight / currentTotalWeight) * totalWeight;
      shoppingSliderValue = (currentShoppingWeight / currentTotalWeight) * totalWeight;
      restSliderValue = (currentRestWeight / currentTotalWeight) * totalWeight;
    }
  }

  bool _isInputValid() {
    return textController1.text.isNotEmpty && textController3.text.isNotEmpty;
  }
}

