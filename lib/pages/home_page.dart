import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:f_202010_todo_class/model/todo.dart';

import '../model/todo.dart';

class HomePageTodo extends StatefulWidget {
  @override
  _HomePageTodoState createState() => _HomePageTodoState();
}

class _HomePageTodoState extends State<HomePageTodo> {
  List<Todo> todos = new List<Todo>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: _list(),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            _showAlert(context, todos);
          },
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }

  Widget _list() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: todos.length,
      itemBuilder: (context, posicion) {
        var element = todos[posicion];
        return _item(element, posicion);
      },
    );
  }

  Widget _item(Todo element, int posicion) {
    return new Dismissible(
      key: Key(UniqueKey().toString()),
      child: ListTile(
        title: new Text(element.title),
        subtitle: new Text(element.body),
        leading: new Icon(element.type == 'DEFAULT'
            ? Icons.check
            : element.type == 'CALL' ? Icons.call : Icons.home),
      ),
      background: Container(
        color: Colors.red,
        child: new Icon(Icons.delete),
        alignment: Alignment.centerLeft,
      ),
      onDismissed: (DismissDirection direction) {
        setState(() {
          todos.removeAt(posicion);
        });
      },
    );
  }

  void _showAlert(BuildContext context, List<Todo> data) {
    String title = '';
    String body = '';
    int completed = 0;
    String selected = 'DEFAULT';
    final titlea = TextEditingController();
    final bodya = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: new Text('new  Todo'),
              content: new StatefulBuilder(builder: (context, setState) {
                return new Container(
                  height: 200,
                  child: new Column(
                    children: <Widget>[
                      TextFormField(
                        controller: titlea,
                        decoration: InputDecoration(
                          hintText: 'Type title',
                        ),
                        onChanged: (text) {
                          setState(() {
                            title = text;
                          });
                        },
                      ),
                      TextFormField(
                        controller: bodya,
                        decoration: InputDecoration(hintText: 'Type body'),
                        onChanged: (text) {
                          setState(() {
                            body = text;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: selected,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            selected = newValue;
                          });
                        },
                        items: <String>['DEFAULT', 'CALL', 'HOME_WORK']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              }),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('Cancel')),
                new FlatButton(
                    onPressed: () {
                      if (body == '' || title == '') {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Title or Body empty'),
                          duration: Duration(seconds: 1),
                        ));
                      } else {
                        setState(() {
                          data.add(new Todo(
                              title: title,
                              body: body,
                              completed: 0,
                              type: selected));
                        });
                        titlea.clear();
                        title = '';
                        body = '';
                        bodya.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: new Text('Add')),
              ],
            ));
  }
}
