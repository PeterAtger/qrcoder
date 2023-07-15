class Person {
  final String name;
  final String group;
  int points;

  Person({
    required this.name,
    required this.group,
    this.points = 0,
  });

  get(fieldName) {
    switch (fieldName) {
      case 'name':
        return name;
      case 'group':
        return group;
      case 'points':
        return points;
      default:
        return points;
    }
  }
}
