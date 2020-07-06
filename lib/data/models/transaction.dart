class Transaction {
  static String table = 'transaction';

  int id;
  String date;
  String time;
  String type;
  int sum;
  int goalId;

  Transaction(
      {this.id, this.date, this.time, this.type, this.sum, this.goalId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date,
      'time': time,
      'type': type,
      'sum': sum,
      'goalId': goalId,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      type: map['type'],
      sum: map['sum'],
      goalId: map['goalId'],
    );
  }
}
