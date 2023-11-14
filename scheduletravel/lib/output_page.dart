import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class OutputPage extends StatefulWidget {
  final String text1, text2, text3, text4;

  OutputPage({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  _OutputPageState createState() => _OutputPageState(
    text1: text1,
    text2: text2,
    text3: text3,
    text4: text4,
  );
}

class _OutputPageState extends State<OutputPage> {
  final String text1, text2, text3, text4;
  List<Map<String, dynamic>> data = [];

  _OutputPageState({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String jsonString =
    await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    setState(() {
      data = List<Map<String, dynamic>>.from(jsonList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff69665d),
        leading: const Icon(Icons.list, color: Color(0xffc4a031), size: 37),
        title: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: text1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xfffcba03),
                ),
              ),
              const TextSpan(
                text: ' 에 대해 추천해드릴게요!',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.manage_accounts, color: Color(0xffc4a031), size: 37),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 1.6,
              children: <Widget>[
                Image.asset('assets/sight1.jpeg'),
                Image.asset('assets/sight2.jpeg'),
                Image.asset('assets/sight3.jpeg'),
                Image.asset('assets/sight4.jpeg'),
              ],
            ),
            Text("위는 " + text1 + "의 유명한 명소들의 사진입니다.", style: TextStyle(fontSize: 13)),
            buildPlanList(),
          ],
        ),
      ),
    );
  }

  Widget buildPlanList() {
    Map<String, List<String>> groupedPlans = {};

    // 날짜를 기준으로 계획을 그룹화
    data.forEach((item) {
      final String date = item['date'] ?? 'No Date';
      final String time = item['time'] ?? 'No Time';
      final String plan = item['plan'] ?? 'No Plan';
      final String theme = item['theme'] ?? 'No Theme';

      final String groupKey = '$date: $theme';
      final String planText = '$time: $plan';

      if (groupedPlans.containsKey(groupKey)) {
        groupedPlans[groupKey]!.add(planText);
      } else {
        groupedPlans[groupKey] = [planText];
      }
    });

    // 그룹화된 계획을 출력
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 여기를 CrossAxisAlignment.start로 변경
      children: groupedPlans.entries.map((entry) {
        final String groupKey = entry.key;
        final List<String> plans = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$groupKey', style: TextStyle(fontWeight: FontWeight.bold)),
            ...plans.map((plan) => Text('  $plan')),
          ],
        );
      }).toList(),
    );
  }
}

