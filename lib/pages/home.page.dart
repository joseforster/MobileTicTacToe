import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/game.page.dart';
import 'package:tic_tac_toe/widgets/action_button.widget.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionButton(
            destinationWidget: GamePage(),
            text: "play",
          ),
          SizedBox(height: 10),
          Text("Created by José Forster"),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: 500,
            child: RiveAnimation.asset(
              'assets/title.riv',
            ),
          ),
        ],
      ),
    );
  }
}
