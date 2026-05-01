import 'package:flutter/material.dart';
import 'dart:convert';

// --- MODELS ---

class Reward {
  final String item;
  final int quantity;
  final String? type; // 'currency', 'item', 'creature'

  Reward({required this.item, required this.quantity, this.type});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      item: json['item'],
      quantity: json['quantity'],
      type: json['type'],
    );
  }
}

class GameItem {
  final String id;
  final String name;
  final int level;
  final String category;
  final int sellPrice;
  final int? skipGems;
  final String description;
  final List<String> obtainedFrom;

  GameItem({
    required this.id, required this.name, required this.level,
    required this.category, required this.sellPrice, this.skipGems,
    required this.description, required this.obtainedFrom,
  });

  factory GameItem.fromJson(Map<String, dynamic> json) => GameItem(
    id: json['id'], name: json['name'], level: json['level'],
    category: json['category'], sellPrice: json['sellPrice'],
    skipGems: json['skipGems'], description: json['description'],
    obtainedFrom: List<String>.from(json['obtainedFrom']),
  );
}

class SourceNode {
  final String name;
  final String description;
  final List<String> potentialDrops;

  SourceNode({required this.name, required this.description, required this.potentialDrops});
}

class QuestTask {
  final String id;
  final String title;
  final String objective;
  final String targetItemId;
  final int levelNumber;
  final List<Reward> rewards;

  QuestTask({
    required this.id,
    required this.title,
    required this.objective,
    required this.targetItemId,
    required this.levelNumber,
    required this.rewards
  });

  factory QuestTask.fromJson(Map<String, dynamic> json, int level) => QuestTask(
    id: json['id'],
    title: json['title'],
    objective: json['objective'],
    targetItemId: json['targetItemId'],
    levelNumber: level,
    rewards: (json['rewards'] as List).map((r) => Reward.fromJson(r)).toList(),
  );
}

class GardenLevel {
  final int levelNumber;
  final List<QuestTask> tasks;
  final List<Reward> levelRewards;

  GardenLevel({required this.levelNumber, required this.tasks, required this.levelRewards});

  factory GardenLevel.fromJson(Map<String, dynamic> json) {
    int lvl = json['level'];
    return GardenLevel(
      levelNumber: lvl,
      tasks: (json['tasks'] as List).map((t) => QuestTask.fromJson(t, lvl)).toList(),
      levelRewards: (json['levelRewards'] as List).map((r) => Reward.fromJson(r)).toList(),
    );
  }
}

// --- MOCK DATABASE ---

const String itemDataJson = '''
[
  {"id": "oak_seedling", "name": "Oak Seedling", "level": 1, "category": "Trees", "sellPrice": 1, "skipGems": 5, "description": "Start of the Oak chain.", "obtainedFrom": ["Dead Logs", "Woodland Chests"]},
  {"id": "ancient_oak", "name": "Ancient Oak", "level": 8, "category": "Trees", "sellPrice": 1000, "skipGems": 150, "description": "A grand tree.", "obtainedFrom": ["Merge Lvl 7"]}
]
''';

const String levelDataJson = '''
[
  {
    "level": 1,
    "tasks": [
      {
        "id": "t1",
        "title": "Clear the Patch",
        "objective": "Merge 3 Oak Seedlings",
        "targetItemId": "oak_seedling",
        "rewards": [{"item": "Coins", "quantity": 50, "type": "currency"}]
      }
    ],
    "levelRewards": [
      {"item": "Garden Expansion", "quantity": 1},
      {"item": "Gems", "quantity": 5, "type": "currency"}
    ]
  },
  {
    "level": 2,
    "tasks": [
      {
        "id": "t2",
        "title": "Green Thumb",
        "objective": "Harvest 5 Daisy Seeds",
        "targetItemId": "oak_seedling",
        "rewards": [{"item": "Coins", "quantity": 75, "type": "currency"}]
      }
    ],
    "levelRewards": [{"item": "Nectar", "quantity": 10}]
  }
]
''';

// Global mock for source details
final Map<String, SourceNode> sourceDetails = {
  "Dead Logs": SourceNode(
      name: "Dead Logs",
      description: "Commonly found when clearing dark fog. Can be tapped for Oak Seedlings or harvested by creatures.",
      potentialDrops: ["Oak Seedling", "Wood Shavings", "Mushrooms"]
  ),
  "Woodland Chests": SourceNode(
      name: "Woodland Chests",
      description: "Occasional rewards from merging forest items or completing events.",
      potentialDrops: ["Oak Seedling", "Acorns", "Garden Gnome"]
  ),
};

