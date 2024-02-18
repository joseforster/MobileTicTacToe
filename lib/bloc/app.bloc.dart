import 'dart:math';
import 'package:flutter/material.dart';

class _MachineGameOrientation {
  final int rowToBeMarked;
  final int columnToBeMarked;
  final int squaresMarkedByPlayer;
  final int squaresMarkedByMachine;

  _MachineGameOrientation(
    this.rowToBeMarked,
    this.columnToBeMarked,
    this.squaresMarkedByPlayer,
    this.squaresMarkedByMachine,
  );
}

class AppBloc extends ChangeNotifier {
  static const machineCode = "O";
  static const playerCode = "X";
  static const rowNumbers = [0, 1, 2];
  static const columnNumbers = [0, 1, 2];

  late Map<int, Map<int, String?>> gameMap;
  late int playerVictories;
  late int playerDefeats;
  late int draws;

  AppBloc() {
    _createGameMap();

    playerVictories = 0;
    playerDefeats = 0;
    draws = 0;
  }

  void _createGameMap() {
    gameMap = {};

    for (var i = 0; i < rowNumbers.length; i++) {
      var rowNumber = rowNumbers[i];

      var columns = <int, String?>{};

      for (var j = 0; j < columnNumbers.length; j++) {
        var columnNumber = columnNumbers[j];

        columns[columnNumber] = null;
      }

      gameMap[rowNumber] = columns;
    }
  }

  void resetGameMap() {
    _createGameMap();

    notifyListeners();
  }

  void addWin(String winnerCode) {
    if (winnerCode == playerCode) {
      playerVictories++;
    } else if (winnerCode == machineCode) {
      playerDefeats++;
    }

    notifyListeners();
  }

  void addDraw() {
    draws++;
    notifyListeners();
  }

  String getPlayerCode() {
    return playerCode;
  }

  String getMachineCode() {
    return machineCode;
  }

  void addSquareMarkedByPlayer(int rowNumber, int columnNumber) {
    _markSquare(rowNumber, columnNumber, playerCode);
  }

  void _markSquare(int rowNumber, int columnNumber, String code) {
    var columns = _getColumnsByRowNumber(rowNumber);

    columns[columnNumber] = code;

    notifyListeners();
  }

  bool isGameOver() {
    return _isAnyRowFullMarked() ||
        _isAnyColumnFullMarked() ||
        _isAnyDiagonalFullMarked();
  }

  bool isDraw() {
    var isAnySquareAvailable = false;

    gameMap.forEach((row, columns) {
      columns.forEach((column, value) {
        if (value == null) {
          isAnySquareAvailable = true;
        }
      });
    });

    return !isAnySquareAvailable;
  }

