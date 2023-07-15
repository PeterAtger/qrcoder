import 'dart:ffi';

import 'package:path/path.dart' as pathlib;
import 'package:qrcoder/Models/group.dart';
import 'package:qrcoder/Models/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnGroup = 'group_name';
  static const columnPoints = 'points';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = pathlib.join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnGroup TEXT NOT NULL,
            $columnPoints INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<int> insertPerson(Person person) async {
    List personExists = await _db.query(table,
        where: '$columnName = ?', whereArgs: [person.name], limit: 1);

    if (personExists.isEmpty) {
      return await insert({
        columnName: person.name,
        columnGroup: person.group,
        columnPoints: 1
      });
    }

    Map<String, Object?> oldPerson = personExists[0];
    return update({
      columnId: oldPerson[columnId],
      columnPoints: int.parse(oldPerson[columnPoints].toString()) + 1
    });
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Person>> getData() async {
    List<Map<String, Object?>> results = await _db.query(table);
    List<Person> people = [];
    results.asMap().forEach((key, value) {
      people.add(Person(
          name: value[columnName].toString(),
          group: value[columnGroup].toString(),
          points: int.parse(value[columnPoints].toString())));
    });

    return people;
  }

  Future<List<Group>> getGroupData() async {
    const String totalPoints = 'total_points';

    List<Map<String, Object?>> results = await _db.query(table,
        columns: [columnGroup, 'SUM($columnPoints) as $totalPoints'],
        groupBy: columnGroup,
        orderBy: columnGroup);
    List<Group> groups = [];
    results.asMap().forEach((key, value) {
      groups.add(Group(
          group: value[columnGroup].toString(),
          points: int.parse(value[totalPoints].toString())));
    });

    return groups;
  }
}
