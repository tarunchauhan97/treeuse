// File: reusable_extensions.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension IntExtensions on int {
  /// Converts an integer to a double
  double toDouble() => this.toDouble();
}

extension DoubleExtensions on double {
  /// Converts a double to an integer
  int toInt() => this.toInt();
}

extension StringExtensions on String {
  /// Converts a string to a double. Returns `null` if the conversion fails.
  double? toDouble() => double.tryParse(this);

  /// Checks if the string is null or empty.
  bool get isNullOrEmpty => this.trim().isEmpty;
}

extension NullCheckExtension<T> on T? {
  /// Checks if the value is null
  bool get isNull => this == null;

  /// Checks if the value is not null
  bool get isNotNull => this != null;
}

extension ResponsiveExtensions on BuildContext {
  /// Checks if the device is a mobile
  bool get isMobile => MediaQuery.of(this).size.shortestSide < 600;

  /// Checks if the device is a tablet
  bool get isTablet =>
      MediaQuery.of(this).size.shortestSide >= 600 &&
          MediaQuery.of(this).size.shortestSide < 900;

  /// Checks if the device is a web platform
  bool get isWeb => kIsWeb;

  /// Checks if the device is running on desktop
  bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  /// Checks if the device is a large screen
  bool get isLargeScreen => MediaQuery.of(this).size.width > 900;
}
