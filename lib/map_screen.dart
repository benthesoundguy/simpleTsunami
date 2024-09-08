import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'tsunami_data_service.dart'; // Ensure this import is present

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Marker> _tsunamiMarkers = [];

  @override
  void initState() {
    super.initState();
    TsunamiDataService().fetchTsunamiData().then((data) {
      setState(() {
        _tsunamiMarkers = data
            .where((event) => event['latitude'] != null && event['longitude'] != null)
            .map<Marker>((event) {
          final latitude = double.parse(event['latitude'].toString());
          final longitude = double.parse(event['longitude'].toString());
          print('Creating marker for event: $event'); // Add this line for debugging
          return Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(latitude, longitude),
            builder: (ctx) => Container(
              child: Icon(Icons.warning, color: Colors.red),
            ),
          );
        }).toList();
      });
    }).catchError((error) {
      print('Error fetching tsunami data: $error'); // Add this line for debugging
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vector Map'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(37.7749, -122.4194), // Example coordinates (San Francisco)
          zoom: 10.0,
          minZoom: 2.0, // Allow zooming out farther
          maxZoom: 18.0,
          interactiveFlags: InteractiveFlag.all, // Enable all gestures
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _tsunamiMarkers,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Zoom in
              _mapController.move(_mapController.center, _mapController.zoom + 1);
            },
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              // Zoom out
              _mapController.move(_mapController.center, _mapController.zoom - 1);
            },
            child: Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
