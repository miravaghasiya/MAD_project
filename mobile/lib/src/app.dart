// filepath: lib/src/app.dart
import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P2P Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const ProductListScreen(),
    );
  }
}
