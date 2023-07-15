import 'dart:convert';

import 'package:qrcoder/Models/person.dart';

class PersonFromBar {
  String barCodeData;

  PersonFromBar({
    required this.barCodeData,
  });

  getPerson() {
    try {
      var barCodeData = jsonDecode(this.barCodeData);
      return Person(name: barCodeData['الاسم'], group: barCodeData['الفصل']);
    } catch (error) {
      return 0;
    }
  }
}
