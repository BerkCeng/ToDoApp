import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todoapp/features/todo/controller/todo_controller.dart';
import 'package:todoapp/shared/widgets/custom_app_bar.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoController todoController = Get.put(TodoController());
  int? _editingIndex;
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'TodoAPP'),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                if (todoController.todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Henüz görev yok',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ReorderableListView.builder(
                  itemCount: todoController.todos.length,
                  onReorder: (oldIndex, newIndex) =>
                      todoController.reorderTodos(oldIndex, newIndex),
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final String task = todoController.todos[index];
                    return Card(
                      key: ValueKey('card_$index-$task'),
                      elevation: 1.5,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.blue.withAlpha(3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.shade50,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          title: _editingIndex == index
                              ? TextField(
                                  controller: _editingController,
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (value) {
                                    todoController.updateTodoAt(index, value);
                                    setState(() => _editingIndex = null);
                                  },
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                )
                              : GestureDetector(
                                  onLongPress: () {
                                    _editingController.text = task;
                                    setState(() => _editingIndex = index);
                                  },
                                  child: Text(
                                    task,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                          
                          trailing: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              if (_editingIndex == index)
                                Tooltip(
                                  message: 'Kaydet',
                                  child: IconButton(
                                    icon: const Icon(Icons.check_circle_outline),
                                    color: Colors.green.shade600,
                                    onPressed: () {
                                      todoController.updateTodoAt(index, _editingController.text);
                                      setState(() => _editingIndex = null);
                                    },
                                  ),
                                )
                              else
                                Tooltip(
                                  message: 'Düzenle',
                                  child: IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () {
                                      _editingController.text = task;
                                      setState(() => _editingIndex = index);
                                    },
                                  ),
                                ),
                              if (_editingIndex == index)
                                Tooltip(
                                  message: 'İptal',
                                  child: IconButton(
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () => setState(() => _editingIndex = null),
                                  ),
                                ),
                              Tooltip(
                                message: 'Sil',
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red.shade400,
                                  onPressed: () => todoController.deleteTodo(index),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          SafeArea(
            top: false,
            child: Container
            (
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade100,
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCompact = constraints.maxWidth < 420;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: todoController.textController,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => todoController.addTodo(),
                          decoration: InputDecoration(
                            hintText: 'Görev ekle...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            prefixIcon: null,
                            suffixIcon: IconButton(
                              tooltip: 'Gönder',
                              icon: const Icon(Icons.send),
                              onPressed: todoController.addTodo,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isCompact ? 0 : 0),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


