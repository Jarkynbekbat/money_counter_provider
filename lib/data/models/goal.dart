class Goal {
  static String table = 'goal';

  int id, sum, haveSum, needSum;
  String startDate;
  String name;

  Goal({
    this.id,
    this.sum,
    this.haveSum,
    this.needSum,
    this.startDate,
    this.name,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sum': sum,
      'haveSum': haveSum,
      'needSum': needSum,
      'startDate': startDate,
      'name': name
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      sum: map['sum'],
      haveSum: map['haveSum'],
      needSum: map['needSum'],
      startDate: map['startDate'],
      name: map['name'],
    );
  }
}
