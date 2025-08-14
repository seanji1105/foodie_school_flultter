import 'package:flutter/material.dart';
import 'widgets/custom_header.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie School',
      home: Scaffold(
        appBar: const CustomHeader(),
        body: Center(
          child: Text("Foodie School"),
        ),
      ),
    );
  }
}
