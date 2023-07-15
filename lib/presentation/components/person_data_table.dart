import 'package:flutter/material.dart';
import 'package:qrcoder/Models/person.dart';

class PersonDataTable extends StatefulWidget {
  final List<Person> data;
  const PersonDataTable({super.key, this.data = const []});

  @override
  State<PersonDataTable> createState() => _PersonDataTableState();
}

class _PersonDataTableState extends State<PersonDataTable> {
  int _currentSortColumn = -1;
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    List<Person> qrData = widget.data;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _currentSortColumn == -1 ? null : _currentSortColumn,
          sortAscending: _isAscending,
          columns: [
            DataColumn(
                label: const Text('الاسم'),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      // sort the product list in Ascending, order by Price
                      qrData.sort((qrA, qrB) => qrB.name.compareTo(qrA.name));
                    } else {
                      _isAscending = true;
                      // sort the product list in Descending, order by Price
                      qrData.sort((qrA, qrB) => qrA.name.compareTo(qrB.name));
                    }
                  });
                }),
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
                      DataCell(Text(entry.name)),
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
