
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/model/controller.dart/network_controller.dart';
import 'package:somni_app/shimmer.dart';


AudioPlayer audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');


class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override

  _MyApp createState() => _MyApp();
}
class _MyApp extends ConsumerState<MyApp> {


 @override
 initState(){
   ref.read(networkProvider.notifier).initConnectivity();

   super.initState();
 }
 

  @override
  Widget build(BuildContext context) {
  final controller=ref.read(networkProvider.notifier);

  final controllerState=  ref.watch(networkProvider);
     
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text("Sangeet"),
          leading: const Icon(Icons.music_note),
        ),
        body: SizedBox.expand(
          child: controllerState.isLoading?
          const LimeShimmer(width: 40, height: 20)
          :
          
          ListView.builder(
            itemCount: controller.cachedFiles.length,
            itemBuilder: (context,index){
            return 

            Card(
              shadowColor: Colors.lightBlue,
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.album),
                title: const Text("Music of the Era"),
                subtitle: const Text("#1"),
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => audioPlayer.stop(),
                ),
                onTap: () { 
                  // log('1');
                  // log('cachedFiles path: ${ controller.cachedFiles[index].path}');
                 audioPlayer.play(DeviceFileSource(controller.cachedFiles[index].path));
                 //log('2');
                  
                  }
              ),
            );
          })
         
       
   
      
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlueAccent,
          child: Container(
            height: 50,
          ),
        ),


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
