import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:prayerapp/const/appColors.dart';


class MapPage extends StatefulWidget {
  final longitude, latitude;

  const MapPage(this.longitude, this.latitude, {super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _userLocation;
  List<Marker> _mosques = [];
  late Map<String, dynamic> data1,data2,data3,finalData;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    setState(() {
      _userLocation = LatLng(widget.longitude, widget.latitude);
    });

    await _fetchMosques(); 
    _fetchMosqueNames();
  }

  Future _fetchMosques() async {
    String url1 =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/Mosque.json?proximity=${_userLocation!.longitude},${_userLocation!.latitude}&access_token=sk.eyJ1IjoiaW11c2FyYXphIiwiYSI6ImNscWZtYTNkdDB4b3gyanRrNGMxYWZicjIifQ.Hv-ZmGh-DWqaXsXTyvvKAQ';

     String url2 =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/Masjid.json?proximity=${_userLocation!.longitude},${_userLocation!.latitude}&access_token=sk.eyJ1IjoiaW11c2FyYXphIiwiYSI6ImNscWZtYTNkdDB4b3gyanRrNGMxYWZicjIifQ.Hv-ZmGh-DWqaXsXTyvvKAQ';

     String url3 =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/Jamia.json?proximity=${_userLocation!.longitude},${_userLocation!.latitude}&access_token=sk.eyJ1IjoiaW11c2FyYXphIiwiYSI6ImNscWZtYTNkdDB4b3gyanRrNGMxYWZicjIifQ.Hv-ZmGh-DWqaXsXTyvvKAQ';        
    try {
      final response1 = await http.get(Uri.parse(url1));
      final response2 = await http.get(Uri.parse(url2));
      final response3 = await http.get(Uri.parse(url3));
      if (response1.statusCode == 200 && response2.statusCode == 200 && response3.statusCode == 200) {
        data1 = jsonDecode(response1.body);
        data2 = jsonDecode(response2.body);
        data3 = jsonDecode(response3.body);

        finalData = {
          'features': []..addAll(data1['features'])..addAll(data2['features'])..addAll(data3['features']),
        };

        print(finalData);   
        setState(() {
          _mosques = (finalData['features'] as List)
              .where((feature) =>
                  (feature['properties']['category'] as String?)?.contains('Mosque') ==
                  true)
              .map<Marker>((feature) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                feature['geometry']['coordinates'][1],
                feature['geometry']['coordinates'][0],
              ),
              builder: (ctx) => Icon(
                Icons.mosque,
                size: 20,
                color: appColors.appBasic,
              ),
            );
          }).toList();
        });
      } else {
        print('Failed to load mosques: ${response1.statusCode}');
      }
    } catch (e) {
      print('Error fetching mosques: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SlidingUpPanel(
          panel: _buildPanel(),
          body: FlutterMap(
            options: MapOptions(
              center: LatLng(widget.longitude, widget.latitude),
              zoom: 15,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoiaW11c2FyYXphIiwiYSI6ImNscWZtYTNkdDB4b3gyanRrNGMxYWZicjIifQ.Hv-ZmGh-DWqaXsXTyvvKAQ',
              ),
              MarkerLayerOptions(markers: _mosques),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: appColors.appBasic,  
                  width: 2.0,  
                ),
              ),
            ),
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder<List<String>>(
        future: _fetchMosqueNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> mosqueNames = snapshot.data!;
            return ListView.builder(
              itemCount: mosqueNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selectedTileColor: Colors.grey,
                  hoverColor: appColors.appBasic,
                  splashColor: appColors.appBasic,
                  title: Text('- ${mosqueNames[index]}\n'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> _fetchMosqueNames() async {
  List<String> placeNames = [];

  if (finalData.containsKey('features')) {
    for (var feature in finalData['features']) {
      var placeName = feature['place_name'];

      if (placeName != null) {
        placeNames.add(placeName);
      }
    }
  }
  print(placeNames);

  return placeNames;
}

}


