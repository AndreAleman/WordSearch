// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  GameLevel(
    number: 1,
    difficulty: 5,
    // TODO: When ready, change these achievement IDs.
    // You configure this in App Store Connect.
    achievementIdIOS: 'first_win',
    // You get this string when you configure an achievement in Play Console.
    achievementIdAndroid: 'NhkIwB69ejkMAOOLDb',
  ),
  GameLevel(
    number: 2,
    difficulty: 32,
  ),
  GameLevel(
    number: 3,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96aspNWLGSQg',
  ),
  GameLevel(
    number: 4,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhw96aspNWLGSQg',
  ),
  GameLevel(
    number: 5,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfdhE96aspNWLGSQg',
  ),
  GameLevel(
    number: 6,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhEa6aspNWLGSQg',
  ),
  GameLevel(
    number: 7,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96aspNyLGSQg',
  ),
  GameLevel(
    number: 8,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhEaaaspNyLGSQg',
  ),
  GameLevel(
    number: 9,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CqqIhE96aspNyLGSQg',
  ),
  GameLevel(
    number: 10,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96abbNyLGSQg',
  ),
  GameLevel(
    number: 11,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96aspNyooSQg',
  ),
  GameLevel(
    number: 12,
    difficulty: 100,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96appNyLGSQg',
  ),
];

class GameLevel {
  final int number;

  final int difficulty;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.difficulty,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
