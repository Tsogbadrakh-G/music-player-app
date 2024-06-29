import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/controller/download_cache.dart';
import 'package:somni_app/controller/player_controller.dart';
import 'package:somni_app/main.dart';
import 'package:somni_app/model/model.dart';

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

  // final _playerProvider = Provider((ref) {
  //   // Use ref.read to get the current value of counterProvider
  //   final playerProvider1 = ref.read(playerProvider.notifier);
  //   return playerProvider1;
  // });

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
    log('Connectivity changed: ${result}');
    if (result[0] == ConnectivityResult.none) {
      log('1');
      if (!isLocalCalled) getLocalCache();
    } else {
      log('2');
      if (!isInternetCalled) getFirebaseStorage();
      isLocalCalled = false;
    }
  }

  getLocalCache() async {
    isLocalCalled = true;

    log('getLocalCache is called');

    List<Audio> cachedAudios = cachedUrlsBox.values.toList();
    ref.read(playerProvider.notifier).setSource(cachedAudios);
    log('local paths len: ${cachedAudios.length}');

    log('local paths len: ${cachedAudios.length}');
  }

  getFirebaseStorage() async {
    isInternetCalled = true;
    log('getFirebaseStorage is called');

    cachedUrlsBox.clear();
    final storageRef = FirebaseStorage.instance.ref('audios/');
    final list = await storageRef.list();
    List<Audio> cachedAudios = [];
    log('list: ${list.items.length}');

    int index = 0;
    for (var item in list.items) {
      String fileName = item.fullPath.split('/')[1];
      final url = await item.getDownloadURL();
      final path =
          await DownloadService.downloadCache(url: url, fileName: fileName);

      cachedAudios.add(Audio(id: index, name: fileName, path: path ?? ''));
      cachedUrlsBox.put(index, cachedAudios.last);

      index++;
    }
    log('cached files: ${cachedAudios}');
    log('local box val: ${cachedUrlsBox.values}');

    ref.read(playerProvider.notifier).setSource(cachedAudios);
  }

//  void setSources
}
