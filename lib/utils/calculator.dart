import 'dart:math';

import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/utils/extension.dart';

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

  static List<Breakup> getFullBreakdown(int targetLevel, int targetCount,[int potions=0,bool has0=false,bool merge5Only=true]) {
    List<Breakup> breakdown = [
      Breakup(stage: targetLevel, count: targetCount, potions: 0, mergeBy3: merge5Only?-1:0, mergeBy5: 0,)
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

      int neededForLevelBelow = (setsOfTwo * 5) + remainder.remainingCount(merge5Only);
      int surplus = merge5Only&&remainder>0?5-remainder:0;
      // int i=0;
       var minusValue = min(merges, potionsLeft);
     if(potionsLeft>0) {
       neededForLevelBelow = neededForLevelBelow - minusValue;
      // print({'stage':level-1,'potions':minusValue});
      potionsLeft=potionsLeft-minusValue;
     }
      // breakdown[level - 1] = neededForLevelBelow;
      breakdown.add(Breakup(
          stage: level-1, count: neededForLevelBelow, potions: minusValue,
        mergeBy3: (merge5Only?-1:1)*remainder,
        mergeBy5: setsOfTwo,
        surplus: surplus
      )
      );
      currentLevelCount = neededForLevelBelow;
    }

    return breakdown;

}

  /// Calculates how many each Level of Wildlife are needed to produce [targetLevel] x [targetCount].
  static List<Breakup> calculateWildlife(int targetLevel, int targetCount,[bool merge5Only=true]) {
    List<Breakup> breakdown = [
      Breakup(stage: targetLevel, count: targetCount, potions: 0, mergeBy5: 0, mergeBy3: 0,surplus: targetCount.isOdd?1:0)
    ];
    int currentNeeded = targetCount;

    // Loop backwards from Target to Stage 0
    for (int i = targetLevel; i > 0; i--) {
      int neededForPrevious,setsBy5,setsBy3;
      // print(i);
      if (i == 5) {
        // GOAL: Get Stage 5 from Stage 4.5 (Eggs)
        // Standard merge: 5 eggs -> 2 Stage 5

         setsBy5=currentNeeded ~/ 2;
         setsBy3=currentNeeded% 2;
        int eggsRequired = ( setsBy5* 5) +setsBy3.remainingCount( merge5Only);

        // breakdown[45] = eggsRequired; // Store as "Stage 4.5"

        breakdown.add(Breakup(stage: 45, count: eggsRequired, potions: 0, mergeBy3: merge5Only?-1:currentNeeded%2, mergeBy5: merge5Only?setsBy5:-1,surplus: merge5Only?eggsRequired%5:0));
        // GOAL: Get those Eggs from Stage 4
        // Rule: 5 Stage 4 -> 6 Eggs
        // We need (eggsRequired / 6) sets of five Stage 4s
        double setsOfFiveNeeded = eggsRequired / 6;
        int setsOf3Needed = eggsRequired %6;
        neededForPrevious = (setsOfFiveNeeded.floor())* 5+(setsOf3Needed.remainingCount(merge5Only));

      } else if (i == 45) {
        // This is just a placeholder to skip the loop logic
        // since we handled 4.5 inside the i==5 block
        continue;
      } else {
        // Standard 5-for-2 logic for all other stages
         setsBy5=currentNeeded ~/ 2;
         setsBy3=currentNeeded% 2;
        neededForPrevious = ( setsBy5* 5) +setsBy3.remainingCount( merge5Only);
      }

      // If we are at Stage 5, the "previous" is Stage 4
      int actualLevelKey = (i == 5) ? 4 : i - 1;
      // breakdown[actualLevelKey] = neededForPrevious;
      breakdown.add(Breakup(stage: actualLevelKey, count: neededForPrevious, potions: 0, mergeBy3: merge5Only?-1:currentNeeded%2, mergeBy5: merge5Only?setsBy5:-1,));

      currentNeeded = neededForPrevious;
    }

    return breakdown;
  }


  Map<int, int> calculateGlobalMaxReach(Map<int, int> physicalInventory) {
    // 1. Create a working copy of the inventory
    Map<int, int> currentStatus = Map.from(physicalInventory);

    // 2. Determine the range of levels
    int minLevel = currentStatus.keys.reduce((a, b) => a < b ? a : b);
    int maxLevel = currentStatus.keys.reduce((a, b) => a > b ? a : b);

    // 3. Sweep Upward
    for (int lvl = minLevel; lvl <= maxLevel || currentStatus[lvl] != null; lvl++) {
      int countAtLevel = currentStatus[lvl] ?? 0;

      if (countAtLevel >= 5) {
        int setsOfFive = countAtLevel ~/ 5;
        int remainder = countAtLevel % 5;
        int producedNextLevel = setsOfFive * 2;

        // Update current level to show only what couldn't be merged
        currentStatus[lvl] = remainder;

        // Add the produced items to the next level's existing inventory
        currentStatus[lvl + 1] = (currentStatus[lvl + 1] ?? 0) + producedNextLevel;

        // Expand maxLevel if we just created a new highest stage
        if (lvl + 1 > maxLevel) maxLevel = lvl + 1;
      } else if (countAtLevel >= 3 && lvl == maxLevel) {
        // Optional: One final Merge-3 if it's the absolute highest reach possible
        currentStatus[lvl] = countAtLevel - 3;
        currentStatus[lvl + 1] = 1;
        maxLevel = lvl + 1;
      }
    }

    // Remove levels with 0 items for a clean output
    currentStatus.removeWhere((key, value) => value == 0);
    return currentStatus;
  }
}
