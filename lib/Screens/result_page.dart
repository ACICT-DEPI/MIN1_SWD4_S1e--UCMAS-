import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int correctCount;
  final List wrongAnswers;
  final List correctAnswers;
  final List<List<int>> wrongAnswersQuestion;
  final Color resultColor;

  const ResultPage({
    Key? key,
    required this.correctCount,
    required this.wrongAnswers,
    required this.correctAnswers,
    required this.wrongAnswersQuestion,
    required this.resultColor,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int _currentIndex = 0;

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < widget.wrongAnswersQuestion.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  double get accuracy {
    int totalQuestions = widget.correctCount + widget.wrongAnswers.length;
    return totalQuestions > 0 ? (widget.correctCount / totalQuestions) * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {


    return Directionality(
        textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نتيجه الاختار'),
          backgroundColor: widget.resultColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Chart Section
                  const Text(
                    'تقيم الاداء',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildCard('الإجابات الصحيحة', '${widget.correctCount}', Colors.green),
                      _buildCard('الإجابات الخاطئة', '${widget.wrongAnswers.length}', Colors.red),
                    ],
                  ),
                  Row(
                    children: [
                      _buildCard('الدقة', '${accuracy.toStringAsFixed(1)}%', Colors.blueAccent),
                      _buildCard('السرعه', '${widget.correctCount/8.0}', Colors.yellowAccent),
                    ],
                  ),
                  const SizedBox(height: 30),


                   Text(
                     widget.wrongAnswers.isNotEmpty ?
                     'الاجابات الخاطئة':
                     'لا يوجد اجابات خاطئة!',
                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(height: 20),
                   if(widget.wrongAnswers.isNotEmpty)...[
                   Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       border: Border.all(color: widget.resultColor, width: 2),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: widget.wrongAnswersQuestion[_currentIndex].map((num) {
                         return Padding(
                           padding: const EdgeInsets.symmetric(vertical: 8.0),
                           child: Text(
                             num.toString(),
                             style: const TextStyle(
                                 fontWeight: FontWeight.bold),
                           ),
                         );
                       }).toList(),
                     ),
                   ),
                     const SizedBox(height: 10),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             color: Colors.lightGreen,
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: Center(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 widget.correctAnswers[_currentIndex],
                                 style: const TextStyle(
                                     fontWeight: FontWeight.bold),
                               ),
                             ),
                           ),
                         ),
                     const SizedBox(width: 10),
                     Container(
                       decoration: BoxDecoration(
                         color: Colors.red,
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: Center(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                             widget.wrongAnswers[_currentIndex],
                             style: const TextStyle(
                                 fontWeight: FontWeight.bold),
                           ),
                         ),
                       ),
                     )],
                     ),
                   const SizedBox(height: 10),

                   // Navigation Buttons for wrong answers
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       // Next Arrow Button
                       IconButton(
                         onPressed: _nextQuestion,
                         icon: const Icon(
                           Icons.arrow_back, // Right arrow icon for "Next"
                           size: 30,
                         ),
                         color: Colors.blueAccent,
                       ),
                       Text("${widget.wrongAnswers.length} /${_currentIndex+1}",style: TextStyle(color: Colors.grey)),
                       // Previous Arrow Button
                       IconButton(
                         onPressed: _previousQuestion,
                         icon: const Icon(
                           Icons.arrow_forward, // Left arrow icon for "Previous"
                           size: 30,
                         ),
                         color: Colors.blueAccent,
                       ),

                     ],
                   )]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Function to create a single card
  Widget _buildCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
