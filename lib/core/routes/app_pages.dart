import 'package:get/get.dart';

import 'package:todoapp/core/routes/app_routes.dart';
import 'package:todoapp/features/splash/presentation/pages/splash_page.dart';
import 'package:todoapp/features/todo/presentation/pages/todo_page.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage(name: Routes.splash, page: () => SplashPage()),
    GetPage(name: Routes.todo, page: () => const TodoPage()),
  ];
}


