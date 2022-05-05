import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'config.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // for use of google maps api instead of webview
  // late GoogleMapController mapController;
  // final LatLng _center = const LatLng(52.237049, 21.017532);
  //
  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa turnieju'),
        // backgroundColor: Colors.green[700],
      ),
      body: WebView(
        initialUrl: mapURL,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          Completer<WebViewController>().complete(webViewController);
        },
      ),
      // to use google maps (without markers)
      // body: GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   initialCameraPosition: CameraPosition(
      //     target: _center,
      //     zoom: 11.0,
      //   ),
      // ),
    );
  }
}
