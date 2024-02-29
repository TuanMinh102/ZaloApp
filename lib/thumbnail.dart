import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(const Thumbnail());
}

class Thumbnail extends StatefulWidget {
  const Thumbnail({super.key});

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Video Thumbnail Example'),
        ),
        body: Center(
          child: FutureBuilder<String?>(
            future: getThumbnail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Image.file(
                  File(snapshot.data!),
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String?> getThumbnail() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video:
          "https://firebasestorage.googleapis.com/v0/b/zalo-fb371.appspot.com/o/1709191519668.mp4?alt=media&token=b2a38678-0ec0-4f26-89f7-aba04dfe3b16",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      quality: 75,
    );

    return fileName;
  }
}
