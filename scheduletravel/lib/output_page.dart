import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

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
            FutureBuilder<List<String>>(
              future: getImageUrls(text1 + "관광명소"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
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
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: imageUrls[index],
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                  );
                }
              },
            ),
            Text("위는 $text1의 유명한 명소들의 사진입니다.", style: TextStyle(fontSize: 13)),
            buildPlanList(),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getImageUrls(String query) async {
    final String apiKey = 'AIzaSyBW2byc3ChYykgo61BH8TFbuao56TyNPBs'; // Google Cloud Console에서 발급받은 API 키로 교체
    final String cx = 'a378f93229fc3407b'; // Google Custom Search Engine에서 만든 엔진의 cx 값으로 교체
    final String endpoint = 'https://www.googleapis.com/customsearch/v1?q=$query&cx=$cx&key=$apiKey&searchType=image&num=6';

    try {
      final response = await http.get(Uri.parse(endpoint));
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> items = jsonResponse['items'];

      return List<String>.from(items.map((item) => item['link']));
    } catch (e) {
      print('이미지 로딩 중 오류 발생: $e');
      return [];
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
            Text('$groupKey', style: TextStyle(fontWeight: FontWeight.bold)),
            ...plans.map((plan) => Text('  $plan')),
          ],
        );
      }).toList(),
    );
  }
}
