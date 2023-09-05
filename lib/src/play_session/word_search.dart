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

  @override
  void initState() {
    super.initState();
    _subscribeToWordPairs();
    _generateWordSearchGrid();
  }

  void _generateWordSearchGrid() {
    for (int i = 0; i < 10; i++) {
      List<String> row = [];
      for (int j = 0; j < 10; j++) {
        String randomLetter = _getRandomLetter();
        row.add(randomLetter);
      }
      _wordSearchGrid.add(row);
    }
  }

  String _getRandomLetter() {
    final random = Random();
    int randomIndex = random.nextInt(26);
    String letter = String.fromCharCode(65 + randomIndex);
    return letter;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
        });
      }
    });
  }

  void _markWordAsFound() {
    setState(() {
      _isFound = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search'),
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
            SizedBox(height: 16),
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
