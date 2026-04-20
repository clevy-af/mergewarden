
class Breakup {
  final int stage;
  final int count;
  final int potions;
  final int mergeBy5;
  final int mergeBy3;
  final int surplus;
  Breakup( {required this.stage,required this.mergeBy3,required this.mergeBy5, this.count=0, this.potions=0, this.surplus=0});
  Map<String, dynamic> toJson() => {
    "stage": stage,
    "count": count,
    "surplus": surplus,
    "potions": potions,
    "mergeBy5": mergeBy5,
    "mergeBy3": mergeBy3,

  };
  factory Breakup.fromJson(Map json) => Breakup(
    stage: json["stage"]??0,
    count: json["count"]??0,
    surplus: json["surplus"]??0,
    potions: json["potions"]??0,
    mergeBy3: json["mergeBy3"]??0,
    mergeBy5: json["mergeBy5"]??0,
  );
  @override
  String toString() => toJson().toString();
}

class Inventory extends Breakup {
  final int have;
  final int havePotions;


  Inventory( {required super.stage, required super.count,this.havePotions=0,  required super.potions, this.have=0, required super.mergeBy3, required super.mergeBy5,required super.surplus});

  factory Inventory.fromJson(Map json) => Inventory(
    stage: json["stage"]??0,
    count: json["count"]??0,
    potions: json["potions"]??0,
    havePotions: json["havePotions"]??0,
    have: json["have"]??0,
    mergeBy3: json["mergeBy3"]??0,
    mergeBy5: json["mergeBy5"]??0,
      surplus: json["surplus"]??0,
  );

  @override
  Map<String, dynamic> toJson() => {
    'have':have,
    'havePotions':havePotions,
    ...super.toJson()
  };


  @override
  String toString() => toJson().toString();
}