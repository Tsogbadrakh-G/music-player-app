
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:somni_app/MyApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:hive/hive.dart';
final AudioPlayer audioPlayer = AudioPlayer();
late Box cachedUrlsBox;
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
final appDocumentDirectory = await getApplicationDocumentsDirectory();

 Hive.init(appDocumentDirectory.path);

  cachedUrlsBox =await Hive.openBox('cachedPaths');
  
  runApp(  const ProviderScope(child: MyApp()));


}



// initSongs() async {
//   await audioPlayer.setAudioSource(ConcatenatingAudioSource(
//       children: [AudioSource.asset('assets/sample.mp3')]));
// }

// initFiles() async {
//   List<String> files = [];
//   String manifestContent = await rootBundle.loadString('AssetManifest.json');

//   final Map<String, dynamic> manifestMap = json.decode(manifestContent);
//   // >> To get paths you need these 2 lines

//   final filePaths = manifestMap.keys
//       .where((String key) => key.contains('assets/'))
//       .where((String key) => key.contains('.mp3'))
//       .toList();
//   files = filePaths;
//   log('files: $files');
//   return files;
// }