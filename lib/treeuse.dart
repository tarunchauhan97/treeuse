library treeuse;

import 'package:flutter/material.dart';

class TreeuseResponsive extends StatelessWidget {
  final Widget child;
  final bool manageOrientation;

  const TreeuseResponsive({
    super.key,
    required this.child,
    this.manageOrientation = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Initialize the static variables based on device width and orientation
        TreeuseRespHelper.init(
          constraints.maxWidth,
          MediaQuery.of(context).orientation,
        );

        if (manageOrientation) {
          return _OrientationManager(child: child);
        }

        return child;
      },
    );
  }
}

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

class _OrientationManager extends StatelessWidget {
  final Widget child;

  const _OrientationManager({required this.child});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        TreeuseRespHelper.isTPortrait = orientation == Orientation.portrait;
        TreeuseRespHelper.isTLandscape = orientation == Orientation.landscape;
        return child;
      },
    );
  }
}
