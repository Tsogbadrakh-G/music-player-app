// ignore_for_file: file_names
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:somni_app/download_cache.dart';
import 'package:somni_app/shimmer.dart';
import 'package:path_provider/path_provider.dart';
AudioPlayer audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');



List<File> cachedFiles=[];
Dio dio=Dio();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyApp createState() => _MyApp();
}
class _MyApp extends State<MyApp> {


 bool isLoading=true;
 @override
 initState(){
  getFirebaseStorage();
  super.initState();
 }

getFirebaseStorage() async {
cachedFiles.clear();
final storageRef = FirebaseStorage.instance.ref('audios/');
final list= await  storageRef.list();
final directory = await getApplicationDocumentsDirectory();
log('directory: ${directory.path}');
 for( var item in list.items){

  final url= await item.getDownloadURL();



final     response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
 log('response: ${response.data}');
    final path=  await   DownloadService.downloadCache(url: url, fileName:  item.fullPath.split('/')[1]);
  final bytes=  await File(path ?? '').readAsBytes();
   File file = await File(path ?? '').writeAsBytes(bytes);
   cachedFiles.add(file);
 }
 isLoading=false;
 setState(() {
   
 });

log('cached files: ${cachedFiles.length}');
}
  @override
  Widget build(BuildContext context) {
     //   getFirebaseStorage();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text("Sangeet"),
          leading: const Icon(Icons.music_note),
        ),
        body: SizedBox.expand(
          child: isLoading?
          const LimeShimmer(width: 40, height: 20)
          :
          
          ListView.builder(
            itemCount: cachedFiles.length,
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
                  log('1');
                  log('cachedFiles path: ${cachedFiles[index].path}');
                 audioPlayer.play(DeviceFileSource(cachedFiles[index].path));
                 log('2');
                  
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
}
