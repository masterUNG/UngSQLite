import 'package:flutter/material.dart';
import 'package:ungsqlite/models/todo_model.dart';
import 'package:ungsqlite/utility/sqlite_helper.dart';

class LearnSqlite extends StatefulWidget {
  @override
  _LearnSqliteState createState() => _LearnSqliteState();
}

class _LearnSqliteState extends State<LearnSqlite> {
  // Field
  String todo, todoNew;
  List<TodoModel> todoModels = List();
  TextEditingController textController = TextEditingController();
  TextEditingController editController = TextEditingController();

  // Method

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<void> readSQLite() async {
    try {
      List<TodoModel> list = await SQLiteHelper().readAllData();
      print('list.leang ===>>> ${list.length}');
      if (list.length != 0) {
        setState(() {
          todoModels = list;
        });
      }
    } catch (e) {
      print('e==>> ${e.toString()}');
    }
  }

  Widget showIcon() {
    return Icon(
      Icons.search,
      size: 36.0,
      color: Colors.deepOrangeAccent,
    );
  }

  Widget showAddToDo() {
    return Row(
      children: <Widget>[
        showIcon(),
        showTextField(),
        showButton(),
      ],
    );
  }

  RaisedButton showButton() => RaisedButton(
        onPressed: () {
          if (todo == null || todo.isEmpty) {
            print('Have Space');
          } else {
            TodoModel model = TodoModel(null, todo);
            textController.clear();
            todo = null;
            setState(() {
              SQLiteHelper().insertValueToSQLite(model);
              readSQLite();
            });
          }
        },
        child: Text('Add'),
      );

  Widget showTextField() => Expanded(
        child: Container(
          // width: 100.0,
          child: TextField(
            controller: textController,
            onChanged: (String string) {
              todo = string.trim();
            },
          ),
        ),
      );

  Widget showNoData() => Container(
        margin: EdgeInsets.only(top: 100.0),
        child: Text('No ToDo'),
      );

  Widget showListToDo() {
    return todoModels.length == 0
        ? showNoData()
        : Expanded(
            child: ListView.builder(
              itemCount: todoModels.length,
              itemBuilder: (BuildContext context, int index) {
                return showContent(index);
              },
            ),
          );
  }

  Widget showContent(int index) => ListTile(
        title: Text('${todoModels[index].id}  ${todoModels[index].todo}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            editButton(index),
            deleteButton(index),
          ],
        ),
      );

  IconButton editButton(int index) => IconButton(
      icon: Icon(
        Icons.build,
        color: Colors.green,
      ),
      onPressed: () {
        editController.text = todoModels[index].todo;
        editDialog(index);
      });

  Future<void> editDialog(int index) async {
    showDialog(
      context: context,
      builder: (value) => AlertDialog(
        title: Text('Edit ToDo ?'),
        content: TextField(onChanged: (value)=>todoNew = value.trim(),
          controller: editController,
        ),
        actions: <Widget>[
          FlatButton(onPressed: () {
            TodoModel model = TodoModel(todoModels[index].id, todoNew);
            SQLiteHelper().updateSQLiteWhereId(model);
            setState(() {
              readSQLite();
            });
            Navigator.of(context).pop();
          }, child: Text('Edit')),
          FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
        ],
      ),
    );
  }

  IconButton deleteButton(int index) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () {
        print(
            'You Click index = $index, id ===>>> ${todoModels[index].id.toString()}');
        SQLiteHelper().deleteSQLiteWhereId(todoModels[index].id);
        setState(() {
          readSQLite();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          showAddToDo(),
          showListToDo(),
        ],
      ),
    );
  }
}
