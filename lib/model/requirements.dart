class Requirements {
  final int count;
  final int merge5s;
  final int merge3s;

  Requirements({required this.merge5s, required this.merge3s,
    required this.count,
  });
  Map<String, dynamic> toJson() => {
    "count": count,
    "merge5s": merge5s,
    "merge3s": merge3s,
  };
  factory Requirements.fromJson(Map<String, dynamic> json) => Requirements(
    count: json["count"],
    merge5s: json["merge5s"],
    merge3s: json["merge3s"],
  );
}


class Breakup {
  final int stage;
  final int count;
  final int potionsUsed;
  Breakup( {required this.stage, required this.count, required this.potionsUsed});
}