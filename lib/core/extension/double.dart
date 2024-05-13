import 'package:flutter/material.dart';

extension double_ext on double {
  SizedBox get width => SizedBox(width: this);
  SizedBox get height => SizedBox(height: this);
}
