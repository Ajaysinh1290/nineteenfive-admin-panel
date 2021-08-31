import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

class MyTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? dataRowHeight;

  MyTable(
      {Key? key, required this.columns, required this.rows, this.dataRowHeight})
      : super(key: key);

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Constants.tableBorderRadius),
          border: Border.all(color: Colors.grey[800] ?? Colors.grey, width: 1)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double minWidthForScrollbar = 1000;
          return GestureDetector(
              onHorizontalDragUpdate: (value) {
                if (constraints.maxWidth < minWidthForScrollbar &&
                    scrollController.hasClients) {
                  scrollController.jumpTo(
                      scrollController.offset - (value.primaryDelta ?? 0));
                }
              },
              child: Scrollbar(
                controller: scrollController,
                interactive: true,
                showTrackOnHover: false,
                isAlwaysShown: constraints.maxWidth < minWidthForScrollbar,
                thickness: 8,
                hoverThickness: 8,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth > minWidthForScrollbar
                        ? constraints.maxWidth
                        : minWidthForScrollbar,
                    child: DataTable(
                        showCheckboxColumn: false,
                        dataRowHeight: widget.dataRowHeight ?? 50,
                        dataTextStyle: Theme.of(context).textTheme.headline5,
                        columns: widget.columns,
                        rows: widget.rows),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
