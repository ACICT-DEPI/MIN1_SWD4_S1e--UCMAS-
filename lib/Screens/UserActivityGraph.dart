import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserActivityGraph extends StatelessWidget {
  final List<FlSpot> correctAnswersData;
  final List<FlSpot> wrongAnswersData;

  // Constructor to receive data
  UserActivityGraph({
    Key? key,
    required this.correctAnswersData,
    required this.wrongAnswersData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatXAxis(value), // Format X-axis titles
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 10, // Adjust maxY based on expected activity level
          lineBarsData: [
            LineChartBarData(
              spots: correctAnswersData, // Use passed data for correct answers
              isCurved: true,
              color: Colors.green, // Line color for correct answers
              dotData: FlDotData(show: true), // Show dots on points
              belowBarData: BarAreaData(show: false), // Show area below the line
            ),
            LineChartBarData(
              spots: wrongAnswersData, // Use passed data for wrong answers
              isCurved: true,
              color:Colors.red, // Line color for wrong answers
              dotData: FlDotData(show: true), // Show dots on points
              belowBarData: BarAreaData(show: false), // Show area below the line
            ),
          ],
        ),
      ),
    );
  }

  // Method to format the X-axis labels
  String _formatXAxis(double value) {
    switch (value.toInt()) {
      case 0:
        return 'Test 1';
      case 1:
        return 'Test 2';
      case 2:
        return 'Test 3';
      case 3:
        return 'Test 4';
      case 4:
        return 'Test 5';
      case 5:
        return 'Test 6';
      case 6:
        return 'Test 7';
      default:
        return '';
    }
  }
}
