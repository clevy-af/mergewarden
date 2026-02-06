class ChainMeta {
  final String name;
  final String id;
  final int stages;
  final bool masterpiece;
  ChainMeta({required this.name,required this.id,required this.stages,this.masterpiece=false, });
  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "stages": stages,
    "masterpiece": masterpiece,
  };
  factory ChainMeta.fromJson(Map<String, dynamic> json) => ChainMeta(
    name: json["name"],
    id: json["id"],
    stages: json["stages"],
    masterpiece: json["masterpiece"],
  );
}

class ChainStageMeta {
  final String name;
  final String? url;
  final int stage;

  ChainStageMeta({required this.name, this.url,required this.stage,});
  Map<String, dynamic> toJson() => {
    "name": name,
    "id": url,
    "stage": stage,
  };
  factory ChainStageMeta.fromJson(Map<String, dynamic> json) => ChainStageMeta(
    name: json["name"],
    url: json["url"],
    stage: json["stage"],
  );
}