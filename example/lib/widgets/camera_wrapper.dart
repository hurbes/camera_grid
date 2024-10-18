import 'package:flutter/material.dart';

class CameraWrapper extends StatelessWidget {
  const CameraWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: size.width * .90,
          height: size.height * .50,
          child: child,
        ),
      ),
    );
  }
}
