# Camera Grid Example

This example demonstrates how to use the Camera Grid package with the Flutter camera plugin.

## Getting Started

1. Ensure you have Flutter installed on your machine.
2. Clone this repository or copy the example code.
3. Run `flutter pub get` to install dependencies.
4. Connect a device or start an emulator.
5. Run `flutter run` to start the app.

## Code Example

```dart
import 'package:camera/camera.dart';
import 'package:camera_grid/camera_grid.dart';
import 'package:flutter/material.dart';

import 'widgets/camera_wrapper.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: CameraWrapper(
          child: CameraPreview(
            controller,
            child: const CameraGrid(),
          ),
        ),
      ),
    );
  }
}
```

This example initializes the camera, displays a camera preview, and overlays it with the Camera Grid.

## Dependencies

Make sure to add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^latest_version
  camera_grid: ^latest_version
```

Replace `latest_version` with the appropriate version numbers.

## Additional Notes

- The `CameraWrapper` widget is not included in this example. Ensure you have this widget implemented or replace it with appropriate camera initialization logic.
- Handle camera permissions and errors as needed for your specific use case.

For more details on customizing the Camera Grid, refer to the main package documentation.