  bool _isAnyDiagonalFullMarked() {
    var squaresMarkedByPlayer = 0;
    var squaresMarkedByMachine = 0;

    //checking the first diagonal
    gameMap.forEach((row, columns) {
      columns.forEach((column, value) {
        if (row == column) {
          if (value == playerCode) {
            squaresMarkedByPlayer++;
          } else if (value == machineCode) {
            squaresMarkedByMachine++;
          }
        }
      });
    });

    if (_isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByPlayer) ||
        _isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByMachine)) {
      return true;
    }
    squaresMarkedByPlayer = 0;
    squaresMarkedByMachine = 0;

    //checking the second diagonal
    gameMap.forEach((row, columns) {
      columns.forEach((column, value) {
        if (row + column == rowNumbers.length - 1 ||
            row + column == columnNumbers.length - 1) {
          if (value == playerCode) {
            squaresMarkedByPlayer++;
          } else if (value == machineCode) {
            squaresMarkedByMachine++;
          }
        }
      });
    });

    return _isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByPlayer) ||
        _isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByMachine);
  }

  bool _isAnyColumnFullMarked() {
    for (int i = 0; i < columnNumbers.length; i++) {
      var columnNumber = columnNumbers[i];

      var squaresMarkedByPlayer = 0;
      var squaresMarkedByMachine = 0;

      gameMap.forEach((row, columns) {
        columns.forEach((column, value) {
          if (column == columnNumber) {
            if (value == playerCode) {
              squaresMarkedByPlayer++;
            } else if (value == machineCode) {
              squaresMarkedByMachine++;
            }
          }
        });
      });

      if (_isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByMachine) ||
          _isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByPlayer)) {
        return true;
      }
    }
    return false;
  }

  bool _isAnyRowFullMarked() {
    var isAnyRowFullMarked = false;

    gameMap.forEach((row, columns) {
      if (!isAnyRowFullMarked) {
        int squaresMarkedByPlayer = 0;
        int squaresMarkedByMachine = 0;

        columns.forEach((column, value) {
          if (value == playerCode) {
            squaresMarkedByPlayer++;
          } else if (value == machineCode) {
            squaresMarkedByMachine++;
          }
        });

        if (_isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByMachine) ||
            _isAllSquaresInTheSameRowOrColumnMarked(squaresMarkedByPlayer)) {
          isAnyRowFullMarked = true;
        }
      }
    });

    return isAnyRowFullMarked;
  }

  bool _isAllSquaresInTheSameRowOrColumnMarked(int squaresMarked) {
    return squaresMarked == 3;
  }

  void doMachineTurn() {
    var listMachineGameOrientation = List<_MachineGameOrientation>.empty(
      growable: true,
    );

    listMachineGameOrientation.addAll(_getGameOrientationsForRows());
    listMachineGameOrientation.addAll(_getGameOrientationsForColumns());
    listMachineGameOrientation.addAll(_getGameOrientationsForDiagonals());

    if (listMachineGameOrientation
        .any((element) => element.squaresMarkedByMachine == 2)) {
      var machineGameOrientation = listMachineGameOrientation
          .firstWhere((element) => element.squaresMarkedByMachine == 2);

      _markSquare(machineGameOrientation.rowToBeMarked,
          machineGameOrientation.columnToBeMarked, machineCode);
    } else if (listMachineGameOrientation
        .any((element) => element.squaresMarkedByPlayer == 2)) {
      var machineGameOrientation = listMachineGameOrientation
          .firstWhere((element) => element.squaresMarkedByPlayer == 2);

      _markSquare(machineGameOrientation.rowToBeMarked,
          machineGameOrientation.columnToBeMarked, machineCode);
    } else {
      _doRandomMove();
    }
  }

  List<_MachineGameOrientation> _getGameOrientationsForRows() {
    var listMachineGameOrientation = List<_MachineGameOrientation>.empty(
      growable: true,
    );

    gameMap.forEach((row, columns) {
      int squaresMarkedByPlayer = 0;
      int squaresMarkedByMachine = 0;
      int? columnToBeMarked;
      int? rowToBeMarked;

      columns.forEach((column, value) {
        if (value == playerCode) {
          squaresMarkedByPlayer++;
        } else if (value == machineCode) {
          squaresMarkedByMachine++;
        } else {
          columnToBeMarked = column;
          rowToBeMarked = row;
        }
      });

      if (rowToBeMarked != null &&
          columnToBeMarked != null &&
          (squaresMarkedByPlayer == 2 || squaresMarkedByMachine == 2)) {
        listMachineGameOrientation.add(_MachineGameOrientation(rowToBeMarked!,
            columnToBeMarked!, squaresMarkedByPlayer, squaresMarkedByMachine));
      }
    });

    return listMachineGameOrientation;
  }

  List<_MachineGameOrientation> _getGameOrientationsForColumns() {
    var listMachineGameOrientation = List<_MachineGameOrientation>.empty(
      growable: true,
    );

    for (int i = 0; i < columnNumbers.length; i++) {
      int squaresMarkedByPlayer = 0;
      int squaresMarkedByMachine = 0;
      int? rowToBeMarked;
      int? columnToBeMarked;

      var columnNumber = columnNumbers[i];

      gameMap.forEach((row, columns) {
        if (columns[columnNumber] == playerCode) {
          squaresMarkedByPlayer++;
        } else if (columns[columnNumber] == machineCode) {
          squaresMarkedByMachine++;
        } else {
          rowToBeMarked = row;
          columnToBeMarked = columnNumber;
        }
      });

      if (rowToBeMarked != null &&
          columnToBeMarked != null &&
          (squaresMarkedByPlayer == 2 || squaresMarkedByMachine == 2)) {
        listMachineGameOrientation.add(_MachineGameOrientation(rowToBeMarked!,
            columnToBeMarked!, squaresMarkedByPlayer, squaresMarkedByMachine));
      }
    }

    return listMachineGameOrientation;
  }

  List<_MachineGameOrientation> _getGameOrientationsForDiagonals() {
    var listMachineGameOrientation = List<_MachineGameOrientation>.empty(
      growable: true,
    );

    listMachineGameOrientation.addAll(_getGameOrientationForFirstDiagonal());
    listMachineGameOrientation.addAll(_getGameOrientationForSecondDiagonal());

    return listMachineGameOrientation;
  }

  List<_MachineGameOrientation> _getGameOrientationForSecondDiagonal() {
    var listMachineGameOrientation = List<_MachineGameOrientation>.empty(
      growable: true,
    );

    var squaresMarkedByPlayer = 0;
    var squaresMarkedByMachine = 0;
    var rowToBeMarked = null;
    var columnToBeMarked = null;

    gameMap.forEach((row, columns) {
      columns.forEach((column, value) {
        if (row + column == 2) {
          if (value == playerCode) {
            squaresMarkedByPlayer++;
          } else if (value == machineCode) {
            squaresMarkedByMachine++;
          } else {
            columnToBeMarked = column;
            rowToBeMarked = row;
          }
        }
      });
    });

    if (rowToBeMarked != null &&
        columnToBeMarked != null &&
        (squaresMarkedByPlayer == 2 || squaresMarkedByMachine == 2)) {
      listMachineGameOrientation.add(_MachineGameOrientation(rowToBeMarked!,
          columnToBeMarked!, squaresMarkedByPlayer, squaresMarkedByMachine));
    }

    return listMachineGameOrientation;
  }

  List<_MachineGameOrientation> _getGameOrientationForFirstDiagonal() {
    var listMachineGameOrientation = List<_MachineGameOrientation>.empty(
      growable: true,
    );

    int squaresMarkedByPlayer = 0;
    int squaresMarkedByMachine = 0;
    int? rowToBeMarked;
    int? columnToBeMarked;

    gameMap.forEach((row, columns) {
      columns.forEach((column, value) {
        if (row == column) {
          if (value == playerCode) {
            squaresMarkedByPlayer++;
          } else if (value == machineCode) {
            squaresMarkedByMachine++;
          } else {
            columnToBeMarked = column;
            rowToBeMarked = row;
          }
        }
      });
    });

    if (rowToBeMarked != null &&
        columnToBeMarked != null &&
        (squaresMarkedByPlayer == 2 || squaresMarkedByMachine == 2)) {
      listMachineGameOrientation.add(_MachineGameOrientation(rowToBeMarked!,
          columnToBeMarked!, squaresMarkedByPlayer, squaresMarkedByMachine));
    }

    return listMachineGameOrientation;
  }

  void _doRandomMove() {
    var didMove = false;

    while (!didMove) {
      var rowNumber = Random().nextInt(3);
      var columnNumber = Random().nextInt(3);

      if (!isSquaredMarkedByMachine(rowNumber, columnNumber) &&
          !isSquaredMarkedByPlayer(rowNumber, columnNumber)) {
        _markSquare(rowNumber, columnNumber, machineCode);
        didMove = true;
      }
    }
  }

  bool isSquaredMarkedByPlayer(int rowNumber, int columnNumber) {
    var columns = _getColumnsByRowNumber(rowNumber);

    return columns[columnNumber] != null && columns[columnNumber] == playerCode;
  }

  bool isSquaredMarkedByMachine(int rowNumber, int columnNumber) {
    var columns = _getColumnsByRowNumber(rowNumber);

    return columns[columnNumber] != null &&
        columns[columnNumber] == machineCode;
  }

  Map<int, String?> _getColumnsByRowNumber(int rowNumber) {
    return gameMap[rowNumber] as Map<int, String?>;
  }
}
