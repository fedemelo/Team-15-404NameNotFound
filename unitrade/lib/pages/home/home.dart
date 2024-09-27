import 'package:flutter/material.dart';
import 'package:unitrade/pages/home/nav_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
