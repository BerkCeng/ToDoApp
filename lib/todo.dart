import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todoapp/appbar.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<String> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      setState(() {
        _todos.addAll(List<String>.from(json.decode(todosString)));
      });
    }
  }

  void _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', json.encode(_todos));
  }

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(_controller.text);
        _saveTodos();
      });
      _controller.clear();
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "TodoAPP"),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(_todos[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTodo(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(37),
                      ),
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(37.0),
                                ),
                                hintText: 'ToDo',
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.shade300,
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(37.0))),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 24))),
                            onPressed: _addTodo,
                            child: Text('Görev Ekle',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
