import 'package:flutter/material.dart';
import '../../calculator/presentation/calc.dart';
import '../../wikipedia/presentation/wikipedia.dart';
import '../../game/presentation/game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: isKeyboardVisible ? null : const Align(
              alignment: Alignment.bottomCenter,
              child: Text('Flutter Demo'),
            ),
            toolbarHeight: isKeyboardVisible ? 0 : kToolbarHeight,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Calculator', icon: Icon(Icons.calculate)),
                Tab(text: 'Wikipedia', icon: Icon(Icons.public)),
                Tab(text: 'Game', icon: Icon(Icons.grid_on)),
              ],
            ),
        ),
        body: TabBarView(
          children: [CalculatorScreen(), WikipediaScreen(), GamePage()],
        ),
      ),
    );
  }
}