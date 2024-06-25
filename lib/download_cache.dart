import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

enum DownloadFileType { video, image, audio, file }

class DownloadService {
  // Tataj awch bui failuudiin progress link iig hadgalah
  static final RxMap<String, List<int>> _downloadProgresses = RxMap({});

  static Map<DownloadFileType, String> folders = {
    DownloadFileType.video: 'videos',
    DownloadFileType.image: 'images',
    DownloadFileType.audio: 'audios',
    DownloadFileType.file: 'files',
  };

  static Future<String?> downloadCache({
    required String url,
    required String fileName,
    Function(int, int)? onProgress,
    DownloadFileType? type = DownloadFileType.image,
  }) async {
    String? cachePath;
    try {
      final dirTemp = await getTemporaryDirectory();
      cachePath = ('${dirTemp.path}/${folders[type]}/$fileName').replaceAll(' ', '_');

      if (!(await File(cachePath).exists()) && !_downloadProgresses.containsKey(url)) {
        await Dio().download(
          url,
          cachePath,
          onReceiveProgress: (count, total) {
            _downloadProgresses[url] = [count, total];
            if (onProgress != null) {
              onProgress(count, total);
            }

            if (count == total) {
              _downloadProgresses.remove(url);
            }

            return;
          },
        );
      } else if (_downloadProgresses.containsKey(url) && onProgress != null) {
        await _downloadComplete(downloadProgressStream: _downloadProgresses.stream, url: url, onProgress: onProgress);
      }

      return cachePath;
    } catch (e) {
      _downloadProgresses.remove(url);
      if (cachePath != null) {
        await File(cachePath).delete();
      }

      return null;
    }
  }

  static Future<bool> saveToPhone({required String path, required String fileName}) async {
    try {
      await ImageGallerySaver.saveFile(path, name: fileName);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _downloadComplete({
    required Stream<Map<String, List<int>>> downloadProgressStream,
    required Function(int, int) onProgress,
    required String url,
  }) async {
    await for (var value in downloadProgressStream) {
      onProgress.call(value[url]!.first, value[url]!.last);
      if (value[url]!.first == value[url]?.last) {
        return;
      }
    }
  }
}
