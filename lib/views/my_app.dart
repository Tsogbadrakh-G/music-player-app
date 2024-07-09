// ignore_for_file: library_private_types_in_public_api
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:somni_app/controller/network_controller.dart';
import 'package:somni_app/views/search_screen.dart';
import 'package:somni_app/views/shimmer.dart';
import 'package:somni_app/views/song_list_item.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final controllerState = ref.watch(networkProvider);
  log('build my app');
    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) {},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 95, 95, 96),
          title: const Text(
            "Уудам тал",
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(Icons.music_note, color: Colors.white,),
          actions: [
            IconButton(
              onPressed: () => Get.to(
                () => const SearchScreen(),
                duration: const Duration(milliseconds: 700),
                transition: Transition.rightToLeft,
              ),
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.white
              ),
            ),
          ],
        ),
        body: SizedBox.expand(
            child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              height: 300.0,
              width: 300.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/cover.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            !controllerState.isLoaded
                ? const ShimmerList()
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    itemCount: controllerState.cachedAudios.length,
                    itemBuilder: (context, index) {
                      return Card(
                          surfaceTintColor: Colors.green,
                          shadowColor: Colors.lightBlue,
                          elevation: 3,
                          child: SongListItem(
                            index: index,
                          ));
                    }),
          ],
        )),

        // debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark(),
      ),
    );
  }
}
