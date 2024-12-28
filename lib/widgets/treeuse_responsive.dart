import 'package:flutter/material.dart';
import 'package:treeuse/helpers/treeuse_helper.dart';

class TreeuseResponsive extends StatelessWidget {
  final Widget child;
  

  const TreeuseResponsive({
    super.key,
    required this.child,
    
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
 

        return child;
      },
    );
  }
}

