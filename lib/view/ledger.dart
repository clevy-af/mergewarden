import 'package:flutter/material.dart';

// --- MODELS ---

class ChainItem {
  final int level;
  final String name;
  final String? imageUrl; // Placeholder for actual asset paths

  ChainItem({required this.level, required this.name, this.imageUrl});
}

class ItemChain {
  final String name;
  final String category;
  final List<ChainItem> items;
  final String description;

  ItemChain({
    required this.name,
    required this.category,
    required this.items,
    required this.description,
  });
}

// --- MOCK DATA ---

final List<ItemChain> mockChains = [
  ItemChain(
    name: "Ancient Oaks",
    category: "Trees",
    description: "The primary source of wood and bird nests.",
    items: [
      ChainItem(level: 1, name: "Oak Seedling"),
      ChainItem(level: 2, name: "Oak Sapling"),
      ChainItem(level: 3, name: "Young Oak"),
      ChainItem(level: 8, name: "Ancient Oak"),
    ],
  ),
  ItemChain(
    name: "Fruit Trees",
    category: "Trees",
    description: "Provides various fruits and refreshing nectar.",
    items: [
      ChainItem(level: 1, name: "Grape Seeds"),
      ChainItem(level: 5, name: "Apple Tree"),
    ],
  ),
  ItemChain(
    name: "Garden Gnomes",
    category: "Decor",
    description: "Whimsical statues found in chests.",
    items: [ChainItem(level: 1, name: "Dusty Gnome")],
  ),
];
void main() => runApp(MaterialApp(
    home: ChainsPage()));
// --- UI COMPONENTS ---

class ChainsPage extends StatefulWidget {
  const ChainsPage({super.key});

  @override
  State<ChainsPage> createState() => _ChainsPageState();
}

class _ChainsPageState extends State<ChainsPage> {
  String _searchQuery = "";
  String? _selectedAlpha;
  ItemChain? _selectedChain;

  final List<String> _alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));

  @override
  Widget build(BuildContext context) {
    // Filter logic
    List<ItemChain> filteredChains = mockChains.where((chain) {
      final matchesSearch = chain.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesAlpha = _selectedAlpha == null || chain.name.startsWith(_selectedAlpha!);
      return matchesSearch && matchesAlpha;
    }).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. STICKY SEARCH BAR
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search chains...",
                    hintStyle: TextStyle(color: Colors.white38),
                    prefixIcon: Icon(Icons.search, size: 18, color: Colors.white38),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),

          // 2. ALPHABET FILTER ROW
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _alphabet.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  bool isSelected = _selectedAlpha == _alphabet[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(_alphabet[index]),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() => _selectedAlpha = val ? _alphabet[index] : null);
                      },
                      selectedColor: const Color(0xFF95D5B2),
                      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.red),
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. POPULAR / FILTERED LIST
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text("SELECT A CHAIN", style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF40916C))),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final chain = filteredChains[index];
                return ListTile(
                  title: Text(chain.name),
                  subtitle: Text(chain.category, style: const TextStyle(color: Colors.white38)),
                  trailing: const Icon(Icons.keyboard_arrow_down, size: 18),
                  onTap: () => setState(() => _selectedChain = chain),
                );
              },
              childCount: filteredChains.length,
            ),
          ),

          // 4. SELECTED CHAIN DETAIL SECTION
          if (_selectedChain != null)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF162A21),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF95D5B2).withAlpha(77)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedChain!.name.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF95D5B2))),
                        IconButton(onPressed: () => setState(() => _selectedChain = null), icon: const Icon(Icons.close, size: 18)),
                      ],
                    ),
                    Text(_selectedChain!.description, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),
                    // CHAIN GRID
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _selectedChain!.items.length,
                      itemBuilder: (context, idx) {
                        final item = _selectedChain!.items[idx];
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.eco, color: Color(0xFF40916C)),
                            ),
                            const SizedBox(height: 4),
                            Text("Lvl ${item.level}", style: const TextStyle(fontSize: 10, color: Color(0xFF95D5B2))),
                            Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}