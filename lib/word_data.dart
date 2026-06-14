// word categories for the game (includes both "regular" topics as well as some bca specific people/ places)

import 'dart:math';
import 'models.dart';

// each category maps to a list of possible secret words.
const Map<String, List<String>> categories = {
  'Food': [
    'Pizza', 'Sushi', 'Pancakes', 'Tacos', 'Ramen', 'Burger',
    'Ice cream', 'Spaghetti', 'Dumplings', 'Popcorn', 'Waffles', 'Burrito',
  ],
  'Animals': [
    'Elephant', 'Penguin', 'Dolphin', 'Tiger', 'Kangaroo', 'Owl',
    'Octopus', 'Giraffe', 'Hedgehog', 'Panda', 'Falcon', 'Otter',
  ],
  'Places': [
    'Beach', 'Library', 'Airport', 'Castle', 'Hospital', 'Museum',
    'Stadium', 'Mountain', 'Desert', 'Subway', 'Farm', 'Lighthouse',
  ],
  'Sports': [
    'Soccer', 'Basketball', 'Tennis', 'Swimming', 'Skiing', 'Boxing',
    'Cricket', 'Volleyball', 'Cycling', 'Surfing', 'Archery', 'Bowling',
  ],
  'Jobs': [
    'Teacher', 'Pilot', 'Chef', 'Doctor', 'Firefighter', 'Artist',
    'Farmer', 'Astronaut', 'Plumber', 'Lawyer', 'Barber', 'Scientist',
  ],
  'Everyday Objects': [
    'Umbrella', 'Toothbrush', 'Backpack', 'Mirror', 'Candle', 'Pillow',
    'Scissors', 'Stapler', 'Kettle', 'Remote', 'Wallet', 'Flashlight',
  ],
  'BCA Locations': [
    'Lower Caf.', 'Upper Caf.', 'Loft', 'Track', 'Basketball Court',
    'Chess Board', 'QuickCheck', 'Chic-Fil-A', 'Breezeway', 'Commons',
  ],
  'BCA (jr/snr) Classes': [
    'AP Chem', 'AP Comp Sci', 'Adv. Physics', 'AP Bio', 'Organic Chemistry', 'Adv. Topics in Chemistry',
    'AP Calc BC+', 'AP Calc BC', 'AP Calc AB', 'Engineering', 'Economics', "IB English", "IB Spanish",
  ],
  'BCA Events': [
    'Academy Volleyball Tourney', 'Ice Cream Truck', 'Prom', 'Fall Ball', 'Semi-Formal', 'IDA'
  ],
};

/// picks one secret word and randomly assigns the imposters.
GameRound buildRound(GameConfig config) {
  final rng = Random();

  final words = categories[config.category]!;
  final secret = words[rng.nextInt(words.length)];

  // randomly choose which player indexes are imposters.
  final indices = List<int>.generate(config.playerCount, (i) => i)..shuffle(rng);
  final imposterIndices = indices.take(config.imposterCount).toSet();
  final isImposter = List<bool>.generate(
    config.playerCount,
    (i) => imposterIndices.contains(i),
  );

  return GameRound(
    secretWord: secret,
    category: config.category,
    isImposter: isImposter,
  );
}
