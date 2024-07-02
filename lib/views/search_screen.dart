import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_app/controller/player_controller.dart';
import 'package:somni_app/model/model.dart';
import 'package:somni_app/views/song_list_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  // The result list to store filtered songs
  final List<Audio> _result = [];
  // Controller for the search input field
  final TextEditingController _textEditingController = TextEditingController();

  // Function to search for songs based on the input value
  void _search({required String value, required List<Audio> songs}) {
    for (var song in songs) {
      // Check if the title or artist of the song contains the search value
      bool containsTitle = song.name
          .toLowerCase()
          .replaceAll(" ", "")
          .contains(value.toLowerCase().replaceAll(" ", ""));

      // If the song matches the search criteria and is not already in the result list, add it
      if (containsTitle) {
        bool contains = _result.any((element) => element.id == song.id);
        if (!contains) {
          setState(() {
            _result.add(song);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerController = ref.read(playerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textEditingController,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
          ),
          onChanged: (value) {
            // Clear the result list and perform a new search when the input changes
            setState(() {
              _result.clear();
            });
            _search(value: value, songs: playerController.model.cachedAudios);
          },
        ),
        actions: [
          // Display a close button if the search input is not empty
          if (_textEditingController.text.trim().isNotEmpty)
            IconButton(
              onPressed: () {
                // Clear the search input and result list
                setState(() {
                  _textEditingController.clear();
                  _result.clear();
                });
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: _result.isEmpty
          ? const Center(
              child: Text("Үр дүн илэрсэнгүй!!!"),
            )
          : _buildSongList(),
    );
  }

  // Function to build the song list widget
  Widget _buildSongList() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            height: 4,
            color: Colors.white70,
          );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: _result.length,
        itemBuilder: (context, index) {
         return Card(
                          shadowColor: Colors.lightBlue,
                          elevation: 3,
                          child: SongListItem(
                            index:  _result[index].id,
                          ));
          
        });
  }
}
