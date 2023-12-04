import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

Future<String> generateText(String prompt) async {
  String apiKey = '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';
  String apiUrl = 'https://api.openai.com/v1/completions';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json','Authorization': 'Bearer $apiKey'},
    body: jsonEncode({
      "model": "text-davinci-003",
      'prompt': prompt,
      'max_tokens': 1000,
      'temperature': 0,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0
    }),
  );

  Map<String, dynamic> newresponse = jsonDecode(utf8.decode(response.bodyBytes));

  return newresponse['choices'][0]['text'];
}

class OutputPage extends StatefulWidget {
  final String text1, text2, text3, questionValue;
  final double prioritySliderValue;
  final double foodSliderValue;
  final double shoppingSliderValue;
  final double restSliderValue;
  final int selectedMaxPlaces;

  const OutputPage({super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.selectedMaxPlaces,
    required this.prioritySliderValue,
    required this.foodSliderValue,
    required this.shoppingSliderValue,
    required this.restSliderValue,
    required this.questionValue,
  });

  @override
  _OutputPageState createState() => _OutputPageState(
      text1: text1,
      text2: text2,
      text3: text3,
      selectedMaxPlaces: selectedMaxPlaces,
      prioritySliderValue: prioritySliderValue,
      foodSliderValue: foodSliderValue,
      shoppingSliderValue: shoppingSliderValue,
      restSliderValue: restSliderValue,
      questionValue: questionValue
  );
}

class _OutputPageState extends State<OutputPage> {
  final String text1, text2, text3, questionValue;
  List<Map<String, dynamic>> data = [];
  Random random = Random();
  int selectedMaxPlaces;
  double prioritySliderValue;
  double foodSliderValue;
  double shoppingSliderValue;
  double restSliderValue;

  _OutputPageState({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.selectedMaxPlaces,
    required this.prioritySliderValue,
    required this.foodSliderValue,
    required this.questionValue,
    required this.shoppingSliderValue,
    required this.restSliderValue
  }) : super() {
    // 필드 초기화를 생성자에서 수행
    prioritySliderValue = prioritySliderValue;
    foodSliderValue = foodSliderValue;
    shoppingSliderValue = shoppingSliderValue;
    restSliderValue = restSliderValue;
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    setState(() {
      data = List<Map<String, dynamic>>.from(jsonList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00000),
        leading: const Icon(Icons.list, size: 37),
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
                text: '에 대해 추천해드릴게요!',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.manage_accounts, size: 37),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<List<String>>(
              future: getImageUrls("$text1 관광명소"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('$text1에 대한 이미지 로딩 중 오류 발생: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('$text1에 대한 이미지가 없습니다.');
                } else {
                  List<String> imageUrls = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6,
                    ),
                    shrinkWrap: true,
                    itemCount: min(imageUrls.length, 4),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.warning, color: Colors.red)),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Text("위는 $text1의 유명한 명소들의 사진입니다.", style: const TextStyle(fontSize: 13)),
            FutureBuilder<String>(
              future: generateText(questionValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('${snapshot.data}', style: const TextStyle(fontSize: 13));
                }
              },
            ),
            const SizedBox(height: 8.0,),
            buildPlanList(),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getImageUrls(String query) async {
    const String apiKey = 'AIzaSyBW2byc3ChYykgo61BH8TFbuao56TyNPBs';
    const String cx = 'a378f93229fc3407b';
    final String endpoint = 'https://www.googleapis.com/customsearch/v1?q=$query&cx=$cx&key=$apiKey&searchType=image&num=10';

    try {
      final response = await http.get(Uri.parse(endpoint));
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> items = jsonResponse['items'];

      List<String> validImageUrls = [];

      for (var item in items) {
        final String imageUrl = item['link'];
        if (await _isValidImageUrl(imageUrl)) {
          validImageUrls.add(imageUrl);
        }
      }

      return validImageUrls;
    } catch (e) {
      print('이미지 로딩 중 오류 발생: $e');
      return [];
    }
  }

  Future<bool> _isValidImageUrl(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Widget buildPlanList() {
    Map<String, List<String>> groupedPlans = {};

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedPlans.entries.map((entry) {
        final String groupKey = entry.key;
        final List<String> plans = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(groupKey, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...plans.map((plan) => Text(
              '  $plan',
              style: const TextStyle(fontSize: 14),
              softWrap: true,
            )
            ),
          ],
        );
      }).toList(),
    );
  }
}