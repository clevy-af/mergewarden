import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'How to Use',
      preferBelow: true,
      triggerMode: TooltipTriggerMode.tap,
      child: IconButton.outlined(
        onPressed:onPressed,
        icon: Icon(Icons.question_mark_outlined,color: cCard,),
        // tooltip: 'Info',
      ),
    );
  }
}
