import 'package:flutter/material.dart';

class ResponsiveGridViewForCards extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveGridViewForCards({Key? key, required this.children})
      : super(key: key);

  List<Widget> getList(int crossAxisElement) {
    List<Widget> rows = [];

    for (int i = 0; i < children.length; i += crossAxisElement) {
      rows.add(Row(
        children: children.sublist(
            i,
            (i + crossAxisElement < children.length)
                ? i + crossAxisElement
                : children.length),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 700) {
          return Column(children: getList(1));
          // if width is less then 1300 or there were 4 children in list then 2 items should be visible in one row
        } else if (constraints.maxWidth < 1300 || children.length <= 4) {
          return Column(children: getList(2));
        } else {
          return Column(children: getList(3));
        }
      },
    );
  }
}
