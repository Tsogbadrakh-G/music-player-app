
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/download_cache.dart';
import 'package:somni_app/main.dart';


final  networkProvider = StateNotifierProvider<NetworkProvider, NetworkModel>((ref) {
  return NetworkProvider();
});

class NetworkModel {
  final bool rebuild;
   bool isLoading;
   List<ConnectivityResult> connectivityPlus;
NetworkModel(this.rebuild, this.isLoading,this.connectivityPlus);

  NetworkModel copyWith({final rebuild,final isLoading,final connectivityPlus}) {
    return NetworkModel(
      rebuild ?? this.rebuild,
      isLoading ?? this.isLoading,
     connectivityPlus ?? this.connectivityPlus
    );
  }
}

class NetworkProvider extends StateNotifier<NetworkModel> {
    NetworkProvider() : super(NetworkModel(false, true ,[ConnectivityResult.none]));

    final Connectivity connectivity = Connectivity();
    List<File> cachedFiles=[];
    Dio dio=Dio();

    late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
    bool isInternetCalled=false;
bool  isLocalCalled=false;
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
    if(result[0] == ConnectivityResult.none)
    {
      log('1');
        if(!isLocalCalled)
          getLocalCache();
    }
    else {
         log('2');
         if(!isInternetCalled)
           getFirebaseStorage();
    }
  
    state=state.copyWith(connectivityPlus: result);
      

  }

  getLocalCache() async {
    isLocalCalled=true;
    state=state.copyWith(isLoading: true);
   log('getLocalCache is called');
   
   // log('local storage file path: ${cachedUrlsBox.get('cachedFiles')}');
    cachedFiles.clear();
    /// local cached audio paths
   // List<String> paths= cachedUrlsBox.values.map((e) => e.toString()).toList();
   List<String> paths=(cachedUrlsBox.get('cachedFiles') as List).map((e) => e.toString()).toList();
    log('local paths len: ${paths.length}');
    log('paths: ${paths}');
    for(String path in paths){
           File file = File(path );
          //final bytes=  await File(path ).readAsBytes();
          cachedFiles.add(file);
    }
      log('local paths len: ${cachedFiles.length}');
     state=state.copyWith( isLoading: false);
  }

  getFirebaseStorage() async {
    isInternetCalled=true;
    log('getFirebaseStorage is called');
   state=state.copyWith(isLoading: true);
    cachedUrlsBox.clear();
    final storageRef = FirebaseStorage.instance.ref('audios/');
    final list= await  storageRef.list();
      cachedFiles.clear();
    log('cached files len: ${cachedFiles.length}');
    for( var item in list.items){

      final url= await item.getDownloadURL();
      final path=  await   DownloadService.downloadCache(url: url, fileName:  item.fullPath.split('/')[1]);
      File file = File(path ?? '');
     
      cachedFiles.add(file);
    }



 
    cachedUrlsBox.put('cachedFiles', cachedFiles.map((e) => e.path).toList());
    state=state.copyWith(isLoading: false);
     
    log('cached files: ${cachedFiles}');
    log('local box val: ${cachedUrlsBox.get('cachedFiles')}');
  } 
}
