class TargetItem {
  final String? chainId;
  final String? stageName;
  final String? url;
  final int stage;
  final int count;
  final bool merge5;
  final bool has0;
  final bool isWildlife;

  TargetItem( {
    this.chainId, this.stageName, this.url,required this.merge5, required this.has0,
    required this.count,required this.stage,required this.isWildlife,
  });
  Map<String, dynamic> toJson() => {
    "chain": chainId,
    "name": stageName,
    "url": url,
    "stage": stage,
    "count": count,
    "merge5": merge5,
    "isWildlife": isWildlife,
    "has0": has0,
  };
  factory TargetItem.fromJson(Map json) => TargetItem(
    chainId: json["chain"],
    merge5: json["merge5"],
    has0: json["has0"],
    stageName: json["name"],
    url: json["url"],
    stage: json["stage"],
    isWildlife: json["isWildlife"],
    count: json["count"],
  );
}
