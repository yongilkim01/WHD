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
  int selectedMaxPlaces = 1;
  final TextEditingController textController3 = TextEditingController();
  final TextEditingController textController4 = TextEditingController();
  double prioritySliderValue = 0.25; // 우선항목 슬라이더의 기본 값
  double foodSliderValue = 0.25; // 먹거리 슬라이더의 기본 값
  double shoppingSliderValue = 0.25;
  double restSliderValue = 0.25; // 쇼핑 슬라이더의 기본 값

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
                  color: Colors.black, // Customize the color
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
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                '관광',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black, // Customize the color
                ),
              ),
              // 우선항목 슬라이더
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
              // 먹거리 슬라이더
              const Text(
                '먹거리',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black, // Customize the color
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
                  color: Colors.black, // Customize the color
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OutputPage(
                          text1: textController1.text,
                          text2: "시작: ${startDate.toLocal()} 종료: ${endDate.toLocal()}",
                          text3: textController3.text,
                          selectedMaxPlaces: selectedMaxPlaces,
                          prioritySliderValue: prioritySliderValue,
                          foodSliderValue: foodSliderValue,
                          shoppingSliderValue : shoppingSliderValue,
                          restSliderValue: restSliderValue
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ), // 새로운 테마 컬러
                  backgroundColor: const Color(0xFFB3E5FC),
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

    // 현재 가중치의 합
    double currentTotalWeight = currentPriorityWeight + currentFoodWeight + currentShoppingWeight +currentRestWeight;

    // 합이 0이 아니면 각 슬라이더의 값을 조절하여 합이 1이 되도록 함
    if (currentTotalWeight != 0) {
      prioritySliderValue = (currentPriorityWeight / currentTotalWeight) * totalWeight;
      foodSliderValue = (currentFoodWeight / currentTotalWeight) * totalWeight;
      shoppingSliderValue = (currentShoppingWeight / currentTotalWeight) * totalWeight;
      restSliderValue = (currentRestWeight / currentTotalWeight) * totalWeight;
    }
  }
}