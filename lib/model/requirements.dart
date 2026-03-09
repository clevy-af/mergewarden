
class Breakup {
  final int stage;
  final int count;
  final int potions;
  Breakup( {required this.stage, this.count=0, this.potions=0});
  Map<String, dynamic> toJson() => {
    "stage": stage,
    "count": count,
    "potions": potions,
  };
  factory Breakup.fromJson(Map json) => Breakup(
    stage: json["stage"]??0,
    count: json["count"]??0,
    potions: json["potions"]??0,
  );
  @override
  String toString() => toJson().toString();
}

class Inventory extends Breakup {
  final int have;
  final int havePotions;


  Inventory( {required super.stage, required super.count,this.havePotions=0,  required super.potions, this.have=0,});

  factory Inventory.fromJson(Map json) => Inventory(
    stage: json["stage"]??0,
    count: json["count"]??0,
    potions: json["potions"]??0,
    havePotions: json["havePotions"]??0,
    have: json["have"]??0,
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