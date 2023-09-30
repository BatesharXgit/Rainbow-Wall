import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Center(
        child: Container(
          height: 200,
          width: 200,
          color: Theme.of(context).colorScheme.background,
          child: Image.asset('lib/images/luca.png'),
        ),
      )),
    );
  }
}
