import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyMaps extends StatefulWidget {
  @override
  _MyMapsState createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  final List<Marker> _markers = [];
  LatLng _initialPosition = LatLng(15.3902, 73.8547);
  GoogleMapController _controller;
  Location _location = Location();

  Address address;

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    _location.onLocationChanged.listen((event) async {
      LatLng locat = LatLng(event.latitude, event.longitude);
      final coordinates = new Coordinates(event.latitude, event.longitude);
      address = (await Geocoder.local.findAddressesFromCoordinates(coordinates))
          .first;
      print('called');
      _markers.add(
        Marker(
          markerId: MarkerId('id'),
          position: locat,
          infoWindow: InfoWindow(
              title: '${address.addressLine}', snippet: '${address.adminArea}'),
        ),
      );
      if (this.mounted) setState(() {});
    });
  }

  void _onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
    _location.getLocation().then((event) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 15,
          ),
        ),
      );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 10,
            ),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            onCameraIdle: () {
              print('idle');
            },
            markers: Set.from(_markers),
          ),
        ],
      ),
    );
  }
}
