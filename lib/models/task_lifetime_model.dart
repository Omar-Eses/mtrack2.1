class taskLifeTimeModel {
  final String action;
  final String user;
  final DateTime date;

  taskLifeTimeModel(
      {required this.action, required this.user, required this.date});

  taskLifeTimeModel.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        user = json['user'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'user': user,
      'date': date.toIso8601String(),
    };
  }
}
