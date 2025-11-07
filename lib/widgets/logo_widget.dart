import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double glowRadius;
  
  const LogoWidget({
    super.key,
    this.width,
    this.height,
    this.glowRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: glowRadius,
            spreadRadius: glowRadius * 0.5,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.4),
            blurRadius: glowRadius * 2,
            spreadRadius: glowRadius,
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/logo.svg',
        width: width,
        height: height,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

