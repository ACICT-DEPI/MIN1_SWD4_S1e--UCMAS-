import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:uc_mas_app/Screens/result_page.dart';

void main() {
  runApp(const TestPage());
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestState();
}

class _TestState extends State<TestPage> {
  int timeRemaining = 600; // 10 minutes in seconds
  int questionIndex = 0;
  int correctAnswers = 0;
  bool testStarted = false;
  String result = "", enteredAnswer = "";
  Timer? _timer;
  List<Widget> questionWidgets = [];

  @override
  void initState() {
    super.initState();
    startTest();
  }

  void startTest() {
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        _timer?.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(correctAnswers: correctAnswers),
          ),
        );
      }
    });
  }

  void generateQuestion() {
    setState(() {
      questionIndex++;
      Random random = Random();
      int calculatedResult = 0;
      questionWidgets.clear();

      for (int i = 0; i < 5; i++) {
        int num = random.nextInt(18) - 9;
        calculatedResult += num;
        questionWidgets.add(Text(
          '$num',
        ));
      }
      result = calculatedResult.toString();
      enteredAnswer = "";
    });
  }

  void checkAnswer() {
    if (enteredAnswer == result) {
      correctAnswers++;
    }
    generateQuestion();
  }

  String getTimeString() {
    int minutes = timeRemaining ~/ 60;
    int seconds = timeRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final isRotate =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("UC Math"),
        ),
        body: Padding(
          padding: EdgeInsets.all(screenSize * .04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.timer, size: screenSize * .05),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: timeRemaining / 600,
                      backgroundColor: Colors.grey[300],
                      color: timeRemaining <= 50 ? Colors.red : Colors.green,
                    ),
                  ),
                  Text(
                    getTimeString(),
                    style: TextStyle(fontSize: screenSize * .05),
                  ),
                ],
              ),
              Expanded(
                child: LayoutGrid(
                  columnSizes: isRotate ? [auto, auto] : [auto],
                  rowSizes: isRotate ? [auto] : [auto, auto],
                  rowGap: 10,
                  columnGap: 20,
                  children: _buildTestUI(screenSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTestUI(double screenSize) {
    return [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightGreenAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.lightGreenAccent, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize * .02),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: questionWidgets,
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize * .02),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        enteredAnswer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      LayoutGrid(
        columnSizes: [1.5.fr, 1.5.fr, 1.5.fr],
        rowSizes: const [auto, auto, auto, auto],
        rowGap: 4,
        columnGap: 4,
        children: [
          ...List.generate(9, (index) {
            return _buildNumberButton(index + 1, screenSize - 100);
          }),
          const SizedBox(),
          _buildNumberButton(0, screenSize - 100),
          _buildConfirmButton(screenSize - 100),
        ],
      ),
    ];
  }

  Widget _buildNumberButton(int number, double screenSize) {
    return SizedBox(
      width: screenSize * 1.09,
      height: screenSize * .18,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            enteredAnswer = number.toString();
          });
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          number.toString(),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(double screenSize) {
    return SizedBox(
      width: screenSize * 1.09,
      height: screenSize * .18,
      child: ElevatedButton(
        onPressed: checkAnswer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(Icons.check, size: screenSize * .08, color: Colors.white),
      ),
    );
  }
}
