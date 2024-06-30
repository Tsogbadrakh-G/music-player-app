// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:somni_app/model/model.dart';

final playerProvider =
    StateNotifierProvider<PlayerProvider, PlayerModel>((ref) {
  return PlayerProvider();
});

class PlayerModel {
  final bool rebuild;
  final bool isPlaying;
  final List<Audio> cachedAudios;
  final List<String> words;
  PlayerModel(this.rebuild, this.isPlaying, this.cachedAudios, this.words);

  PlayerModel copyWith(
      {final rebuild, final isPlaying, final cachedAudios, final words}) {
    return PlayerModel(rebuild ?? this.rebuild, isPlaying ?? this.isPlaying,
        cachedAudios ?? this.cachedAudios, words ?? this.words);
  }
}

class PlayerProvider extends StateNotifier<PlayerModel> {
  AudioPlayer player = AudioPlayer();
  PlayerProvider() : super(PlayerModel(false, false, [], []));
  int selectedIndex = 0;
  void rebuild() {
    state = state.copyWith(rebuild: !state.rebuild);
  }

  void handlSelectedIndex(int val) {
    selectedIndex = val;
  }

  void setWords(List<String> words) {
    state = state.copyWith(words: words);
  }

  Future<void> setSource(List<Audio> audios) async {
    state = state.copyWith(cachedAudios: audios);
    await player.setAudioSource(ConcatenatingAudioSource(
        children: audios
            .map((audio) => AudioSource.uri(Uri.parse(audio.path)))
            .toList()));
  }

  formatPosition(Duration duration) {
    int minutes = (duration.inSeconds / 60).floor();
    int seconds = (duration.inSeconds % 60).floor();

    if (minutes < 10 && seconds > 9) {
      return "0$minutes:$seconds";
    } else if (minutes > 9 && seconds < 10)
      return "$minutes:0$seconds";
    else if (minutes < 10 && seconds < 10)
      return "0$minutes:0$seconds";
    else
      return "$minutes:$seconds";
  }

  void handlePlayingPause() {
    if (player.playing) {
      player.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  Future<void> handleSeek(double val) async {
    await player.seek(Duration(seconds: val.toInt()));
  }

  void handleIsPlaying(bool val) {
    state = state.copyWith(isPlaying: false);
    if (val) {
      player.play();
    } else {
      player.stop();
    }
  }

  PlayerModel get model => state;
}
