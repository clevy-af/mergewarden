import 'dart:math';

import 'package:mergewarden/model/requirements.dart';

class MergeCalculator {

  static Map<String, int> calculateRequired(int targetCount) {
    // How many sets of 2 can we get from merging 5?
    int setsOfTwo = targetCount ~/ 2;
    int remainder = targetCount % 2;

    int totalNeeded = (setsOfTwo * 5) + (remainder * 3);

    return {
      'count': totalNeeded,
      'merge5s': setsOfTwo,
      'merge3s': remainder,
    };
  }


  /// Calculates how many each Level of items are needed to produce [targetLevel] x [targetCount].
  /// [has0] includes seed stage.
//   static Map<int, int> getFullBreakdown(int targetLevel, int targetCount,[int potions=0,bool has0=false]) {
//     Map<int, int> breakdown = {targetLevel: targetCount};
//
//     int currentLevelCount = targetCount;
//     int lowestLevel = has0?0:1;
//     // Step down through each level
//     for (int level = targetLevel; level > lowestLevel; level--) {
//       // Logic: groups of 5 give 2, remainder (if odd) needs a merge of 3 to give 1
//       int setsOfTwo = currentLevelCount ~/ 2;
//       int remainder = currentLevelCount % 2;
//
//       int merges= setsOfTwo+remainder;
//
//       int neededForLevelBelow = (setsOfTwo * 5) + (remainder * 3);
//
//       for(int i=0;i<merges&&potions>1;i++){
//         neededForLevelBelow--;
//         potions--;
//       }
//       breakdown[level - 1] = neededForLevelBelow;
//       currentLevelCount = neededForLevelBelow;
//     }
//
//     return breakdown;
//
// }
  static List<Breakup> getFullBreakdown(int targetLevel, int targetCount,[int potions=0,bool has0=false]) {
    List<Breakup> breakdown = [
      Breakup(stage: targetLevel, count: targetCount, potionsUsed: 0)
    ];

    int currentLevelCount = targetCount;
    int lowestLevel = has0?0:1;
    int potionsLeft=potions;
    // Step down through each level
    for (int level = targetLevel; level > lowestLevel; level--) {
      // Logic: groups of 5 give 2, remainder (if odd) needs a merge of 3 to give 1
      int setsOfTwo = currentLevelCount ~/ 2;
      int remainder = currentLevelCount % 2;

      int merges= setsOfTwo+remainder;

      int neededForLevelBelow = (setsOfTwo * 5) + (remainder * 3);
      // int i=0;
       var minusValue = min(merges, potionsLeft);
     if(potionsLeft>0) {
       neededForLevelBelow = neededForLevelBelow - minusValue;
      // print({'stage':level-1,'potions':minusValue});
      potionsLeft=potionsLeft-minusValue;
     }
      // breakdown[level - 1] = neededForLevelBelow;
      breakdown.add(Breakup(stage: level-1, count: neededForLevelBelow, potionsUsed: minusValue));
      currentLevelCount = neededForLevelBelow;
    }

    return breakdown;

}

  /// Calculates how many each Level of Wildlife are needed to produce [targetLevel] x [targetCount].
  // static Map<int, int> calculateWildlife(int targetLevel, int targetCount) {
  //   Map<int, int> breakdown = {targetLevel: targetCount};
  //   int currentNeeded = targetCount;
  //
  //   // Loop backwards from Target to Stage 0
  //   for (int i = targetLevel; i > 0; i--) {
  //     int neededForPrevious;
  //     // print(i);
  //     if (i == 5) {
  //       // GOAL: Get Stage 5 from Stage 4.5 (Eggs)
  //       // Standard merge: 5 eggs -> 2 Stage 5
  //       int eggsRequired = (currentNeeded ~/ 2 * 5) + (currentNeeded % 2 * 3);
  //       breakdown[45] = eggsRequired; // Store as "Stage 4.5"
  //
  //       // GOAL: Get those Eggs from Stage 4
  //       // Rule: 5 Stage 4 -> 6 Eggs
  //       // We need (eggsRequired / 6) sets of five Stage 4s
  //       double setsOfFiveNeeded = eggsRequired / 12;
  //       neededForPrevious = (setsOfFiveNeeded.ceil() * 5);
  //
  //     } else if (i == 45) {
  //       // This is just a placeholder to skip the loop logic
  //       // since we handled 4.5 inside the i==5 block
  //       continue;
  //     } else {
  //       // Standard 5-for-2 logic for all other stages
  //       neededForPrevious = (currentNeeded ~/ 2 * 5) + (currentNeeded % 2 * 3);
  //     }
  //
  //     // If we are at Stage 5, the "previous" is Stage 4
  //     int actualLevelKey = (i == 5) ? 4 : i - 1;
  //     breakdown[actualLevelKey] = neededForPrevious;
  //     currentNeeded = neededForPrevious;
  //   }
  //
  //   return breakdown;
  // }
  static List<Breakup> calculateWildlife(int targetLevel, int targetCount) {
    List<Breakup> breakdown = [
      Breakup(stage: targetLevel, count: targetCount, potionsUsed: 0)
    ];
    int currentNeeded = targetCount;

    // Loop backwards from Target to Stage 0
    for (int i = targetLevel; i > 0; i--) {
      int neededForPrevious;
      // print(i);
      if (i == 5) {
        // GOAL: Get Stage 5 from Stage 4.5 (Eggs)
        // Standard merge: 5 eggs -> 2 Stage 5
        int eggsRequired = (currentNeeded ~/ 2 * 5) + (currentNeeded % 2 * 3);
        // breakdown[45] = eggsRequired; // Store as "Stage 4.5"
        breakdown.add(Breakup(stage: 45, count: eggsRequired, potionsUsed: 0));

        // GOAL: Get those Eggs from Stage 4
        // Rule: 5 Stage 4 -> 6 Eggs
        // We need (eggsRequired / 6) sets of five Stage 4s
        double setsOfFiveNeeded = eggsRequired / 12;
        neededForPrevious = (setsOfFiveNeeded.ceil() * 5);

      } else if (i == 45) {
        // This is just a placeholder to skip the loop logic
        // since we handled 4.5 inside the i==5 block
        continue;
      } else {
        // Standard 5-for-2 logic for all other stages
        neededForPrevious = (currentNeeded ~/ 2 * 5) + (currentNeeded % 2 * 3);
      }

      // If we are at Stage 5, the "previous" is Stage 4
      int actualLevelKey = (i == 5) ? 4 : i - 1;
      // breakdown[actualLevelKey] = neededForPrevious;
      breakdown.add(Breakup(stage: actualLevelKey, count: neededForPrevious, potionsUsed: 0));

      currentNeeded = neededForPrevious;
    }

    return breakdown;
  }
}
