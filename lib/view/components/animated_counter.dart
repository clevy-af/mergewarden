import 'dart:math' as math;
import 'package:flutter/material.dart';

class PadlockProgressCounter extends StatelessWidget {
  final int current;
  final int total;
  final TextStyle? style;

  const PadlockProgressCounter({
    super.key,
    required this.current,
    required this.total,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      // color: Color(0xFF2C3E2C),
      fontFeatures: [FontFeature.tabularFigures()], // Keeps digit widths perfectly uniform
    );

    final currentStr = current.toString();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spin each individual digit independently
        ...List.generate(currentStr.length, (index) {
          final digit = currentStr[index];

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutBack, // Gives it that mechanical click snap
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {

              // Is this the number spinning in, or the old number spinning away?
              final isNewWidget = child.key == ValueKey(digit);

              return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  // Calculate the 3D tilt angle around the X-axis
                  // 1.5708 radians = 90 degrees
                  double angle = (1 - animation.value) * (math.pi / 2);

                  if (!isNewWidget) {
                    // Old item rolls UP and BACK away from view
                    angle = -angle;
                  }

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003) // Core Perspective depth factor
                      ..rotateX(isNewWidget ? angle : -((1 - animation.value) * (math.pi / 2))),
                    alignment: Alignment.center,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
              );
            },
            child: Text(
              digit,
              key: ValueKey<String>(digit),
              style: defaultStyle,
            ),
          );
        }),

        // Static layout totals indicator
        Text(
          ' / $total',
          style: defaultStyle.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}