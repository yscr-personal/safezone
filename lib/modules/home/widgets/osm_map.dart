import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/interfaces/i_http_service.dart';
import 'package:unb/common/services/geolocation_service.dart';

class OsmMap extends StatefulWidget {
  const OsmMap({Key? key}) : super(key: key);

  @override
  State<OsmMap> createState() => _OsmMapState();
}

class _OsmMapState extends State<OsmMap> {
  final _mapController = MapController();
  final _geoService = Modular.get<GeolocationService>();
  final _logger = Modular.get<Logger>();
  final _httpService = Modular.get<IHttpService>();

  final _centerCurrentLocationStreamController = StreamController<double?>();
  var _centerOnLocationUpdate = CenterOnLocationUpdate.always;
  var _markers = <Marker>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pos = await _geoService.determinePosition();
      _mapController.move(LatLng(pos.latitude, pos.longitude), 18);
    });

    _geoService.init(onLocationUpdate: (position) {
      _logger.i('sending (${position.latitude}, ${position.longitude}) to SQS');
    });

    _httpService.get('/users').then(
      (value) {
        final markers = (value as List<dynamic>).map<Marker>(
          (element) => Marker(
            point: LatLng(
              double.parse(element['address']['geo']['lat']),
              double.parse(element['address']['geo']['lng']),
            ),
            builder: (ctx) => const Icon(Icons.location_history),
          ),
        );
        setState(
          () => _markers = markers.toList(),
        );
      },
    );
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
          minZoom: 3,
          maxZoom: 19,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
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
              onPressed: () {
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
            minZoom: 3,
            maxNativeZoom: 19,
            minNativeZoom: 3,
          ),
          CurrentLocationLayer(
            centerOnLocationUpdate: _centerOnLocationUpdate,
            centerCurrentLocationStream:
                _centerCurrentLocationStreamController.stream,
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
