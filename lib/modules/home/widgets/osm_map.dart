import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class OsmMap extends StatelessWidget {
  final mapController = MapController();

  OsmMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onMapReady: () => mapController.move(
            LatLng(51.5, -0.09),
            13.0,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'br.com.unb.safezone',
          ),
          CurrentLocationLayer(

          ),
        ],
      ),
    );
  }
}