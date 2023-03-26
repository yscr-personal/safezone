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
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/services/protocols/i_geolocation_service.dart';
import 'package:unb/common/widgets/loading_indicator.dart';
import 'package:unb/modules/home/widgets/group_selector.dart';
import 'package:unb/modules/home/widgets/osm_map/osm_map_service.dart';

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
  final _mapService = Modular.get<MapService>();

  final _centerCurrentLocationStreamController = StreamController<double?>();
  var _centerOnLocationUpdate = CenterOnLocationUpdate.always;

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    _geoService.stopLocationTracking();
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
        .map((member) => _buildMemberMarker(member))
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
          top: MediaQuery.of(context).padding.top + 20,
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
          top: MediaQuery.of(context).padding.top + 80,
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
        state.selected?.id != null
            ? Positioned(
                right: 5,
                top: MediaQuery.of(context).padding.top + 140,
                child: FloatingActionButton(
                  heroTag: '<FloatingActionButton chat>',
                  backgroundColor: Colors.grey.shade800,
                  mini: true,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onPressed: () {
                    Modular.to.pushNamed('/chat/${state.selected!.id}');
                  },
                  child: const Icon(
                    Icons.chat_bubble,
                    color: Colors.lightGreen,
                  ),
                ),
              )
            : Container(),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
              child: const GroupSelector(),
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
              backgroundImage: _mapService
                  .getMemberImage((_authCubit.state as AuthLoaded).user),
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

  Marker _buildMemberMarker(final UserModel member) {
    return Marker(
      point: LatLng(
        member.lastLatitude!,
        member.lastLongitude!,
      ),
      height: 40,
      width: 40,
      builder: (ctx) => CircleAvatar(
        foregroundImage: _mapService.getMemberImage(member),
      ),
    );
  }
}
