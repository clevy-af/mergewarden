import 'package:flutter/material.dart';

extension ContExt on BuildContext{
  bool get isDesktop=>MediaQuery.of(this).size.width>700;

}
extension DoubleExt on double{
  String get percent=>toString().endsWith("0")?toString():toStringAsFixed(2);
}

extension IntExt on int{
  int remainingCount([merge5=false])=>merge5?(this>0?5: 0):(this % 2 * 3);
}