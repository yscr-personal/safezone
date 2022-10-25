import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:unb/common/services/geolocation_service.dart';

class OsmMap extends StatefulWidget {
  const OsmMap({Key? key}) : super(key: key);

  @override
  State<OsmMap> createState() => _OsmMapState();
}

class _OsmMapState extends State<OsmMap> {
  final _mapController = MapController();
  final _geoService = Modular.get<GeolocationService>();

  final _centerCurrentLocationStreamController = StreamController<double?>();
  var _centerOnLocationUpdate = CenterOnLocationUpdate.always;

  @override
  void initState() {
    super.initState();
    _geoService.init();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onMapReady: () async {
            final pos = await _geoService.determinePosition();
            _mapController.move(LatLng(pos.latitude, pos.longitude), 18);
          },
          onPositionChanged: (MapPosition position, bool hasGesture) {
            if (hasGesture) {
              setState(
                () => _centerOnLocationUpdate = CenterOnLocationUpdate.never,
              );
            }
          },
        ),
        nonRotatedChildren: [
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () async {
                setState(
                  () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
                );
                _centerCurrentLocationStreamController.add(18);
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'br.com.unb.safezone',
            maxZoom: 19,
          ),
          CurrentLocationLayer(
            centerOnLocationUpdate: _centerOnLocationUpdate,
            centerCurrentLocationStream:
                _centerCurrentLocationStreamController.stream,
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
