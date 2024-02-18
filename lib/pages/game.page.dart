import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/home.page.dart';
import 'package:provider/provider.dart';

import '../bloc/app.bloc.dart';
import '../widgets/action_button.widget.dart';
import '../widgets/custom_table.widget.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppBloc bloc = Provider.of<AppBloc>(context);

    return Scaffold(
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionButton(
            destinationWidget: HomePage(),
            text: "back",
          ),
          SizedBox(height: 20)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomTable(),
          const SizedBox(height: 30),
          Text(
            "Victories: ${bloc.playerVictories}, Draws: ${bloc.draws}, Defeats: ${bloc.playerDefeats}",
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
