class Todo {
  final int id;
  final int taskid;
  final String title;
  final int isdone;
  Todo({this.id, this.isdone, this.title, this.taskid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskid': taskid,
      'title': title,
      'isdone': isdone,
    };
  }
}
