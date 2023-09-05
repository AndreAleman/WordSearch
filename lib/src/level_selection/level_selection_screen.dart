import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  // Remove the 'super(key: key)' part as it is not needed
  const LevelSelectionScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            // Widget to display the title of the screen
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Select Level',
                  style: TextStyle(fontFamily: 'Cursive', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Stream to listen for changes in the 'Levels' collection in Firestore
                stream: FirebaseFirestore.instance
                    .collection('Languages')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    // Show a loading indicator while data is being fetched
                    return Center(
                      child: Text(
                        'No Categories yet!',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    children: snapshot.data!.docs.map((document) {
                      return ListTile(
                        onTap: () {
                          final audioController =
                              context.read<AudioController>();
                          audioController.playSfx(SfxType.buttonTap);
                          // Navigate to the CategorySelectionScreen with the level document ID
                          GoRouter.of(context)
                              .go('/play/categories/${document.id}');
                        },
                        // Display the level ID as the title of the ListTile
                        title: Text('Level ${document.id}'),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
        rectangularMenuArea: FilledButton(
          onPressed: () {
            // Navigate back to the previous screen
            GoRouter.of(context).go('/');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
