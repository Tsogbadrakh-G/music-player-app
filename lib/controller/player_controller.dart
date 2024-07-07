// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final playerProvider =
    StateNotifierProvider<PlayerProvider, PlayerModel>((ref) {
  return PlayerProvider();
});

class PlayerModel {
  final bool rebuild;
  final bool isPlaying;

  final List<String> words;
  final int selectedIndex;
  final bool handleSeek;
  PlayerModel(this.rebuild, this.isPlaying,  this.words,
      this.selectedIndex, this.handleSeek);

  PlayerModel copyWith(
      {final rebuild,
      final isPlaying,
     
      final words,
      final selectedIndex,
      final handleSeek,
      }) {
    return PlayerModel(
      rebuild ?? this.rebuild,
      isPlaying ?? this.isPlaying,
      
      words ?? this.words,
      selectedIndex ?? this.selectedIndex,
      handleSeek ?? this.handleSeek
    );
  }
}
 AudioPlayer player = AudioPlayer();
class PlayerProvider extends StateNotifier<PlayerModel> {
 
  PlayerProvider() : super(PlayerModel(false, false, [], 0,false));

  void rebuild() {
    state = state.copyWith(rebuild: !state.rebuild);
  }

  void handlSelectedIndex(int val) {
    state = state.copyWith(selectedIndex: val);
    //selectedIndex = val;
  }

  void setWords(List<String> words) {
    state = state.copyWith(words: words);
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

  void setPlayerState(bool playerState) {
    state = state.copyWith(isPlaying: playerState);
  }

  Future<void> handleSeek(double val) async {
     print('seek first');
    await player.seek(Duration(seconds: val.toInt()));
    print('seek after');
    state=state.copyWith(rebuild: !state.handleSeek);
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
