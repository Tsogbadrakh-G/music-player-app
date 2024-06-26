
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:somni_app/MyApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
final AudioPlayer audioPlayer = AudioPlayer();
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( MyApp());
  
  initSongs();
  //initFiles();

}

initSongs() async {
  await audioPlayer.setAudioSource(ConcatenatingAudioSource(
      children: [AudioSource.asset('assets/sample.mp3')]));
}

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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Music player'),
            leading: const Icon(Icons.back_hand),
          ),
          body: SizedBox.expand(
            child: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      await audioPlayer.play();
                    },
                    child: Text('play')),
                TextButton(
                    onPressed: () async {
                      await audioPlayer.pause();
                    },
                    child: Text('pause'))
              ],
            ),
          )),
    );
  }
}
