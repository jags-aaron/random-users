import 'package:flutter/material.dart';

import 'home_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.model,
  });

  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(model.title),
      ),
    );
  }
}
