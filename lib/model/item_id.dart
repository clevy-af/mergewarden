import 'package:flutter/foundation.dart';

@immutable
class ID {
  final String value;

  const ID(this.value);

  @override
  bool operator ==(Object other) => identical(this, other) || other is ID && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}