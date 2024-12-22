import 'package:flutter/material.dart';

import 'flip_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Drawer',
      home: FlipDrawer(
        child: Container(color: Colors.indigo),
      ),
    );
  }
}
