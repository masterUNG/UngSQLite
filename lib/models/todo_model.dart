class TodoModel {

  // Field
  int id;
  String todo;

  // Method
  TodoModel(this.id,this.todo);

  TodoModel.fromMap(Map<String, dynamic> map){
    id = map['id'];
    todo = map['ToDo'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map();
    map['ToDo'] = todo;
    return map;
  }
  
}