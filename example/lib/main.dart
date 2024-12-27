import 'package:flutter/material.dart';
import 'package:treeuse/helpers/treeuse_helper.dart';
import 'package:treeuse/widgets/treeuse_responsive.dart';

// Usage Example:
void main() {
  runApp(
    TreeuseResponsive(
      manageOrientation: true,
      child: MyTreeuseApp(),
    ),
  );
}

class MyTreeuseApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treeuse Responsive App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Treeuse Responsive Builder Example'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              if (TreeuseRespHelper.isTMobile) {
                return Text(TreeuseRespHelper.isTPortrait
                    ? 'Mobile - Portrait'
                    : 'Mobile - Landscape');
              } else if (TreeuseRespHelper.isTTablet) {
                return const Text('This is a Tablet');
              } else if (TreeuseRespHelper.isTWeb) {
                return const Text('This is a Web device');
              } else if (TreeuseRespHelper.isTDesktop) {
                return const Text('This is a Desktop device');
              } else {
                return const Text('Unknown device type');
              }
            },
          ),
        ),
      ),
    );
  }
}
