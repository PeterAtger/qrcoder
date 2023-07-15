class Group {
  final String group;
  int points;

  Group({
    required this.group,
    this.points = 0,
  });

  get(fieldName) {
    switch (fieldName) {
      case 'group':
        return group;
      case 'points':
        return points;
      default:
        return points;
    }
  }
}
