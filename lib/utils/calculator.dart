import 'dart:math';

import 'package:mergewarden/model/json.dart';
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
      Breakup(stage: targetLevel, count: targetCount, potions: 0,)
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
       var minusValue = min(merges, potionsLeft);
     if(potionsLeft>0) {
       neededForLevelBelow = neededForLevelBelow - minusValue;
      // print({'stage':level-1,'potions':minusValue});
      potionsLeft=potionsLeft-minusValue;
     }
      // breakdown[level - 1] = neededForLevelBelow;
      breakdown.add(Breakup(
          stage: level-1, count: neededForLevelBelow,
        potions: minusValue,)
      );
      currentLevelCount = neededForLevelBelow;
    }

    return breakdown;

}

  static List<Breakup> getFullBreakdownAdjusted(
      int targetLevel,
      int targetCount, {
        Map<int, int> inventory = const {},
        int potions = 0,
        bool has0 = false,
        bool merge5Only = true,
      }) {
    List<Breakup> breakdown = [];
    int currentNeededAtThisLevel = targetCount;
    int lowestLevel = has0 ? 0 : 1;
    int potionsLeft = potions;

    // Step down from Target to Bottom
    for (int level = targetLevel; level >= lowestLevel; level--) {
      // 1. Get inventory for this specific level
      int owned = inventory[level] ?? 0;

      // 2. IMPORTANT: Subtract inventory from what we need
      // This 'netNeed' is what we actually have to build/merge
      int netNeed = (currentNeededAtThisLevel - owned).clamp(0, currentNeededAtThisLevel).toInt();

      // 3. Add to our report
      breakdown.add(Breakup(
        stage: level,
        count: netNeed, // This shows the user exactly what's left to do
        potions: 0,
      ));

      // 4. Calculate requirements for the level BELOW
      if (level > lowestLevel) {
        int neededForLevelBelow;

        if (merge5Only) {
          // Strictly 5-for-2
          neededForLevelBelow = (netNeed / 2).ceil() * 5;
        } else {
          // Hybrid 5-for-2 and 3-for-1
          int setsOfTwo = netNeed ~/ 2;
          int remainder = netNeed % 2;
          neededForLevelBelow = (setsOfTwo * 5) + (remainder * 3);
        }

        // 5. Apply Potion Logic to the requirement we just calculated
        int merges = (netNeed / 2).ceil();
        int potionsToUse = min(merges, potionsLeft);

        if (potionsToUse > 0) {
          neededForLevelBelow = (neededForLevelBelow - potionsToUse).clamp(0, double.infinity).toInt();
          potionsLeft -= potionsToUse;
        }

        // Set the requirement for the next iteration
        currentNeededAtThisLevel = neededForLevelBelow;
      }
    }

    return breakdown;
  }
  /// Calculates how many each Level of Wildlife are needed to produce [targetLevel] x [targetCount].
  static List<Breakup> calculateWildlife(int targetLevel, int targetCount,[bool merge5Only=true]) {
    List<Breakup> breakdown = [
      Breakup(stage: targetLevel, count: targetCount, potions: 0)
    ];
    List<int> stageHierarchy = [8, 7, 6, 5, 45, 4, 3, 2, 1, 0];
    int startIndex = stageHierarchy.indexOf(targetLevel);
    if (startIndex == -1) return [];
    int currentNeeded = targetCount;
    // print(currentNeeded);

    // Iterate through the hierarchy list instead of a number range
    for (int i = startIndex; i < stageHierarchy.length - 1; i++) {
      int neededForPrevious,setsBy5,setsBy3;
      int currentStage = stageHierarchy[i];
      int nextStage = stageHierarchy[i + 1];

      if (currentStage == 5 && nextStage == 45) {
        // Logic for Stage 5 -> Eggs (Stage 45)
         setsBy5 = currentNeeded ~/ 2;
         setsBy3 = currentNeeded % 2;
        neededForPrevious = (setsBy5 * 5) + setsBy3.remainingCount(merge5Only);

      } else if (currentStage == 45 && nextStage == 4) {
        // NEW RULE: 5 Stage 4 -> 12 Eggs | 3 Stage 4 -> 6 Eggs

        if (merge5Only) {
          // Strictly 5-merges (sets of 12)
          int setsOfTwelve = (currentNeeded / 12).ceil();
          neededForPrevious = setsOfTwelve * 5;
        } else {
          // Hybrid logic: Prioritize 12s, then 6s
          int setsOfTwelve = currentNeeded ~/ 12; // Whole sets of 5-merges
          int remainder = currentNeeded % 12;

          int additionalItems = 0;
          if (remainder > 0) {
            if (remainder <= 6) {
              // A single 3-merge (6 eggs) is more efficient than a 5-merge
              additionalItems = 3;
            } else {
              // Remainder is 7-11; a 5-merge (12 eggs) is required
              additionalItems = 5;
            }
          }

          neededForPrevious = (setsOfTwelve * 5) + additionalItems;
        }
      } else {
        // Standard 5-for-2 logic
        int setsBy5 = currentNeeded ~/ 2;
        int setsBy3 = currentNeeded % 2;
        neededForPrevious = (setsBy5 * 5) + setsBy3.remainingCount(merge5Only);
      }

      breakdown.add(Breakup(stage: nextStage, count: neededForPrevious, potions: 0,));

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
  static Map<int, int> calculateMaxReachStat(
      Map<int, int> physicalInventory, {
        bool merge5Only = true,
      }) {
    // 1. Working copy to store our "Ghost" results
    Map<int, int> ghostInventory = Map.from(physicalInventory);

    if (ghostInventory.isEmpty) return {};

    // 2. Determine the range
    int minLevel = ghostInventory.keys.reduce((a, b) => a < b ? a : b);
    int maxLevel = ghostInventory.keys.reduce((a, b) => a > b ? a : b);

    // 3. Sweep Upward
    // We use a separate variable for 'carriedPotential' so we don't
    // overwrite the physical items in the current stage.
    int carriedPotential = 0;

    for (int lvl = minLevel; lvl <= maxLevel || carriedPotential > 0; lvl++) {
      // Current physical items + what came from merges below
      int totalAvailableAtLevel = (ghostInventory[lvl] ?? 0) + carriedPotential;

      int producedNextLevel = 0;

      // Calculate production for the next stage
      if (totalAvailableAtLevel >= 5) {
        int setsOfFive = totalAvailableAtLevel ~/ 5;
        producedNextLevel = setsOfFive * 2;
      }

      if (!merge5Only) {
        // In hybrid mode, calculate how many extra items come from remaining 3-merges
        int remainderAfterFive = totalAvailableAtLevel % 5;
        if (remainderAfterFive >= 3) {
          producedNextLevel += 1;
        }
      }

      // UPDATE: We store the "Ghost" total at this level
      // (Physical + Merged Upwards)
      if (totalAvailableAtLevel > 0) {
        ghostInventory[lvl] = totalAvailableAtLevel;
      }

      // Carry the production forward to the next loop iteration
      carriedPotential = producedNextLevel;

      // Update maxLevel if we've pushed into new stages
      if (carriedPotential > 0 && lvl >= maxLevel) {
        maxLevel = lvl + 1;
      }
    }

    return ghostInventory;
  }

  static String stageName(String? chainId,int stage){
    Map? data=chainItems[chainId??0]?.firstWhere((element) => element['stage']==stage,orElse: () => {'name':"Stage $stage"},);
    String title=data?['name']??'Stage $stage';
    // print(isWildlife);
    if (chainId=='Wildlife') {
      if (stage == 45) {
        title = "Magnificent Eggs";
      } else  if(stage==0){
        title = "Eggs";
      }
    }
  return title;
  }
}
