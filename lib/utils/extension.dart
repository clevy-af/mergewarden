import 'package:flutter/material.dart';

extension ContExt on BuildContext{
  bool get isDesktop=>MediaQuery.of(this).size.width>700;

}