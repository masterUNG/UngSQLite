import 'package:flutter/material.dart';
import 'package:ungsqlite/models/todo_model.dart';
import 'package:ungsqlite/utility/sqlite_helper.dart';

class LearnSqlite extends StatefulWidget {
  @override
  _LearnSqliteState createState() => _LearnSqliteState();
}

class _LearnSqliteState extends State<LearnSqlite> {
  // Field
  String todo;
  List<TodoModel> todoModels = List();

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
            TodoModel model = TodoModel( null,todo);
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
        trailing: deleteButton(index),
      );

  IconButton deleteButton(int index) {
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          print('You Click index = $index, id ===>>> ${todoModels[index].id.toString()}');
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
