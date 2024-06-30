// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:somni_app/controller/network_controller.dart';
import 'package:somni_app/controller/player_controller.dart';
import 'package:somni_app/views/search_screen.dart';
import 'package:somni_app/views/shimmer.dart';
import 'package:somni_app/views/song_list_item.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> {
  @override
  initState() {
    ref.read(networkProvider.notifier).initConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(playerProvider);

    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 95, 95, 96),
          title: const Text(
            "Тэнгэрийн уудам тал",
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(Icons.music_note),
          actions: [
            IconButton(
              onPressed: () => Get.to(
                () => const SearchScreen(),
                duration: const Duration(milliseconds: 700),
                transition: Transition.rightToLeft,
              ),
              icon: const Icon(
                Icons.search_rounded,
              ),
            ),
          ],
        ),
        body: SizedBox.expand(
            child: controllerState.cachedAudios.isEmpty
                ? const LimeShimmer(width: 40, height: 20)
                : ListView.builder(
                    itemCount: controllerState.cachedAudios.length,
                    itemBuilder: (context, index) {
                      return Card(
                          shadowColor: Colors.lightBlue,
                          elevation: 3,
                          child: SongListItem(
                            index: index,
                          ));
                    })),
        // bottomNavigationBar: BottomAppBar(
        //   color: const Color.fromARGB(255, 95, 95, 96),
        //   child: Container(
        //     height: 50,
        //   ),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }

  @override
  void dispose() {
    ref.read(networkProvider);
    // _connectivitySubscription.cancel();
    super.dispose();
  }
}
