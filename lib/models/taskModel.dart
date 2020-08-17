class Task{
  int id;
  String name;
  bool submission = false;

  Task({this.id,this.name});

  factory Task.fromJSON(Map<String,dynamic> data){
    return Task(
      id: data['id'],
      name: data['name'],
    );
  }

  void toSubmission() => this.submission = true;
}