class TaskStatusCountModel {
  final String id;
  final int sum;

  TaskStatusCountModel({required this.id, required this.sum});

  factory TaskStatusCountModel.fromJson(Map<String, dynamic> jsonTaskCount) {
    return TaskStatusCountModel(
      id: jsonTaskCount['_id'],
      sum: jsonTaskCount['sum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'sum': sum};
  }
}
