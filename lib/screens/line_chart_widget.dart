import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {

  final List<Color> gradientColors = [
    const Color(0xff23bee6),
    const Color(0xff02d39a),
  ];

  late final List<FlSpot> spots;
  LineChartWidget({required this.spots});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LineChart(
        LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            titlesData: LineTitles.getTitleData(),
            gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
                },
                drawVerticalLine: true),
            borderData: FlBorderData(
                show: true, border: Border.all(color: const Color(0xff37434d))),
            lineBarsData: [
              LineChartBarData(
                  isCurved: true,
                  barWidth: 5,
                  colors: gradientColors,
                  // dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                      show: true,
                      colors: gradientColors
                          .map((color) => color.withOpacity(0.3))
                          .toList()),
                  spots: [
                    FlSpot(0, 3),
                    FlSpot(2.6, 2),
                    FlSpot(4.9, 5),
                    FlSpot(6.8, 2.5),
                    FlSpot(8, 4),
                    FlSpot(9.5, 3),
                    FlSpot(11, 4),
                  ])
            ]),
      ),
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
          showTitles: true,
          margin: 10,
          reservedSize: 22, //bottom space
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 15),
          getTitles: (value) {


            return '';
          }),
    leftTitles: SideTitles(
        showTitles: true,
        reservedSize: 28, //b
        margin: 20,// bottom space
        getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      getTitles: (value) {
        switch(value.toInt()) {
          case 1 : return '10k';
          case 3 : return '30k';
          case 5 : return '50k';
        }
        return '';
      }
    )
  );
}
