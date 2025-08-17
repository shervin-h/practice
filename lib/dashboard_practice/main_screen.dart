import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("style_dart framework documentation coming soon...",
              textAlign: TextAlign.center),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/dashboard_screen');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  child: Text("Try dashboard demo"),
                )),
          )
        ],
      ),
    );
  }
}