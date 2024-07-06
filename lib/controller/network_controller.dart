// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/controller/download_cache.dart';
import 'package:somni_app/controller/player_controller.dart';
import 'package:somni_app/main.dart';
import 'package:somni_app/model/model.dart';
import 'package:firebase_database/firebase_database.dart';

final networkProvider =
    StateNotifierProvider<NetworkProvider, List<ConnectivityResult>>((ref) {
  return NetworkProvider(ref);
});

class NetworkProvider extends StateNotifier<List<ConnectivityResult>> {
  final Ref ref;
  NetworkProvider(this.ref) : super([ConnectivityResult.none]);

  final Connectivity connectivity = Connectivity();
  Dio dio = Dio();

  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  bool isInternetCalled = false;
  bool isLocalCalled = false;

  Future<void> initConnectivity() async {
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    log('Connectivity changed: $result');
    if (result[0] == ConnectivityResult.none) {
      log('- no internet');
      if (!isLocalCalled) getLocalCache();
    } else {
      log('- with internet');
      if (!isInternetCalled) getFirebaseStorage();
      isLocalCalled = false;
    }
  }

  getLocalCache() async {
    isLocalCalled = true;

    log('getLocalCache is called');

    List<Audio> cachedAudios = cachedUrlsBox.values.toList();
    List<String> wordsOfMusics = wordsOfMusicsBox.values.toList();

    ref.read(playerProvider.notifier).setSource(cachedAudios);
    ref.read(playerProvider.notifier).setWords(wordsOfMusics);
  }

  getFirebaseStorage() async {
    isInternetCalled = true;
    log('getFirebaseStorage is called');
    final storageRef = FirebaseStorage.instance.ref('audios/');
    final list = await storageRef.list();

    if (list.items.length == cachedUrlsBox.values.length) {
      int existsLen = 0;
      for (Audio audio in cachedUrlsBox.values) {
        if ((await File(audio.path).exists())) {
          existsLen++;
        }
      }
      if (existsLen == cachedUrlsBox.values.length) {
        getLocalCache();
        return;
      }
    }

    cachedUrlsBox.clear();
    wordsOfMusicsBox.clear();
    List<Audio> cachedAudios = [];
    List<String> words = [];

    final firebaseApp = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL:
            'https://music-player-app-11a19-default-rtdb.asia-southeast1.firebasedatabase.app/');

    int index = 0;
    for (var item in list.items) {
      log('index: $index');
      String fileName = item.fullPath.split('/')[1];
      final url = await item.getDownloadURL();
      final path =
          await DownloadService.downloadCache(url: url, fileName: fileName);

      cachedAudios.add(Audio(id: index, name: fileName, path: path ?? ''));
      cachedUrlsBox.put(index, cachedAudios.last);
      DataSnapshot? snapshot;
      
        snapshot = await rtdb.ref().child('$index').get();
      

      if (snapshot.exists) {
        //  log('words: ${snapshot.value.toString()}');
        words.add(snapshot.value.toString());
      } else {
        // log('no words');
        words.add('No words');
      }
      wordsOfMusicsBox.put(1, words.last);

      index++;
    }

    ref.read(playerProvider.notifier).setWords(words);
    ref.read(playerProvider.notifier).setSource(cachedAudios);
  }
}
