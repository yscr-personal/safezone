import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/common/cubits/websocket/websocket_cubit.dart';
import 'package:unb/common/services/protocols/i_geolocation_service.dart';
import 'package:unb/common/widgets/loading_indicator.dart';

class OsmMap extends StatefulWidget {
  final MapController mapController;

  const OsmMap({Key? key, required this.mapController}) : super(key: key);

  @override
  State<OsmMap> createState() => _OsmMapState();
}

class _OsmMapState extends State<OsmMap> {
  final _geoService = Modular.get<IGeolocationService>();
  final _authCubit = Modular.get<AuthCubit>();
  final _websocketCubit = Modular.get<WebsocketCubit>();

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
    final markers = state.selected?.members
        ?.where(
          (m) =>
              (m.lastLatitude != null && m.lastLongitude != null) &&
              (m.id != (_authCubit.state as AuthLoaded).user.id),
        )
        .map(
          (member) => Marker(
            point: LatLng(
              member.lastLatitude!,
              member.lastLongitude!,
            ),
            height: 40,
            width: 40,
            builder: (ctx) => CircleAvatar(
              foregroundImage: NetworkImage(
                'https://picsum.photos/${int.parse(member.id.substring(0, 2), radix: 16)}',
              ),
              // MemoryImage(base64Decode(member.profilePicture!)),
            ),
          ),
        )
        .toList();

    return FlutterMap(
      mapController: widget.mapController,
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
          widget.mapController.move(LatLng(pos.latitude, pos.longitude), 19);
          _geoService.startLocationTracking(
            onLocationUpdate: (location) {
              _websocketCubit.sendLocationUpdate(
                (_authCubit.state as AuthLoaded).user.id,
                LatLng(location.latitude, location.longitude),
              );
            },
          );
        },
      ),
      nonRotatedChildren: [
        Positioned(
          right: 5,
          top: 20,
          child: FloatingActionButton(
            heroTag: '<FloatingActionButton logout>',
            backgroundColor: Colors.grey.shade800,
            mini: true,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              _authCubit.logout();
              Modular.to.pushReplacementNamed('/auth/');
            },
            child: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ),
        Positioned(
          right: 5,
          top: 80,
          child: FloatingActionButton(
            heroTag: '<FloatingActionButton center>',
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
          style: LocationMarkerStyle(
            marker: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://picsum.photos/${int.parse((_authCubit.state as AuthLoaded).user.id.substring(0, 2), radix: 16)}',
              ),
              // MemoryImage(
              //   base64Decode(member.profilePicture!),
              // ),
            ),
            markerSize: const Size(30, 30),
          ),
        ),
        MarkerLayer(
          markers: markers ?? [],
        ),
      ],
    );
  }
}
