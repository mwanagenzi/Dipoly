import 'package:dipoly/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _animationController?.forward();

    final curvedAnimation = CurvedAnimation(
            parent: _animationController!,
            curve: Curves.bounceIn,
            reverseCurve: Curves.easeIn);

        animation = Tween<double>(
          begin: 0,
          end: 2 * math.pi,
          //nesting curved animation over the initial animation
        ).animate(curvedAnimation)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //TODO enable the gesture detector
            } else if (status == AnimationStatus.forward) {
              //TODO disable the gesture detector
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    //TODO return the dice along with its value as a widget
    return Scaffold(
      body: RotatingTransition(
          rotatingWidget: const DicePage(), rotationAngle: animation!),
    );
  }
}

class RotatingTransition extends StatelessWidget {
  final Widget rotatingWidget;
  final Animation<double>? rotationAngle;

  const RotatingTransition(
      {required this.rotatingWidget, required this.rotationAngle});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: rotationAngle!,
        child: rotatingWidget,
        builder: (context, rotatingWidget) {
          return Transform.rotate(
              angle: rotationAngle!.value, child: rotatingWidget);
        });
  }
}

//TODO: init state to have a random roll

//TODO fix rotation problem of entire page