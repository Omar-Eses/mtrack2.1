class TaskModel {
  List<String>? images;
  String? taskName;
  String? taskDescription;
  String? taskStatus;
  String? startDate;
  String? finishDate;
  String? taskId;
  String? attach;
  String? owner;
  String? status;
  List? assignedTo;

  TaskModel({
    required this.taskName,
    this.taskStatus,
    this.startDate,
    this.finishDate,
    this.taskId,
    this.assignedTo,
    this.taskDescription,
    this.attach,
    this.owner,
    this.status,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    taskDescription = json['taskDescription'];
    startDate = json['startDate'];
    finishDate = json['finishDate'];
    taskDescription = json['taskDescription'];
    taskName = json["taskName"];
    assignedTo = json["assignedUsers"];
    taskStatus = json["task"];
    taskId = json["taskId"];
    attach = json["attach"];
    owner = json["owner"];
    status = json["status"];
  }
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'taskDescription': taskDescription,
      // 'membersInTeam': membersInTeam,
      'task': taskStatus,
      'startDate': startDate,
      'finishDate': finishDate,
      'assignedUsers': assignedTo,
      'taskId': taskId,
      'attach': attach,
      'owner': owner,
      'status': status,
      // 'teamCreator': teamCreator,
    };
  }
}

enum TaskStatus { completed, inProgress, notStarted }
// class TaskModel {
//   List<String>? images;
//   List<String>? attachments;
//   String? taskId;
//   String? taskName;
//   String? teamId;
//   String? taskDescription;
//   TaskStatus? taskStatus;
//   String? taskCreator;
//   Map<String, String>? assignedTo;
//   DateTime? startDate;
//   DateTime? endDate;
//   List<TaskHistoryItem>? taskHistory;

//   TaskModel({
//     this.images,
//     this.attachments,
//     this.taskId,
//     this.taskName,
//     this.teamId,
//     this.taskDescription,
//     this.taskStatus,
//     this.taskCreator,
//     this.assignedTo,
//     this.startDate,
//     this.endDate,
//    this.taskHistory,
//   });

//   TaskModel.fromJson(Map<String, dynamic> json) {
//     images = json['images'] != null ? List<String>.from(json['images']) : null;
//     attachments = json['attachments'] != null
//         ? List<String>.from(json['attachments'])
//         : null;
//     taskId = json['taskId'];
//     taskName = json['taskName'];
//     teamId = json['teamId'];
//     taskDescription = json['taskDescription'];
//     taskStatus = _parseTaskStatus(json['taskStatus']);
//     taskCreator = json['taskCreator'];
//     assignedTo = json['assignedTo'] != null
//         ? Map<String, String>.from(json['assignedTo'])
//         : null;
//     startDate =
//         json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
//     endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
//     taskHistory = _parseTaskHistory(json['taskHistory']);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'images': images,
//       'attachments': attachments,
//       'taskId': taskId,
//       'taskName': taskName,
//       'teamId': teamId,
//       'taskDescription': taskDescription,
//       'taskStatus': taskStatus?.toString().split('.').last,
//       'taskCreator': taskCreator,
//       'assignedTo': assignedTo,
//       'startDate': startDate?.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//       'taskHistory': _formatTaskHistory(),
//     };
//   }

//   TaskStatus? _parseTaskStatus(String? status) {
//     switch (status) {
//       case 'completed':
//         return TaskStatus.completed;
//       case 'inProgress':
//         return TaskStatus.inProgress;
//       case 'notStarted':
//         return TaskStatus.notStarted;
//       default:
//         return null;
//     }
//   }
//   List<Map<String, dynamic>> _formatTaskHistory() {
//     return taskHistory?.map((historyItem) => historyItem.toMap()).toList() ?? [];
//   }

//   List<TaskHistoryItem> _parseTaskHistory(List<dynamic>? taskHistoryList) {
//     return taskHistoryList
//         ?.map((historyItem) => TaskHistoryItem.fromJson(historyItem))
//         .toList() ?? [];
//   }
// }

// enum TaskStatus { completed, inProgress, notStarted }
