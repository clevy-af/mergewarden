import 'package:mergewarden/model/item_id.dart';
import 'package:mergewarden/view/ledger/tile_format.dart';


enum Descriptor{
  mustHave,///best for smooth gameplay/ resources, etc
  goodToHave,///makes gameplay smooth/ harvesting easy/ tasks done quicker, etc
  decoration,/// finally decoration pieces
  premium, /// only available for gems/ cash
}

class MergeItem {
  final String name;
  final int stage;
  final int? sellValue;
  final int? gemPrice;
  final int? puzzleCoins;
  final int? capacity;
  final int? spawnCount;
  final int? harvestLimit;
  final int? tapCount;
  final int? tapLimit;
  final int? resourceValue;
  final int? upgradeValue;
  final int? globeValue;
  final int? growingTime;
  final ID id;
  final ID? growsInto;
  final String description;
  final String? goodFor;
  final List<Descriptor> descriptors;
  final List<String> helpfulTips;
  final List<String> notes;
  final List<ID> sourced;
  final List<ID> mergingRewards;
  final List<ID> spawnedItems;
  final List<ID> tapRewards;
  final List<ID> harvestRewards;
  final List<ID> daisyQuests;
  final bool richardTrade;
  final bool vanishOnHarvest;
  final bool vanishAfterSpawn;
  final bool dailyChecklist;
  final TileFormat format;

  MergeItem({
    required this.name, required this.stage, required this.description,
    required this.descriptors, required this.sourced, required this.daisyQuests,
    required this.richardTrade, required this.dailyChecklist, required this.sellValue,
    required this.gemPrice, required this.helpfulTips, required this.harvestRewards,
    this.mergingRewards=const[], required this.spawnedItems, required this.tapRewards,
    this.resourceValue, this.upgradeValue,  this.capacity,
    this.spawnCount, this.harvestLimit, this.tapCount, required this.notes, required this.vanishOnHarvest,
    this.tapLimit, required this.vanishAfterSpawn, required this.format, this.growingTime, this.growsInto, required this.id, this.globeValue, this.puzzleCoins,  this.goodFor,
  });

