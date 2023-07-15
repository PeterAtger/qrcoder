import 'package:flutter/material.dart';
import 'package:qrcoder/Models/group.dart';

class GroupDataTable extends StatefulWidget {
  final List<Group> data;
  const GroupDataTable({super.key, this.data = const []});

  @override
  State<GroupDataTable> createState() => _GroupDataTableState();
}

class _GroupDataTableState extends State<GroupDataTable> {
  int _currentSortColumn = 1;
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    List<Group> qrData = widget.data;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _currentSortColumn,
          sortAscending: _isAscending,
          columns: [
            DataColumn(
                label: const Text('الفصل'),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      // sort the product list in Ascending, order by Price
                      qrData.sort((qrA, qrB) => qrB.group.compareTo(qrA.group));
                    } else {
                      _isAscending = true;
                      // sort the product list in Descending, order by Price
                      qrData.sort((qrA, qrB) => qrA.group.compareTo(qrB.group));
                    }
                  });
                }),
            DataColumn(
                label: const Text('النقط'), // Sorting function
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      // sort the product list in Ascending, order by Price
                      qrData
                          .sort((qrA, qrB) => qrB.points.compareTo(qrA.points));
                    } else {
                      _isAscending = true;
                      // sort the product list in Descending, order by Price
                      qrData
                          .sort((qrA, qrB) => qrA.points.compareTo(qrB.points));
                    }
                  });
                }),
          ],
          rows: qrData
              .map((entry) => DataRow(
                    cells: [
                      DataCell(Text(entry.group)),
                      DataCell(Text(entry.points.toString())),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
