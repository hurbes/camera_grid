# 📸 Gyro Camera Grid

Hey there, Flutter enthusiasts! 👋 Welcome to the Gyro Camera Grid package. This nifty little widget adds a responsive grid overlay to your camera view that reacts to your device's orientation. Pretty cool, huh? 😎

## 🎉 Features

- Responsive grid overlay that follows device orientation
- Smooth transitions between portrait and landscape modes
- Customizable grid color, accent color, and line width
- Snapping behavior with adjustable threshold

## 🚀 Getting Started

First things first, let's add this package to your project:

```yaml
dependencies:
  camera_grid: ^0.0.1
```

Don't forget to run `flutter pub get`! 🏃‍♂️💨

## 🎨 How to Use

Using the Gyro Camera Grid is as easy as pie 🥧! Just wrap your camera preview widget with `CameraGrid`, and you're good to go!

```dart
import 'package:flutter/material.dart';
import 'package:camera_grid/camera_grid.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraGrid(
        child: YourCameraPreviewWidget(),
        gridColor: Colors.white,
        accentColor: Colors.blue,
        gridLineWidth: 1.0,
        movingBorderRadius: 4.0,
      ),
    );
  }
}
```

## ⚙️ Customization

Want to make it your own? No problem! Here are the customization options:

- `gridColor`: The color of the grid lines (default: white)
- `accentColor`: The color of the alignment box when snapped (default: blue)
- `gridLineWidth`: The width of the grid lines (default: 1.0)
- `movingBorderRadius`: The border radius of the alignment box when moving (default: 4.0)
- `morphDuration`: The duration of the morphing animation (default: 150ms)
- `morphCurve`: The curve of the morphing animation (default: Curves.easeOutQuad)
- `snapThreshold`: The threshold for snapping in radians (default: 1.5 degrees)

## 🤔 Why This Package?

You might be wondering, "Is there something like this out there already?" Well, to be honest, I'm not sure! 😅 I created this package because I needed it for a project, and I thought, "Hey, maybe someone else could use this too!"

It's a simple Stack widget-based solution, nothing too fancy or groundbreaking. But sometimes, the simple things are just what we need, right? 🎯

## 🤝 Contributing

Found a bug? Have an idea for an improvement? Feel free to contribute! We're all in this together, after all. 🌟

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy coding, and may your camera grids always be perfectly aligned! 📸✨