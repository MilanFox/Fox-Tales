import 'package:flutter/material.dart';
import 'package:fox_tales/widgets/molecules/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'FoxTales',
        style: TextStyle(fontFamily: 'Tahu', fontSize: 40),
      )),
      drawer: const MainDrawer(),
      body: Text('Home Feed'),
    );
  }
}
