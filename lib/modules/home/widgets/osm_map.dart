import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/common/interfaces/i_geolocation_service.dart';
import 'package:unb/common/widgets/loading_indicator.dart';

class OsmMap extends StatefulWidget {
  const OsmMap({Key? key}) : super(key: key);

  @override
  State<OsmMap> createState() => _OsmMapState();
}

class _OsmMapState extends State<OsmMap> {
  final _mapController = MapController();
  final _geoService = Modular.get<IGeolocationService>();

  final _centerCurrentLocationStreamController = StreamController<double?>();
  var _centerOnLocationUpdate = CenterOnLocationUpdate.always;

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case GroupLoaded:
            return _buildMap(state as GroupLoaded);
        }
        return const LoadingIndicator();
      },
    );
  }

  _buildMap(final GroupLoaded state) {
    final markers = state.group
        .map(
          (member) => Marker(
            point: LatLng(
              double.parse(member.address!.geo.lat),
              double.parse(member.address!.geo.lng),
            ),
            height: 40,
            width: 40,
            builder: (ctx) => CircleAvatar(
              backgroundImage: NetworkImage(member.avatarUrl!),
            ),
          ),
        )
        .toList();

    return FlutterMap(
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
        onMapReady: () async {
          final pos = await _geoService.getCurrentLocation();
          _mapController.move(LatLng(pos.latitude, pos.longitude), 19);
          _geoService.startLocationTracking();
        },
      ),
      nonRotatedChildren: [
        Positioned(
          right: 5,
          top: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.grey.shade800,
            mini: true,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              setState(
                () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
              );
              _centerCurrentLocationStreamController.add(18);
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
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
          markers: markers,
        ),
      ],
    );
  }
}
