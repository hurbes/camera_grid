import 'package:camera_grid/camera_grid.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

import 'widgets/camera_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Camera Grid Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: CameraWrapper(
        child: CameraAwesomeBuilder.custom(
          saveConfig: SaveConfig.photo(),
          builder: (state, preview) => state.when(
            onPreparingCamera: (preparingCameraState) => Container(
              color: Colors.black,
            ),
            onPreviewMode: (previewCameraState) {
              return previewCameraState.focus();
            },
            onPhotoMode: (photoCompleteState) {
              return const CameraGrid(child: SizedBox());
            },
          ),
        ),
      ),
    );
  }
}
