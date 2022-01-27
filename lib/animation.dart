import 'package:dipoly/dice.dart';
import 'package:flutter/material.dart';
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
  int _leftDiceValue = 1;
  int _rightDiceValue = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    /*TODO: set bouncing in function, different duration for individual bouncing effect*/

    final curvedAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeOut,
    );

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
      //nesting curved animation over the initial animation
    ).animate(curvedAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController!.forward();
        } else if (status == AnimationStatus.forward) {
          //TODO disable the gesture detector
        }
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('Dipoly'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (animation!.isDismissed) {
                  _animationController!.forward();
                  _diceValueSetter();
                } else if (animation!.status == AnimationStatus.completed) {
                  //TODO: enable tap functionality
                  _animationController!.reverse();
                  _diceValueSetter();
                }
                
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RotatingTransition(
                    rotationAngle: animation!,
                    rotatingWidget: Image(
                        image: AssetImage('asset/dice$_leftDiceValue.png'),
                        width: 150,
                        height: 150),
                  ),
                  RotatingTransition(
                    rotationAngle: animation!,
                    rotatingWidget: Image(
                      image: AssetImage('asset/dice$_rightDiceValue.png'),
                      width: 150,
                      height: 150,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // RotatingTransition(
      //     rotatingWidget: const DicePage(), rotationAngle: animation!),
    );

  }
  void _diceValueSetter(){
    setState(() {
      _leftDiceValue = math.Random().nextInt(6) + 1;
      _rightDiceValue = math.Random().nextInt(6) + 1;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController!.dispose();
    super.dispose();
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