void main() => runApp(const MergeGardensPortal());

class MergeGardensPortal extends StatelessWidget {
  const MergeGardensPortal({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1B4332),
        scaffoldBackgroundColor: const Color(0xFF081C15),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF2D6A4F), secondary: Color(0xFF95D5B2)),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<GardenLevel> allLevels = [];
  List<GameItem> allItems = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    allItems = (json.decode(itemDataJson) as List).map((i) => GameItem.fromJson(i)).toList();
    allLevels = (json.decode(levelDataJson) as List).map((l) => GardenLevel.fromJson(l)).toList();
  }

  void _showLevelDetails(BuildContext context, int levelNumber) {
    final levelData = allLevels.firstWhere((l) => l.levelNumber == levelNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4332),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Level $levelNumber Rewards", style: const TextStyle(color: Color(0xFF95D5B2))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Tasks: ${levelData.tasks.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("On Level Completion:", style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            ...levelData.levelRewards.map((r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard, size: 16, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text("${r.quantity}x ${r.item}"),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Color(0xFF95D5B2))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<QuestTask> flattenedQuests = allLevels.expand((l) => l.tasks).toList();

    List<QuestTask> filteredQuests = flattenedQuests.where((task) {
      final query = searchQuery.toLowerCase();
      final matchesText = task.title.toLowerCase().contains(query) ||
          task.objective.toLowerCase().contains(query);
      final matchesLevel = task.levelNumber.toString() == query;
      return matchesText || matchesLevel;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Garden Quests"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search by task text or Level #",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF95D5B2)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredQuests.length,
              itemBuilder: (context, index) {
                final task = filteredQuests[index];
                bool showDivider = index == 0 || filteredQuests[index - 1].levelNumber != task.levelNumber;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDivider) ...[
                      InkWell(
                        onTap: () => _showLevelDetails(context, task.levelNumber),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
                          child: Row(
                            children: [
                              Text(
                                "LEVEL ${task.levelNumber}",
                                style: const TextStyle(
                                  color: Color(0xFF95D5B2),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.info_outline, size: 14, color: Color(0xFF95D5B2)),
                              const SizedBox(width: 8),
                              const Expanded(child: Divider(color: Colors.white10)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.objective),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          final item = allItems.firstWhere(
                                  (i) => i.id == task.targetItemId,
                              orElse: () => allItems.first
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item, task: task))
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final GameItem item;
  final QuestTask task;
  const ItemDetailScreen({super.key, required this.item, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.eco, size: 80, color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(height: 24),
            Text("Task: ${task.title}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(task.objective, style: const TextStyle(color: Colors.white70)),
            const Divider(height: 40),
            _buildSectionTitle("Task Rewards"),
            ...task.rewards.map((r) => ListTile(
              leading: const Icon(Icons.redeem, size: 20, color: Colors.amber),
              title: Text("${r.quantity}x ${r.item}"),
              dense: true,
            )),
            const Divider(height: 40),
            _buildSectionTitle("Item Details"),
            Text("Sell: 🪙 ${item.sellPrice} | Skip: 💎 ${item.skipGems ?? 'N/A'}"),
            const SizedBox(height: 24),
            _buildSectionTitle("Obtained Via"),
            const Text("Select a source to see more info:", style: TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: item.obtainedFrom.map((source) {
                return ActionChip(
                  label: Text(source, style: const TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFF2D6A4F),
                  avatar: const Icon(Icons.search, size: 16, color: Colors.white70),
                  onPressed: () {
                    final node = sourceDetails[source] ?? SourceNode(
                        name: source,
                        description: "No specific details available for this source yet.",
                        potentialDrops: []
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SourceDetailScreen(node: node))
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF95D5B2))),
  );
}

class SourceDetailScreen extends StatelessWidget {
  final SourceNode node;
  const SourceDetailScreen({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(node.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, size: 64, color: Color(0xFF95D5B2)),
            const SizedBox(height: 24),
            Text(node.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(node.description, style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5)),
            const Divider(height: 48),
            const Text("Potential Drops", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF95D5B2))),
            const SizedBox(height: 16),
            if (node.potentialDrops.isEmpty)
              const Text("Unknown drops.", style: TextStyle(fontStyle: FontStyle.italic))
            else
              ...node.potentialDrops.map((drop) => ListTile(
                leading: const Icon(Icons.circle, size: 8, color: Colors.white24),
                title: Text(drop),
                dense: true,
              )),
          ],
        ),
      ),
    );
  }
}