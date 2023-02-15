import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/profile/avatar/my_painter.dart';

Widget showAvatar(DrawableRoot svgRoot, double size) {
  return Container(
    height: size,
    width: size,
    decoration: const BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    ),
    child: CustomPaint(
      painter: MyPainter(svgRoot, Size(size, size)),
      child: Container(),
    ),
  );
}