  bool get isHarvestable =>harvestRewards.isNotEmpty;
  bool get needsSpace =>spawnedItems.isNotEmpty;
  bool get tappable =>tapRewards.isNotEmpty;
  bool get sellable =>sellValue!=null;
  List<ID> get rewards =>spawnedItems+tapRewards+harvestRewards+mergingRewards;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "stage": stage,
      "sellValue": sellValue,
      "goodFor": goodFor,
      "gemPrice": gemPrice,
      "puzzleCoins": puzzleCoins,
      "capacity": capacity,
      "spawnCount": spawnCount,
      "harvestLimit": harvestLimit,
      "tapCount": tapCount,
      "tapLimit": tapLimit,
      "resourceValue": resourceValue,
      "upgradeValue": upgradeValue,
      "globeValue": globeValue,
      "growingTime": growingTime,
      "id": id,
      "growsInto": growsInto,
      "description": description,
      "descriptors": (descriptors.map((e) => e.index,)),
      "helpfulTips": (helpfulTips),
      "notes": (notes),
      "sourced": (sourced),
      "mergingRewards": (mergingRewards),
      "spawnedItems": (spawnedItems),
      "tapRewards": (tapRewards),
      "harvestRewards": (harvestRewards),
      "daisyQuests": (daisyQuests),
      "richardTrade": richardTrade,
      "vanishOnHarvest": vanishOnHarvest,
      "vanishAfterSpawn": vanishAfterSpawn,
      "dailyChecklist": dailyChecklist,
      "format": format.toJson(),
    };
  }

  factory MergeItem.fromJson(Map<String, dynamic> json) {
    return MergeItem(name: json["name"],
      stage: int.parse(json["stage"]),
      sellValue: int.tryParse(json["sellValue"]),
      gemPrice: int.tryParse(json["gemPrice"]),
      puzzleCoins: int.tryParse(json["puzzleCoins"]),
      capacity: int.tryParse(json["capacity"]),
      spawnCount: int.tryParse(json["spawnCount"]),
      harvestLimit: int.tryParse(json["harvestLimit"]),
      tapCount: int.tryParse(json["tapCount"]),
      tapLimit: int.tryParse(json["tapLimit"]),
      resourceValue: int.tryParse(json["resourceValue"]),
      upgradeValue: int.tryParse(json["upgradeValue"]),
      globeValue: int.tryParse(json["globeValue"]),
      growingTime: int.tryParse(json["growingTime"]),
      id: ID(json["id"]),
      growsInto: ID(json["growsInto"]),
      description: json["description"],
      descriptors: List.of(json["descriptors"]).map((i) => Descriptor.values.elementAt(i)).toList(),
      helpfulTips: List.of(json["helpfulTips"]).map((i) => i.toString()).toList(),
      notes: List.of(json["notes"]).map((i) => i.toString()).toList(),
      sourced: List.of(json["sourced"]).map((i) => ID(i) ).toList(),
      mergingRewards: List.of(json["mergingRewards"]).map((i) => ID(i) ).toList(),
      spawnedItems: List.of(json["spawnedItems"]).map((i) =>ID(i) ).toList(),
      tapRewards: List.of(json["tapRewards"]).map((i) =>ID(i) ).toList(),
      harvestRewards: List.of(json["harvestRewards"]).map((i) =>ID(i) ).toList(),
      daisyQuests: List.of(json["daisyQuests"]).map((i) =>ID(i) ).toList(),
      richardTrade: json["richardTrade"],
      goodFor: json["goodFor"],
      vanishOnHarvest: json["vanishOnHarvest"],
      vanishAfterSpawn: json["vanishAfterSpawn"],
      dailyChecklist: json["dailyChecklist"],
      format: TileFormat.fromJson(json["format"]),);
  }

}

class MergeChain {
  final String title;
  final ID id;
  final String subtitle;
  final String? proChoice;

  ///number if masterpiece, null if not.
  final int? masterpiece;
  final List<MergeItem> items;
  final List<String> notes;

  MergeChain({
    required this.title,
    required this.subtitle,
    required this.items, this.masterpiece, required this.id, required this.notes, this.proChoice,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "id": id,
      "subtitle": subtitle,
      "notes": notes,
      "totalStages": totalStages,
      "masterpiece": masterpiece,
      "proChoice": proChoice,
      "items": items.map((e) => e.toJson(),).toList(),
    };
  }

  Set<Descriptor> get tags=>items.expand((item) => item.descriptors).toSet();
  int get totalStages => items.length;

  Set<ID> get sources=>items.expand((item) => item.sourced).toSet();

  Iterable<MergeItem> get produceEggs=>items.where((item) => item.rewards.where((e)=>e.value.endsWith('0')).isNotEmpty);
  List<ID> get eggRewards {
    List<ID> ids=[];
    for(MergeItem x in items){
      for(ID y in x.rewards){
        if(y.value.contains('0') && !ids.contains(y)) {
          ids.add(y);
        }
      }
    }
    return ids;
  }
  Iterable<MergeItem> get daisyChecked=>items.where((item) => item.dailyChecklist);
  Iterable<MergeItem> get richardTrades=>items.where((item) => item.richardTrade);

  bool get mergeable=>items.firstOrNull?.upgradeValue==null;

  factory MergeChain.fromJson(Map<String, dynamic> json) {
    return MergeChain(
      id: ID(json['id']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      masterpiece: json['masterpiece'] as int?,
      items: (json['items'] as List).map((e) => MergeItem.fromJson(e as Map<String, dynamic>)).toList(), notes: [],
    );
  }

  @override
  String toString() => (toJson).toString();
}


