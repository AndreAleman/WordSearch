import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/level_state.dart';
import '../games_services/games_services.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class WordSearchScreen extends StatefulWidget {
  final String category;
  final String language;

  const WordSearchScreen({
    Key? key,
    required this.category,
    required this.language,
  }) : super(key: key);

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  StreamSubscription<QuerySnapshot>? _subscription;
  List<Map<String, dynamic>> _wordPairs = [];
  int _currentPairIndex = 0;
  bool _isFound = false;
  Map<String, dynamic>? _wordPairsData;
  String? _englishWord;
  List<List<String>> _wordSearchGrid = [];
  final int gridSize = 10;
  int wordLength = 0; // Length of the objective word
  int startRow = 0;
  int startCol = 0;

  @override
  void initState() {
    super.initState();
    _subscribeToWordPairs();
  }

  List<int> getRandomDirection() {
    final random = Random();
    final directions = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]; // Represents the 8 possible directions
    return directions[random.nextInt(directions.length)];
  }

// Generate the initial word search grid with the objective word and random letters
  void _generateWordSearchGrid(String objectiveWord) {
    objectiveWord.toUpperCase();
    // Initialize the grid with empty strings
    for (int i = 0; i < gridSize; i++) {
      List<String> row = List<String>.filled(gridSize, '');
      _wordSearchGrid.add(row);
    }

    // Randomly select a starting point
    final random = Random();
    startRow = random.nextInt(gridSize);
    startCol = random.nextInt(gridSize);

    // Try to place the objective word in a random direction
    bool wordPlaced = false;
    print('$objectiveWord we made it');
    while (!wordPlaced) {
      List<int> direction = getRandomDirection();
      int dx = direction[0], dy = direction[1];

      int endRow = startRow + dx * (wordLength - 1);
      int endCol = startCol + dy * (wordLength - 1);

      print('Direction: $direction');
      print('Start: ($startRow, $startCol)');
      print('End: ($endRow, $endCol)');

      // Check if the word fits within the grid bounds
      if (endRow >= 0 &&
          endCol >= 0 &&
          endRow < gridSize &&
          endCol < gridSize) {
        // If it fits, place the word in the grid in the current direction
        for (int i = 0; i < wordLength; i++) {
          _wordSearchGrid[startRow + i * dx][startCol + i * dy] =
              _englishWord![i];
          print('in the for loop');
        }
        wordPlaced = true;
        print('wordplace = true');
      }
    }

    // Fill the rest of the grid with random letters
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (_wordSearchGrid[i][j] == '') {
          _wordSearchGrid[i][j] = _getRandomLetter();
        }
      }
    }
  }

  // Generate a random letter
  String _getRandomLetter() {
    final random = Random();
    int randomIndex = random.nextInt(26);
    String letter = String.fromCharCode(65 + randomIndex);
    return letter;
  }

  // Subscribe to the word pairs data from the database
  void _subscribeToWordPairs() {
    final categoriesCollection = FirebaseFirestore.instance
        .collection('Languages')
        .doc(widget.language)
        .collection('Categories');

    categoriesCollection
        .doc(widget.category)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _wordPairsData = snapshot.data() as Map<String, dynamic>;
          _englishWord = _wordPairsData!['pair1']['word1'];
          wordLength = _englishWord!.length;
          print(
              '_englishWord: $_englishWord'); // Set the word length based on the objective word
        });
        if (_englishWord != null) {
          _generateWordSearchGrid(_englishWord!); // Pass the non-null value
        }
      }
    });
  }

  // Mark the objective word as found
  void _markWordAsFound() {
    setState(() {
      _isFound = true;
    });
  }

  // Place the objective word in the word search grid

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$wordLength ($startRow, $startCol)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Word Pairs:'),
            if (_englishWord != null)
              Text(
                _englishWord!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 10),
            Text('Word Search Grid:'),
            for (List<String> row in _wordSearchGrid)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (String letter in row)
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(child: Text(letter)),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
