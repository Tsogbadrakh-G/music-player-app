import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/controller/network_controller.dart';
import 'package:somni_app/controller/player_controller.dart';

class PlayeAudioScreen extends ConsumerStatefulWidget {
  const PlayeAudioScreen({Key? key}) : super(key: key);

  @override
  _PlayeAudioScreen createState() => _PlayeAudioScreen();
}

class _PlayeAudioScreen extends ConsumerState<PlayeAudioScreen> {
  StreamSubscription? _streamDuration;
  StreamSubscription? _streamPosition;
  StreamSubscription? _playerStream;
  PlayerProvider? playerController;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  @override
  void initState() {
    playerController = ref.read(playerProvider.notifier);
    super.initState();

    _streamDuration = player.durationStream.listen((p) {
      duration = p ?? Duration.zero;

      playerController?.rebuild();
      return;
    });
    _streamPosition = player.positionStream.listen((p) {
      position = p;
      if (position.inSeconds == duration.inSeconds) {
        log('kk');

        playerController?.handleIsPlaying(false);
        position = Duration.zero;
        player.pause();
        player
            .seek(position, index: playerController?.model.selectedIndex ?? 0);
        playerController?.rebuild();
      }
      playerController?.rebuild();
      return;
    });


  }

  @override
  Widget build(BuildContext context) {
    playerController = ref.read(playerProvider.notifier);
final networkState= ref.read(networkProvider);
log('song play build');
    ref.watch(playerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          playerController?.handleIsPlaying(false);
        }
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          //Get.back();
        },
        child: Scaffold(
            body: Stack(
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
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    "assets/cover.jpg",
                    width: 250.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  networkState
                          .cachedAudios[
                              playerController?.model.selectedIndex ?? 0]
                          .name
                          .split('.')[0] 
                      ,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                      Text(
                        playerController?.formatPosition(position),
                        style: const TextStyle(color: Colors.white),
                      ),
                  
                 
                      SizedBox(
                        width: 260.0,
                        child: Slider(
                          min: 0.0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: playerController?.handleSeek,
                          activeColor: Colors.white,
                        ),
                      ),
                   
                    
                      Text(
                        playerController?.formatPosition(duration),
                        style: const TextStyle(color: Colors.white),
                      ),
                   
                  ],
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.white38),
                      ),
                      width: 50.0,
                      height: 50.0,
                      child: InkWell(
                        onTap: () async {
                          if ((playerController?.model.selectedIndex ?? 0) >
                              0) {
                            position = Duration.zero;
                            // await player.pause();
                            // playerController?.setPlayerState(false);
                            await player.seek(Duration.zero,
                                index: (playerController?.model.selectedIndex ??
                                        1) -
                                    1);
                            duration = player.duration ??
                                Duration.zero;
                            playerController?.handlSelectedIndex(
                                (playerController?.model.selectedIndex ?? 1) -
                                    1);
                            // await player.play();
                            // playerController?.setPlayerState(true);
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.fast_rewind_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Consumer(builder: (a, ref, b) {
                      final playerState = ref.watch(playerProvider);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          color: Colors.black87,
                          border: Border.all(
                              color: const Color.fromARGB(255, 108, 106, 107)),
                        ),
                        width: 60.0,
                        height: 60.0,
                        child: InkWell(
                          onTap: playerController?.handlePlayingPause,
                          child: Center(
                            child: Icon(
                              playerState.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.white38),
                      ),
                      width: 50.0,
                      height: 50.0,
                      child: InkWell(
                        onTap: () async {
                          if ((playerController?.model.selectedIndex ?? 0) + 1 <
                              (networkState.cachedAudios )
                                  .length) {
                            position = Duration.zero;
                            // await player.pause();
                            // playerController?.setPlayerState(false);
                            await player.seek(Duration.zero,
                                index: (playerController?.model.selectedIndex ??
                                        0) +
                                    1);
                            duration = player.duration ??
                                Duration.zero;
                            playerController?.handlSelectedIndex(
                                (playerController?.model.selectedIndex ?? 0) +
                                    1);
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.fast_forward_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        )),
      ),
    );
  }

  @override
  void dispose() {
    _streamDuration?.cancel();
    _streamPosition?.cancel();
    _playerStream?.cancel();
    super.dispose();
  }
}
