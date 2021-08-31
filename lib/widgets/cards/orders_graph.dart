import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class OrdersGraph extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> titles;

  OrdersGraph({Key? key, required this.spots, required this.titles})
      : super(key: key);

  double getMaxYNumber() {
    double max = 0;
    spots.forEach((element) {
      if(element.y>max) {
        max = element.y;
      }
    });
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      constraints: BoxConstraints(
        maxHeight: 520
      ),
      child: LineChart(LineChartData(
          minY: 0,
          maxY: getMaxYNumber(),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                margin: 20,
                reservedSize: 30,
                getTextStyles: (value) => Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
                getTitles: (value) {
                  if (value >= titles.length) {
                    return '';
                  } else {
                    return titles[value.toInt()];
                  }

                }),
            leftTitles: SideTitles(
                showTitles: true,
                margin: 20,

                reservedSize: 30,
                getTextStyles: (value) => Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
                getTitles: (value) {
                  if (value<1000&&value % 200 == 0||value>=1000&&value%2000==0) {
                    return formatNumber(value.toInt()).toString();
                  }
                  return '';
                }),
          ),
          gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: Theme.of(context).cardColor, dashArray: [15])),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(

                shadow: Shadow(
                    color: ColorPalette.blue.withOpacity(0.2), blurRadius: 20),
                barWidth: 5,
                preventCurveOverShooting: true,
                isCurved: true,
                colors: [ColorPalette.blue],
                spots: spots)
          ])),
    );
  }
}
