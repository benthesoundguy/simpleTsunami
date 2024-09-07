import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

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