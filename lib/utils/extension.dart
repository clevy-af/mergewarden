import 'package:flutter/material.dart';
import 'package:mergewarden/utils/constants.dart';

extension ContExt on BuildContext{
  bool get isDesktop{
    return screenSize.width>kDesktopBreak;
  }

  Size get screenSize=>MediaQuery.of(this).size;

}
extension DoubleExt on num{
  String get percent=>toString().endsWith("0")?toString():toStringAsFixed(2);
}

extension IntExt on int{
  int remainingCount([merge5=false])=>merge5?(this>0?5: 0):(this % 2 * 3);
}