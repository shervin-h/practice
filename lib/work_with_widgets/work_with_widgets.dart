import 'package:flutter/material.dart';

class WorkWithWidgets extends StatelessWidget {
  const WorkWithWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(),
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.orange,
                ),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
                Flexible(
                  child: Container(
                    height: 100,
                    color: Colors.green,
                    child: Text('masalan ye matne toolani az khodam dar mikonam bebinam raftar een widget flexible chetore'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
