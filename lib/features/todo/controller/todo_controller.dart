import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoController extends GetxController {
  final RxList<String> todos = <String>[].obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      todos.value = List<String>.from(json.decode(todosString));
    }
  }

  Future<void> saveTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', json.encode(todos));
  }

  void addTodo() {
    final String text = textController.text;
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

  void updateTodoAt(int index, String updatedText) {
    final String trimmed = updatedText.trim();
    if (trimmed.isEmpty) return;
    if (index < 0 || index >= todos.length) return;
    todos[index] = trimmed;
    saveTodos();
  }

  void reorderTodos(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    if (oldIndex < 0 || oldIndex >= todos.length) return;
    if (newIndex < 0 || newIndex > todos.length) return;
    final String moved = todos.removeAt(oldIndex);
    todos.insert(newIndex, moved);
    saveTodos();
  }
}


