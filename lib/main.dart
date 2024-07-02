import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:somni_app/model/model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:somni_app/views/splash_screen.dart';
import 'utils/firebase_options.dart';
import 'package:hive/hive.dart';

late Box<Audio> cachedUrlsBox;
late Box<String> wordsOfMusicsBox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(AudioAdapter());

  cachedUrlsBox = await Hive.openBox('cachedPaths');
  wordsOfMusicsBox = await Hive.openBox('musicWords');

  runApp(const ProviderScope(child: SplashScreen()));
}
