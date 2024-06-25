import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');

bool _isPlaying = false;
var currentTime = "00:00";
var completeTime = "00:00";
var test;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text("Sangeet"),
          leading: const Icon(Icons.music_note),
        ),
        body: Column(
          children: <Widget>[
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
                onTap: () => audioPlayer.play(AssetSource('sample.mp3')),
              ),
            ),
            Card(
              shadowColor: Colors.lightBlue,
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.album),
                title: const Text("Music of the Era"),
                subtitle: const Text("#2"),
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => audioPlayer.stop(),
                ),
                onTap: () => audioPlayer.play(AssetSource('sample2.mp3')),
              ),
            ),
            Card(
              shadowColor: Colors.lightBlue,
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.album),
                title: const Text("Music From Web"),
                subtitle: const Text("Tap to Play"),
                trailing: IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => audioPlayer.stop(),
                ),
                onTap: () async {
                  await audioPlayer.play(UrlSource(
                      "https://github.com/ad-felix/flutter-dev/raw/master/Jeena%20Jeena%20(From%20%20Badlapur%20).mp3"));
                },
              ),
            ),
            Card(
              shadowColor: Colors.lightBlue,
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.album),
                title: const Text("| Local Music |"),
                subtitle: Text(
                    "- Tap to Pause/Resume - \n -- $currentTime / $completeTime --"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    audioPlayer.stop();
                    _isPlaying = false;
                  },
                ),
                onTap: () {
                  if (_isPlaying) {
                    audioPlayer.pause();
                    _isPlaying = false;
                  } else {
                    audioPlayer.resume();
                    _isPlaying = true;
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlueAccent,
          child: Container(
            height: 50,
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.audiotrack),
        //   onPressed: () async {
        //     var filePath = await FilePicker.getFilePath(context);
        //     int status = await audioPlayer.play(filePath, isLocal: true);

        //     if (status == 1) {
        //       _isPlaying = true;
        //     }
        //     audioPlayer.onAudioPositionChanged.listen((Duration duration) {
        //       currentTime = duration.toString().split('.')[0];
        //     });
        //     audioPlayer.onDurationChanged.listen((Duration duration) {
        //       completeTime = duration.toString().split('.')[0];
        //     });
        //   },
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
