import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class CardWithGraph extends StatelessWidget {
  final List<FlSpot> spots;
  final String title;
  final String subtitle;
  final double increment;

  CardWithGraph(
      {Key? key,
      required this.spots,
      required this.title,
      required this.subtitle,
      required this.increment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 300,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            border:
                Border.all(color: Colors.grey[800] ?? Colors.grey, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontFamily: GoogleFonts.openSans().fontFamily),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  increment.toString() + "%",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontFamily: GoogleFonts.openSans().fontFamily,
                      color: increment >= 0
                          ? ColorPalette.green
                          : ColorPalette.tomato),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                  ),
                  child: Icon(
                    increment >= 0
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: increment >= 0
                        ? ColorPalette.green
                        : ColorPalette.tomato,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              child: LineChart(LineChartData(
                  minY: 0,
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                        spots: spots,
                        dotData: FlDotData(show: false),
                        barWidth: 5,
                        colors: [
                          increment >= 0
                              ? ColorPalette.green
                              : ColorPalette.tomato,
                        ],
                        belowBarData: BarAreaData(show: true, colors: [
                          (increment >= 0
                                  ? ColorPalette.green
                                  : ColorPalette.tomato)
                              .withOpacity(0.1),
                        ]),
                        preventCurveOverShooting: true,
                        isCurved: true)
                  ])),
            ))
          ],
        ),
      ),
    );
  }
}
