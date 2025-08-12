import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkWithAnimationController extends StatefulWidget {
  const WorkWithAnimationController({Key? key}) : super(key: key);

  @override
  State<WorkWithAnimationController> createState() => _WorkWithAnimationControllerState();
}

class _WorkWithAnimationControllerState extends State<WorkWithAnimationController> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 1,
      lowerBound: 0,
    );
    _colorTween = ColorTween(begin: Colors.orange, end: Colors.green).animate(_animationController);
    // _animationController.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work with Animation Controller'), centerTitle: true,),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _colorTween.value,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_animationController.isCompleted) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        },
        child: const Icon(
          CupertinoIcons.play,
          color: Colors.green,
        ),
      ),
    );
  }
}
