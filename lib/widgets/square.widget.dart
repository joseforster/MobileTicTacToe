import 'package:flutter/material.dart';
import 'package:tic_tac_toe/bloc/app.bloc.dart';
import 'package:provider/provider.dart';

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.columnNumber,
    required this.rowNumber,
  });

  final int columnNumber;
  final int rowNumber;

  @override
  Widget build(BuildContext context) {
    final AppBloc bloc = Provider.of<AppBloc>(context, listen: false);

    return SizedBox(
      height: 80,
      width: 80,
      child: TextButton(
        key: Key(rowNumber.toString() + columnNumber.toString()),
        onPressed: () {
          if (!bloc.isSquaredMarkedByPlayer(rowNumber, columnNumber) &&
              !bloc.isSquaredMarkedByMachine(rowNumber, columnNumber)) {
            bloc.addSquareMarkedByPlayer(rowNumber, columnNumber);

            var isGameOver = _checkIsGameOver(bloc.getPlayerCode(), context);

            if (!isGameOver) {
              bloc.doMachineTurn();

              _checkIsGameOver(bloc.getMachineCode(), context);
            }
          } else {
            _showMessage("This square was already choosen", context);
          }
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.amber),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        child: Text(
          _getCodeToPopulateSquare(context, rowNumber, columnNumber),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
        ),
      ),
    );
  }

  String _getCodeToPopulateSquare(
    BuildContext context,
    int rowNumber,
    int columnNumber,
  ) {
    final AppBloc bloc = Provider.of<AppBloc>(context);

    if (bloc.isSquaredMarkedByPlayer(rowNumber, columnNumber)) {
      return bloc.getPlayerCode();
    } else if (bloc.isSquaredMarkedByMachine(rowNumber, columnNumber)) {
      return bloc.getMachineCode();
    }

    return "";
  }

  bool _checkIsGameOver(String code, BuildContext context) {
    final AppBloc bloc = Provider.of<AppBloc>(context, listen: false);

    var isGameOver = bloc.isGameOver();
    var isDraw = bloc.isDraw();

    if (isGameOver) {
      var whoIsPlaying = code == bloc.getPlayerCode() ? "Player" : "Machine";

      _showMessage("$whoIsPlaying won!", context);
      bloc.addWin(code);
    } else if (isDraw) {
      _showMessage("Draw!", context);
      bloc.addDraw();
    }

    if (isDraw || isGameOver) {
      _resetGameMap(bloc.resetGameMap);

      return true;
    }

    return false;
  }

  void _resetGameMap(Function() funcResetGameMap) {
    Future.delayed(const Duration(seconds: 1), funcResetGameMap);
  }

  void _showMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: Text(message),
          );
        });
  }
}
