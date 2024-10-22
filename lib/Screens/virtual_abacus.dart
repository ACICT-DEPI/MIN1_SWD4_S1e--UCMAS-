import 'dart:math';

import 'package:flutter/material.dart';

class VirtualAbacus extends StatefulWidget {
  const VirtualAbacus({super.key});

  @override
  State<VirtualAbacus> createState() => _VirtualAbacusState();
}

class _VirtualAbacusState extends State<VirtualAbacus> {
  final frameGradient = const LinearGradient(
    colors: [Color(0xffd6ae7b), Color(0xffeacda3), Color(0xffd6ae7b)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  final beadGradient =
  const RadialGradient(center: Alignment(-0.4, -0.4), radius: 1, colors: [
    Colors.white,
    Color(0xFFC3C5FF),
    Color(0xFF9DA0EE),
  ]);

  var _value = 0;
  late CustomGradient _gradientPainter;
  bool _isTopBeadUp = true;
  List<bool> _isBottomBeadsUp = List.generate(4, (_) => false);
  Random random = Random();

  Color get _randomColor => Color(0xFF000000 + random.nextInt(0x00FFFFFF));

  @override
  void initState() {
    super.initState();
    _gradientPainter = CustomGradient(gradient: frameGradient, radius: 5);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final beadHeight = height * 0.09;
    final beadWidth = beadHeight * 1.6;

    return Scaffold(
        appBar: AppBar(
          actions: const [],
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: CustomPaint(
                  painter: _gradientPainter,
                  child: SizedBox(
                    width: beadWidth * 1.5,
                    height: beadHeight * 7.65,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: beadHeight * 0.05),
                          child: Container(
                            width: beadWidth * 0.1,
                            decoration: BoxDecoration(
                              gradient: frameGradient,
                            ),
                          ),
                        ),
                        Positioned(
                          top: beadHeight * 2.2,
                          child: Container(
                            width: beadWidth * 1.2,
                            height: beadWidth * 0.1,
                            decoration: BoxDecoration(
                              gradient: frameGradient,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.decelerate,
                          top: _isTopBeadUp ? beadHeight * .285 : beadHeight * 1.2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isTopBeadUp = !_isTopBeadUp;
                                _value += (_isTopBeadUp ? -5 : 5);
                              });
                            },
                            child: Bead(
                              width: beadWidth,
                              height: beadHeight,
                              color: beadGradient,
                            ),
                          ),
                        ),
                        ...List.generate(4, (index) {
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.decelerate,
                            bottom: beadHeight * (3 - index) +
                                (_isBottomBeadsUp[index] ? beadHeight : 0) +
                                beadWidth * .185,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_isBottomBeadsUp[index]) {
                                    for (int i = index; i < 4; i++) {
                                      if (_isBottomBeadsUp[i]) {
                                        _isBottomBeadsUp[i] = false;
                                        _value--;
                                      }
                                    }
                                  } else {
                                    for (int i = index; i >= 0; i--) {
                                      if (!_isBottomBeadsUp[i]) {
                                        _isBottomBeadsUp[i] = true;
                                        _value++;
                                      }
                                    }
                                  }
                                });
                              },
                              child: Bead(
                                width: beadWidth,
                                height: beadHeight,
                                color: beadGradient,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )),
            Center(
              child: Container(
                width: beadWidth * 1.5,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black, width: min(width, height) * 0.01),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_value',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: beadHeight, color: _randomColor),
                ),
              ),
            ),
          ],
        ));
  }
}

class CustomGradient extends CustomPainter {
  CustomGradient({required this.gradient, required this.radius});

  late double sWidth;
  final double radius;
  final Gradient gradient;
  final Paint outerP = Paint();
  final Paint innerP = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    sWidth = size.width * 0.05;
    RRect innerRect = RRect.fromLTRBR(sWidth, sWidth, size.width - sWidth,
        size.height - sWidth, Radius.circular(radius));
    RRect outerRect = RRect.fromRectAndRadius(
        Offset.zero & size, Radius.circular(radius * 1.5));

    outerP.shader = gradient.createShader(outerRect.outerRect);
    innerP.color = Colors.white;
    canvas.drawRRect(outerRect, outerP);
    canvas.drawRRect(innerRect, innerP);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Bead extends StatelessWidget {
  final double width;
  final double height;
  final Gradient color;

  const Bead(
      {super.key,
        required this.width,
        required this.height,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BeadClipper(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(gradient: color),
      ),
    );
  }
}

class BeadClipper extends CustomClipper<Path> {
  final path = Path();

  @override
  Path getClip(Size size) {
    path.moveTo(size.width / 4, 0);
    path.arcToPoint(Offset(size.width / 4, size.height),
        radius: Radius.elliptical(size.width / 4, size.height / 2),
        clockwise: false);
    path.lineTo(size.width * 3 / 4, size.height);
    path.arcToPoint(Offset(size.width * 3 / 4, 0),
        radius: Radius.elliptical(size.width / 4, size.height / 2),
        clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
