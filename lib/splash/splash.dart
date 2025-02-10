import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_cont.dart';

class Splash extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    // Splash ekranında 3 saniye bekledikten sonra ana ekrana yönlendirme

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to TodoApp',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
