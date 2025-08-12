import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/main.dart';
// import 'package:toolbox/toolbox.dart';


class WorkWithPackages extends StatelessWidget {
  const WorkWithPackages({super.key});

  @override
  Widget build(BuildContext context) {
    // final personalPlateKey = PlateKeys().personalPlateKey;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        // debugPrint('${personalPlateKey.currentState?.num1Controller.text} - ${personalPlateKey.currentState?.num2Controller.text} - ${personalPlateKey.currentState?.num3Controller.text}');

      },
      child: Text('click'),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // const MapWidget(
              //   latitude: 35.785843522589396,
              //   longitude: 51.317320018994764,
              //   height: 200,
              //   margin: EdgeInsets.all(20),
              // ),
              // MapLocationWidget(
              //   margin: const EdgeInsets.all(20),
              //   latitude: 35.785843522589396,
              //   longitude: 51.317320018994764,
              //   onLocationChanged: (latLng) {
              //     debugPrint(
              //         'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}');
              //   },
              // ),
              // ArmyPlate(width: 400, enable: true,),
              // GeneralPlate(width: 500, enable: true,),
              // Text(
              //   getDifferenceInDays(
              //     start: '2023-08-01',
              //     end: '2023-09-01',
              //   ),
              // ),
              // const SizedBox(height: 16),
              // RetryWidget(onPressed: () {} ,message: 'message', label: 'label',),
              // const SizedBox(height: 16),
              // DatesWidget(
              //   days: [
              //     DayModel(
              //       id: 1,
              //       name: 'دوشنبه',
              //       date: '12',
              //       isSelected: false,
              //     ),
              //     DayModel(
              //       id: 2,
              //       name: 'سه شنبه',
              //       date: '13',
              //       isSelected: true,
              //     ),
              //     DayModel(
              //       id: 3,
              //       name: 'چهار شنبه',
              //       date: '14',
              //       isSelected: false,
              //     ),
              //     DayModel(
              //       id: 4,
              //       name: 'پنج شنبه',
              //       date: '15',
              //       isSelected: false,
              //     ),
              //     DayModel(
              //       id: 5,
              //       name: 'جمعه',
              //       date: '16',
              //       isSelected: false,
              //     ),
              //   ],
              //   selectedItemColor: Colors.orange,
              //   unSelectedItemColor: Colors.white,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
