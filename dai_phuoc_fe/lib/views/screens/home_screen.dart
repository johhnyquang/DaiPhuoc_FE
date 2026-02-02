import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đại Phước Clinic',
      home: Scaffold(
        appBar: AppBar(title: const Text('Đại Phước Clinic')),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}