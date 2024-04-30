class Todo {
  int? id;
  String name;
  String description;
  bool isCompleted;

  Todo({
    this.id,
    required this.name,
    required this.description,
    required this.isCompleted
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iscompleted': isCompleted == true ? 1 : 0
    };
  }
}
