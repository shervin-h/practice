import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/practice_designs/my_painter.dart';

class PracticeDesignScreen extends StatefulWidget {
  const PracticeDesignScreen({super.key});

  @override
  State<PracticeDesignScreen> createState() => _PracticeDesignScreenState();
}

class _PracticeDesignScreenState extends State<PracticeDesignScreen> {
  bool _enable = false;
  double _width = 0;
  double _height = 48;
  double _opacity = 0;

  void _updatePosition(Offset newPosition) {
    setState(() {
      // محدود کردن موقعیت درگ در بازه خاص
      if (newPosition.dx >= 150) {
        _enable = true;
      } else {
        _enable = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        _width = 103;
        _height = 48;
        setState(() {});
      },
    );
  }

  Color _backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CupertinoSlidingSegmentedControl<String>(
          onValueChanged: (String? value) {
            if (value == 'light') {
              _backgroundColor = Colors.white;
            } else {
              _backgroundColor = Colors.grey.shade800;
            }
            setState(() {});
          },
          children: const {
            'light': Text('light'),
            'dark': Text('dark')
          },
        ),
      ),
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(width: double.infinity, height: 40),
            Container(
              padding: const EdgeInsets.all(4),
              width: 339,
              height: 68,
              alignment: !_enable
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: const Color(0xffFDF6E0),
              ),
              child: Stack(
                alignment: !_enable
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 32, height: 32),
                      const Expanded(child: SizedBox()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'بکش شارژ شو',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontFamily: 'Yekan',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF424242),
                                ),
                          ),
                          Text(
                            '۰۹۱۹۹۵۵۸۸۹۹',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontFamily: 'Yekan',
                                  fontSize: 16,
                                  color: const Color(0xFF757575),
                                ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(200),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Color(0xFF1C1C1E),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                  Draggable(
                    axis: Axis.horizontal,
                    affinity: Axis.horizontal,
                    hitTestBehavior: HitTestBehavior.opaque,
                    onDragEnd: (draggableDetails) {
                      _updatePosition(draggableDetails.offset);
                    },
                    onDragUpdate: (details) {},
                    feedback: Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.double_arrow,
                        color: Colors.white,
                      ),
                    ),
                    childWhenDragging: const SizedBox(),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.double_arrow,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: kToolbarHeight),
            Container(
              width: 335,
              height: 56,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFDF6E0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    const PositionedDirectional(
                      end: 16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'شارژ ۱۰۰۰۰ تومانی',
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '۰۹۱۹۹۵۵۸۸۹۹',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PositionedDirectional(
                      start: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        onEnd: () {
                          _opacity = 1;
                          setState(() {});
                        },
                        width: _width,
                        height: _height,
                        child: CustomPaint(
                          painter: MyPainter(
                            lineColor: const Color(0xFFF0B800),
                            thickness: 8,
                            fill: true,
                            bgColor: const Color(0xFFF0B800),
                            distanceFromTipTrapezoid: 80,
                          ),
                          child: Center(
                            child: Opacity(
                              opacity: _opacity,
                              child: const Text(
                                'شارژ سریع',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DragWidget extends StatelessWidget {
  const DragWidget({required this.start, super.key});

  final double start;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: start),
      height: 54,
      width: 54,
      decoration: const BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.double_arrow,
        color: Colors.white,
      ),
    );
  }
}
