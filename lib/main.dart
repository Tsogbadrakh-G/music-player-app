import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:somni_app/model/model.dart';
import 'package:somni_app/views/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'package:hive/hive.dart';

late Box<Audio> cachedUrlsBox;
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

  runApp(const ProviderScope(child: MyApp()));
}
