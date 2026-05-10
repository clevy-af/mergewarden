import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';

class GoalData {
  final TargetItem targetItem;
  final int potions;
  final String uid;
  final int createdAt;
  List<Inventory> inventory;

  GoalData( {required this.targetItem, required this.inventory,this.potions=0,required this.createdAt, required this.uid});
  factory GoalData.fromJson(Map json) => GoalData(
    uid:json['uid'],
    inventory: (json['inventory'] as List).map((e) => Inventory.fromJson(e)).toList(),
    targetItem: TargetItem.fromJson(json['targetItem']),
    potions: json['potions'],
      createdAt: json['createdAt']
  );
  Map<String, dynamic> toJson() => {
    "inventory": inventory.map((e) => e.toJson()).toList()..sort((a, b) =>targetItem.isWildlife?b['stage'].toString().compareTo(a['stage'].toString()): b['stage'].compareTo(a['stage']),),
    "targetItem": targetItem.toJson(),
    "potions": potions,
    "uid": uid,
    "createdAt": createdAt,
  };
  double get progress {
    double progress=0;
    for(int i=0;i<inventory.length;i++) {
      if(inventory[i].have==inventory[i].count) {
        progress=100.0*inventory.length;break;
      }
      else {
        progress+=(inventory[i].have/inventory[i].count)*100;
      }
    }
    return progress/inventory.length;
}

Map<int,int> inventoryMap(){
    Map<int ,int> data={};
    final x=inventory.where((element) => element.have>0,).map((e) => {e.stage:e.have},);
    for (var element in x) {
      data.putIfAbsent(element.keys.first,()=>element.values.last);
    }
    return data;
}
List<Inventory> get inventorySorted{
      final x= inventory;
      x.sort((a, b) => (a.have==a.count?1:0),);
  return x;
}

@override
  String toString() => toJson().toString();

}