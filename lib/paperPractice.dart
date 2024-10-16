import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(PaperPractice());
}

class PaperPractice extends StatefulWidget {
  const PaperPractice({Key? key}) : super(key: key);

  @override
  _PaperPracticeState createState() => _PaperPracticeState();
}

class _PaperPracticeState extends State<PaperPractice> {
  final ApiHelper apiHelper = ApiHelper();

  late Future<Map<String, dynamic>?> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<Map<String, dynamic>?> fetchData() async {
    try {
      await apiHelper.fetchDataAndStoreInPreferences();
      return await apiHelper.getDataFromSharedPreferences();
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter API and Shared Preferences Example'),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No data available');
            } else {
              // Access your data using snapshot.data
              Map<String, dynamic> data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Displaying API Data:'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String key = data.keys.elementAt(index);
                        dynamic value = data[key];
                        return ListTile(
                          title: Text('$key: $value'),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ApiHelper {
  static const String apiUrl = "https://footytv.live/apps/nfl.json";
  static const String dataKey = "api_data_key";

  Future<void> fetchDataAndStoreInPreferences() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        await saveDataToSharedPreferences(jsonData);
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<void> saveDataToSharedPreferences(Map<String, dynamic> data) async {
    try {
      String jsonDataString = json.encode(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(dataKey, jsonDataString);
    } catch (error) {
      throw Exception("Error saving data to shared preferences: $error");
    }
  }

  Future<Map<String, dynamic>?> getDataFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonDataString = prefs.getString(dataKey);
      if (jsonDataString != null) {
        Map<String, dynamic> jsonData = json.decode(jsonDataString);
        return jsonData;
      } else {
        return null;
      }
    } catch (error) {
      throw Exception("Error getting data from shared preferences: $error");
    }
  }
}
