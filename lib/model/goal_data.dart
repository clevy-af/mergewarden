import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';

class GoalData {
  final TargetItem targetItem;
  final int potions;
  final int createdAt;
  final List<Inventory> inventory;

  GoalData( {required this.targetItem, required this.inventory,this.potions=0,required this.createdAt});
  factory GoalData.fromJson(Map json) => GoalData(
    inventory: (json['inventory'] as List).map((e) => Inventory.fromJson(e)).toList(),
    targetItem: TargetItem.fromJson(json['targetItem']),
    potions: json['potions'],
      createdAt: json['createdAt']
  );
  Map<String, dynamic> toJson() => {
    "inventory": inventory.map((e) => e.toJson()).toList(),
    "targetItem": targetItem.toJson(),
    "potions": potions,
    "createdAt": createdAt,
  };
  double get progress {
    double progress=0;
    for(int i=0;i<inventory.length;i++) {
      progress+=(inventory[i].have/inventory[i].count)*100;
    }
    return progress/inventory.length;
}

}