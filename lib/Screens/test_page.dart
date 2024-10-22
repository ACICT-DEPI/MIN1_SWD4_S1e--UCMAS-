import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:uc_mas_app/Screens/result_page.dart';
import 'package:uc_mas_app/components/test_types.dart';

class TestPage extends StatefulWidget {
  final TestType testType;

  const TestPage({super.key, required this.testType});

  @override
  State<TestPage> createState() => _TestState();
}

class _TestState extends State<TestPage> with SingleTickerProviderStateMixin {
  int _timeRemaining = 20; // for test
  //int _timeRemaining = 480; // 8 minutes in seconds
  int _questionIndex = 0;
  List _wrongAnswer = [];
  List _correctAnswer = [];
  bool _submitEnabled = false;
  List<List<int>> _wrongAnswersQuestions = [];
  String _result = "", _enteredAnswers = "";
  late Iterable<int> _questionList;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  late Color _testColor;
  final random = Random();
  final List<int> _numbers = List.generate(18, (i) => i - ((i < 9) ? 9 : 8));
  final List<Color> _testColors = [
    Color(0xFFFFBF3E),  // "#ffbf3e"
    Color(0xFFF6897F),  // "#f6897f"
    Color(0xFF98DDEF),  // "#98ddef"
    Color(0xFFEBB7C4),  // "#ebb7c4"
    Color(0xFF137E86),  // "#137e86"
    Color(0xFF60C5A8),  // "#60c5a8"
    Color(0xFFD54873),  // "#d54873"
    Color(0xFFE27AA5),  // "#e27aa5"
    Color(0xFFE97B11),  // "#e97b11"
    Color(0xFFFFBF3E),  // "#ffbf3e"
  ];
  @override
  void initState() {
    super.initState();
    _testColor =
        (_testColors.toList()..shuffle(random)).first.withOpacity(0.8);
    _controller =
        AnimationController(vsync: this, duration: const Duration(minutes: 8));
    _animation = Tween(begin: 0.0, end: 2 * pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    startTest();
  }

  void startTest() {
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
                correctCount: _questionIndex - _wrongAnswer.length-1,
                wrongAnswers: _wrongAnswer,
                correctAnswers: _correctAnswer,
                wrongAnswersQuestion: _wrongAnswersQuestions,
                resultColor: _testColor),

          ),
        );
      }
    });
  }

  Iterable<int> question(bool isBasic) sync* {
    int testSize = (_questionIndex <= 30
        ? 3
        : _questionIndex <= 70
        ? 4
        : _questionIndex <= 120
        ? 5
        : _questionIndex <= 180
        ? 6
        : 7);
    int currentNum = _numbers[random.nextInt(8) + 9];
    int sum = currentNum;
    late List<int> basic, fr, frIndexes;
    late int frCnt;
    yield currentNum;
    testSize--;
    if (!isBasic) {
      frIndexes = List.generate(testSize, (i) => i);
      frCnt = random.nextInt(testSize) + 1;
      frIndexes.shuffle();
      frIndexes.removeRange(frCnt, testSize);
    }
    while (testSize-- > 0) {
      if (sum < 5) {
        fr = [
          for (int i = 5 - sum; i < 5; i++)
            if (i != 0) i
        ];
      } else {
        fr = [
          for (int i = -4; i <= 4 - sum; i++)
            if (i != 0) i
        ];
      }
      basic = [
        ..._numbers.getRange(9 - sum, 18 - sum).where((i) => !fr.contains(i))
      ];
      if (isBasic) {
        currentNum = basic[random.nextInt(basic.length)];
      } else {
        if (fr.isNotEmpty && (frIndexes.contains(testSize) || sum == 0 || sum == 9)) {
          currentNum = fr[random.nextInt(fr.length)];
        } else {
          currentNum = basic[random.nextInt(basic.length)];
        }
      }
      sum += currentNum;
      yield currentNum;
    }
  }

  void generateQuestion() {
    setState(() {
      _questionIndex++;
      _questionList = List.from(question(widget.testType.questionType));
      int calculatedResult = 0;
      for (final number in _questionList) {
        calculatedResult += number;
      }
      _result = calculatedResult.toString();
      _enteredAnswers = "";
    });
  }

  void checkAnswer() {
    if (_enteredAnswers != _result) {
      _wrongAnswer.add(_enteredAnswers);
      _correctAnswer.add(_result);
      _wrongAnswersQuestions.add(List.from(_questionList));
    }
    generateQuestion();
    setState(() {
      _submitEnabled = false;
    });
  }

  String getTimeString() {
    int minutes = _timeRemaining ~/ 60;
    int seconds = _timeRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final isRotate =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    if (_timeRemaining != 0) {
      _controller.forward();
    } else {
      _controller.stop();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("UC MAS")),
          backgroundColor: _testColor,
        ),
        body: Padding(
          padding: EdgeInsets.all(screenSize * .04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Clock
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.black),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: CustomPaint(
                                painter: TimerFillPainter(
                                    radius: _animation.value,
                                    color: _testColor),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..rotateZ(_animation.value),
                                child: CustomPaint(
                                  painter: TimerHandlePainter(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    getTimeString(),
                    style: TextStyle(fontSize: screenSize * .04),
                  ),
                ],
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                child: Container(
                  height: screenSize * 0.01,
                  child: LinearProgressIndicator(
                    value: _timeRemaining / 480,
                    backgroundColor: Colors.grey[300],
                    color: _timeRemaining <= 50 ? Colors.red : _testColor,
                  ),
                ),
              ),
              Expanded(
                child: LayoutGrid(
                  columnSizes: isRotate ? [auto, auto] : [auto],
                  rowSizes: isRotate ? [auto] : [auto, auto],
                  rowGap: 10,
                  columnGap: 20,
                  children: _buildTestUI(screenSize,isRotate),
                ),
                // child:
                // // MediaQuery.of(context).size.height<200?
                // // SingleChildScrollView(
                // //     child: Column(children:_buildTestUI(screenSize,isRotate))
                // // )
                // //     :
                // isRotate?
                // Row(children: _buildTestUI(screenSize,isRotate)):
                // Column(children:  _buildTestUI(screenSize,isRotate)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTestUI(double screenSize,bool isRotate) {
    return [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(maxHeight: screenSize*0.4, maxWidth: screenSize*0.2),
                decoration: BoxDecoration(
                  border:
                  Border.all(color: _testColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenSize * .02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ..._questionList.map((number) =>
                          FittedBox(
                            fit: BoxFit.scaleDown,
                              child: Text('$number', style: TextStyle(fontSize: screenSize*0.05),))
                      ),
                      Container(
                        width: screenSize*0.08,
                        height: screenSize*0.06,
                        decoration: BoxDecoration(
                          color: _testColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _enteredAnswers,
                            style: TextStyle(
                                fontSize: screenSize*0.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      LayoutGrid(
        columnSizes: [1.fr, 1.fr, 1.fr],
        rowSizes: const [auto, auto, auto, auto],
        rowGap: 8,
        columnGap: 8,
        children: [
          ...List.generate(9, (index) {
            return _buildNumberButton(index + 1, screenSize - (isRotate?100:250));
          }),
          const SizedBox(),
          _buildNumberButton(0, screenSize - (isRotate?100:250)),
          _buildConfirmButton(screenSize - (isRotate?100:250)),
        ],
      ),
    ];
  }

  Widget _buildNumberButton(int number, double screenSize) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _enteredAnswers = number.toString();
          _submitEnabled = true;
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, double.infinity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          number.toString(),
          style: TextStyle(color: _testColor,fontSize: screenSize*0.05),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(double screenSize) {
    return ElevatedButton(
      onPressed: _submitEnabled ? checkAnswer : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, double.infinity),
        backgroundColor: _submitEnabled ? _testColor : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Icon(
          size: screenSize*0.05,
            Icons.check,
            color: _submitEnabled ? Colors.white : _testColor
        ),
      ),
    );
  }
}


class TimerFillPainter extends CustomPainter {
  final double radius;
  final Color color;

  TimerFillPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Rect arcRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(arcRect, size.width / 2, radius, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TimerHandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Offset circleCenter = Offset(size.width / 2, size.height / 2);
    Offset rectCenter = Offset(size.width * 0.52, 0);
    Rect handleRect = Rect.fromCenter(
        center: rectCenter, width: size.width, height: size.height);
    canvas.drawCircle(circleCenter, size.width * 0.08, paint);
    canvas.drawArc(handleRect, pi / 2 - 0.05, 0.2, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension QuestionType on TestType {
  bool get questionType {
    switch(this) {
      case TestType.level1:
        return Random().nextBool();
      case TestType.level1_1:
        return true;
      case TestType.level1_2:
        return false;
    }
  }
}