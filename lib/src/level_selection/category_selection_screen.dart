import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final String language; // The selected language

  const CategorySelectionScreen({Key? key, required this.language})
      : super(key: key);

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
                  'Select Category',
                  style: TextStyle(fontFamily: 'Cursive', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Stream to listen for changes in the categories collection for the selected language
                stream: FirebaseFirestore.instance
                    .collection('Languages')
                    .doc(language)
                    .collection('Categories')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while data is being fetched
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show an error message
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    // Show a message when there are no categories
                    return Center(child: Text('No categories found'));
                  } else {
                    // Display the categories
                    return GridView.count(
                      crossAxisCount: 2,
                      children: snapshot.data!.docs.map((document) {
                        return ListTile(
                          onTap: () {
                            final audioController =
                                context.read<AudioController>();
                            audioController.playSfx(SfxType.buttonTap);
                            // Navigate to the WordPairSelectionScreen with the category document ID
                            GoRouter.of(context).go(
                                '/play/categories/${language}/wordsearch/${document.id}');
                          },
                          // Display the category name as the title of the ListTile
                          title: Text(document.id),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        rectangularMenuArea: FilledButton(
          onPressed: () {
            // Navigate back to the previous screen
            GoRouter.of(context).go('/play');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
