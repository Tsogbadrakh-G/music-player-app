import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/controller/player_controller.dart';

class SongWordScreen extends ConsumerWidget {
  const SongWordScreen({Key? key}) : super(key: key);
  String formatString(String input) {
    // Add a newline character before each uppercase letter
    String formatted =
        input.replaceAllMapped(RegExp(r'([А-Я])|(Ү)'), (Match match) {
      return '\n${match.group(0)}';
    }).trim();
    // Split the text into lines
    List<String> lines = formatted.split('\n');

    // Insert a blank line after every 4 lines
    for (int i = 4; i < lines.length; i += 5) {
      lines.insert(i, '');
    }

    // Join the lines back into a single string
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(playerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Үг',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        child: Text(formatString(
            playerController.model.words[playerController.selectedIndex])),
      )),
    );
  }
}
