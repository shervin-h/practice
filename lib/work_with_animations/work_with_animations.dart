import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkWithAnimations extends StatefulWidget {
  const WorkWithAnimations({Key? key}) : super(key: key);

  @override
  State<WorkWithAnimations> createState() => _WorkWithAnimationsState();
}

class _WorkWithAnimationsState extends State<WorkWithAnimations> {

  // AnimatedOpacity
  double _opacity = 1;

  // AnimatedPositioned
  double _left = 0;

  // AnimatedRotation
  double _turns = 1;

  // AnimatedScale
  double _scale = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 1000),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          _opacity = _opacity == 1 ? 0 : 1;
                        });
                      },
                      color: Colors.green,
                      icon: const Icon(CupertinoIcons.play),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Divider(thickness: 2),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        top: 0,
                        left: _left,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeIn,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                      ),

                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _left += 50;
                            });
                          },
                          color: Colors.green,
                          icon: const Icon(CupertinoIcons.play),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Divider(thickness: 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AnimatedRotation(
                      turns: _turns,
                      duration: const Duration(milliseconds: 1000),
                      onEnd: () {
                        debugPrint('onEnd Called...');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          _turns += 1;
                        });
                      },
                      color: Colors.green,
                      icon: const Icon(CupertinoIcons.play),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Divider(thickness: 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.bounceInOut,
                      onEnd: () {
                        debugPrint('Scale onEnd Called...');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          _scale = _scale == 1 ? 2 : 1;
                        });
                      },
                      color: Colors.green,
                      icon: const Icon(CupertinoIcons.play),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Divider(thickness: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
