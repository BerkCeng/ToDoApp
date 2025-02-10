import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/splash/splash.dart';

import 'todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Splash()),
        GetPage(name: '/todo', page: () => TodoScreen()),
        // Diğer sayfalarınızı buraya ekleyebilirsiniz
      ],
    );
  }
}
