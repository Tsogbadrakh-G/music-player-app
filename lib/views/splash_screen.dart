import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:somni_app/controller/network_controller.dart';
import 'package:somni_app/views/my_app.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.read(networkProvider.notifier).initConnectivity();
    //callDelay(context);
    return GetMaterialApp(
      home: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(
          child: MyApp()
        ),
      ),
    );
  }

  Future callDelay(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    Get.to(const MyApp());
  }
}
