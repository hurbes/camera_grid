# Changelog

## [0.0.6]

- Grid can be used as both wrapper and overlay without affecting touch functionality.

## [0.0.5]

- Fixed critical bug: Grid no longer absorbs touch events, allowing interaction with underlying camera preview.
- Enhanced flexibility: Grid can be used as both wrapper and overlay without affecting touch functionality.

## [0.0.4] 

## Changed
 - Updated Example project

## [0.0.3] 

## Changed
 - Updated Readme and example project

## [0.0.2] 

### Changed
- Refactored `CameraGrid` to use a separate `_ActiveGyroCameraGrid` widget, improving performance when grid is disabled and simplifying the toggle mechanism.
- Updated to use Dart 3's switch expression for clearer, more maintainable code.

### Fixed
- Eliminated unnecessary resource initialization when grid is disabled.

## [0.0.1] 

🎉 Initial release of Gyro Camera Grid! 🎉

### 🚀 Features

- Introduced the `CameraGrid` widget
  - Responsive grid overlay that follows device orientation
  - Smooth transitions between portrait and landscape modes
  - Customizable grid color, accent color, and line width
  - Snapping behavior with adjustable threshold

### 🧰 Core Components

- `CameraGrid`: Main widget for wrapping camera previews
- `CameraGridPainter`: Custom painter for rendering the grid and alignment box
- `GyroMath`: Utility class for handling orientation calculations

### 🎨 Customization Options

- Grid color
- Accent color (for snapped alignment box)
- Grid line width
- Moving border radius
- Morph animation duration and curve
- Snap threshold
