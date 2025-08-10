/*
 "_id": "688fd398b4f34e7d4b426d48",
  "title": "dsadasd",
  "description": "sadasdas",
  "status": "New",
  "email": "tanvir.animation@gmail.com",
  "createdDate": "2025-07-16T06:07:55.798Z"
*/

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> jsonTask) {
    return TaskModel(
      id: jsonTask['_id']!,
      title: jsonTask['title']!,
      description: jsonTask['description']!,
      status: jsonTask['status']!,
      createdDate: jsonTask['createdDate']!,
    );
  }

  Map<String, String> toJson() {
    return {
      'title': title,
      'description': description,
      'createdDate': createdDate,
    };
  }
}
