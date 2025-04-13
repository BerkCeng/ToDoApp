import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todoapp/appbar.dart';

class TodoController extends GetxController {
  var todos = <String>[].obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  void loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      todos.value = List<String>.from(json.decode(todosString));
    }
  }

  void saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', json.encode(todos));
  }

  void addTodo() {
    String text = textController.text;
    if (text.isNotEmpty) {
      todos.add(text);
      saveTodos();
      textController.clear();
    }
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
    saveTodos();
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoController todoController = Get.put(TodoController());

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "TodoAPP"),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => ListView.builder(
                    itemCount: todoController.todos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(todoController.todos[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => todoController.deleteTodo(index),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ),
          SizedBox(
            height: Get.height * 0.1,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
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
                              controller: todoController.textController,
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
                                  borderRadius: BorderRadius.circular(37.0),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                              ),
                            ),
                            onPressed: todoController.addTodo,
                            child: Text('Görev Ekle',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
