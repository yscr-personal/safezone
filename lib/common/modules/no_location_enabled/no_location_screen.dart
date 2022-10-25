import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';

class NoLocationServiceScreen extends StatefulWidget {
  const NoLocationServiceScreen({Key? key}) : super(key: key);

  @override
  State<NoLocationServiceScreen> createState() =>
      _NoLocationServiceScreenState();
}

class _NoLocationServiceScreenState extends State<NoLocationServiceScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Geolocator.checkPermission().then((value) {
        if (value == LocationPermission.always ||
            value == LocationPermission.whileInUse) {
          Modular.to.pushReplacementNamed('/home/');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This app needs your exact location!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.my_location,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('Allow always'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('or'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.share_location,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('Allow while using the app'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              child: const Text('Enable it in your device settings'),
            ),
          ],
        ),
      ),
    );
  }
}
