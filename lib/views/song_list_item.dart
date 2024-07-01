import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:somni_app/controller/player_controller.dart';
import 'package:somni_app/views/song_play_screen.dart';
import 'package:somni_app/views/song_word_screen.dart';

class SongListItem extends ConsumerWidget {
  final int index;
  const SongListItem({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(playerProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.album),
      title: Text(playerController.model.cachedAudios[index].name),
      subtitle: const Text("#"),
      onTap: () async {
        playerController.handlSelectedIndex(index);
        await playerController.player.seek(Duration.zero, index: index);
        Get.to(const PlayeAudioScreen());
      },
      trailing: IconButton(
          onPressed: () {
            Get.to(const SongWordScreen());
          },
          icon: const Icon(
            Icons.edit_note,
            color: Colors.white,
          )),
    );
  }
}
