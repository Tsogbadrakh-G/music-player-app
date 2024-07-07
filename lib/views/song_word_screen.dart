import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/controller/network_controller.dart';
import 'package:somni_app/controller/player_controller.dart';

class SongWordScreen extends ConsumerWidget {
  const SongWordScreen({Key? key}) : super(key: key);
  String formatString(String input) {
    
    // String formatted = input.replaceAllMapped(RegExp(r'[А-ЯҮ]'), (Match match) {
    //   return '\n${match.group(0)}';
    // }).trim();
    // String formatted1 =
    //     input.replaceAllMapped(RegExp(r'[\[\]]'), (Match match) {
    //   return '\n${match.group(0)}';
    // }).trim();
    String formatString= input.split(RegExp(r'\s*-\s*')).join('\n');
    
    return formatString.replaceAllMapped(RegExp(r'[\[\]]'), (Match match) {
      return '\n${match.group(0)}';
    }).trim().
    replaceAllMapped(RegExp(r'[\[\]]'), (Match match) {
      return '';
    }).trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(playerProvider.notifier);
    final networkState= ref.read(networkProvider);
    log('index: ${playerController.model.selectedIndex},each music item: ${playerController.model.words[playerController.model.selectedIndex]}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          networkState.cachedAudios[playerController.model.selectedIndex].name
              .split('.')[0],
          style: const TextStyle(fontSize: 24),
        ),
      ),
      body: SafeArea(
          child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(formatString(playerController
                .model.words[playerController.model.selectedIndex])),
          ),
        ),
      )),
    );
  }
}
