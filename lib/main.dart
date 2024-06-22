import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

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
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: ((context, index) {
                  return const ListTile(
                    title: Text('data'),
                  );
                })),
          )),
    );
  }
}
