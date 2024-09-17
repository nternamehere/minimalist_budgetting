import 'package:flutter/material.dart';
import 'package:minimalist_budgetting/bar_graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class BarGraph extends StatefulWidget {
  final Map<int, double> monthlySummary;
  final int startMonth;

  const BarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = List.generate(
      12,
      (index) => IndividualBar(
          x: widget.monthlySummary.keys.elementAt(index),
          y: widget.monthlySummary.values.elementAt(index)),
    );
  }

  double get caclulateMax {
    double highestMonthlySummary =
        widget.monthlySummary.values.reduce(max) * 1.05;

    return max(highestMonthlySummary, 500);
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: BarChart(
        BarChartData(
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: caclulateMax,
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    switch (value.toInt() % 12) {
      case 0:
        text = 'J';
        break;
      case 1:
        text = 'F';
        break;
      case 2:
        text = 'M';
        break;
      case 3:
        text = 'A';
        break;
      case 4:
        text = 'M';
        break;
      case 5:
        text = 'J';
        break;
      case 6:
        text = 'J';
        break;
      case 7:
        text = 'A';
        break;
      case 8:
        text = 'S';
        break;
      case 9:
        text = 'O';
        break;
      case 10:
        text = 'N';
        break;
      case 11:
        text = 'D';
        break;
      default:
        text = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => barData.map((data) {
        return BarChartGroupData(x: data.x, barRods: [
          BarChartRodData(
              toY: data.y,
              width: 20,
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[800]),
        ]);
      }).toList();
}
