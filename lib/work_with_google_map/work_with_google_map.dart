import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorkWithGoogleMap extends StatefulWidget {
  const WorkWithGoogleMap({Key? key}) : super(key: key);

  @override
  State<WorkWithGoogleMap> createState() => _WorkWithGoogleMapState();
}

class _WorkWithGoogleMapState extends State<WorkWithGoogleMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Map'), centerTitle: true,),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
