import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/profile/avatar/my_painter.dart';

Widget showAvatar(DrawableRoot svgRoot, bool isSmall) {
  double hieght = isSmall ? 50 : 180.0;
  double width = isSmall ? 50 : 180.0;
  return Container(
    height: hieght,
    width: width,
    decoration: const BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    ),
    child: CustomPaint(
      painter: MyPainter(svgRoot, Size(width, hieght)),
      child: Container(),
    ),
  );
}
