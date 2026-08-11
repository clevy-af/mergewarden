import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key, required this.onPressed, this.color});
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'How to Use',
      preferBelow: true,
      triggerMode: TooltipTriggerMode.tap,
      child: IconButton.outlined(
        onPressed:onPressed,
        padding: EdgeInsets.all(3),
        style: IconButton.styleFrom(side: color==null?BorderSide(color: Colors.black87):BorderSide.none),
        icon: Icon(Icons.question_mark_outlined,color:color?? cCard,),
        // tooltip: 'Info',
      ),
    );
  }
}
