import 'package:flutter/material.dart';

class TreeuseRespHelper {
  // Static variables to hold device type states
  static bool isTMobile = false;
  static bool isTTablet = false;
  static bool isTWeb = false;
  static bool isTDesktop = false;
  static bool isTPortrait = true;
  static bool isTLandscape = false;

  // Breakpoints for responsiveness
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Initialize the device type and orientation based on width and orientation
  static void init(double width, Orientation orientation) {
    isTMobile = width < mobileBreakpoint;
    isTTablet = width >= mobileBreakpoint && width < tabletBreakpoint;
    isTWeb = width >= tabletBreakpoint && width < desktopBreakpoint;
    isTDesktop = width >= desktopBreakpoint;

    isTPortrait = orientation == Orientation.portrait;
    isTLandscape = orientation == Orientation.landscape;
  }
}
