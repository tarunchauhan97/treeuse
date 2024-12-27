import 'package:flutter/material.dart';
import 'package:treeuse/helpers/treeuse_helper.dart';

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
          return OrientationManager(child: child);
        }

        return child;
      },
    );
  }
}


class OrientationManager extends StatelessWidget {
  final Widget child;

  const OrientationManager({super.key, required this.child});

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
