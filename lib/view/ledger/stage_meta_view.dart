import 'package:flutter/material.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/view/components/stat_card.dart';

// --- STYLES ---
const Color kCardBg = Colors.white;
const Color kTextDark = Color(0xFF2D3436);
const Color kTextSubtle = Colors.black54;
const Color kAccentGreen = Color(0xFF2D6A4F);
const Color kSurfaceBg = Color(0xFFF9F9F9);

class ItemDetailView extends StatelessWidget {
  final MergeItem itemData;
  final String chainName;
  final VoidCallback onBack;

  const ItemDetailView({
    super.key,
    required this.itemData,
    required this.onBack, required this.chainName,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: cFillBackground,
          borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(15),
            topRight:  Radius.circular(15),
          )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildWhereToFind(),
                      const SizedBox(height: 24),
                      _buildHarvestableRewards(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNextStageCard(),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Start Merging",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large Item Image
        Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20)],
          ),
          alignment: AlignmentGeometry.center,
          child: Stack(
            children: [
              StageItemImage(heightValue: context.screenSize.shortestSide*0.4, assetName: 'Stage_${itemData.stage}_-_${itemData.name.replaceAll(' ', '_')}'),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: cCreme, borderRadius: BorderRadius.circular(8)),
                  child: Text("STAGE ${itemData.stage}", style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Item Description & Stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(itemData.name, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kTextDark)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _infoTag("RARE ITEM", Colors.orange.shade100, Colors.orange.shade900),
                  const SizedBox(width: 8),
                  _infoTag(chainName, Colors.grey.shade200, kTextSubtle),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  Card(
                    color: Colors.white,
                    // margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                        "Hand-painted with pigments extracted from rare bluebells, this vase is said to hum softly when placed near a blooming garden.",
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: kTextSubtle, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 5,
                    child: Text('“',style: TextStyle(fontSize: 20),),
                  ),
                Positioned(
                    bottom: 0,
                    right: 5,
                    child: Text('”',style: TextStyle(fontSize: 20),),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statBox("SELL VALUE", "250", "Coins"),
                  _statBox("RARITY", "Rare", "Tier 3"),
                  _statBox("REWARDS", "High", "Yield"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhereToFind() {
    return _sectionContainer(
      title: "Where to find",
      icon: Icons.edit_note,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 40, color: kAccentGreen),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("3x Traditional Pots", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Level 4 Component", style: TextStyle(fontSize: 12, color: kTextSubtle)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.black26),
                const SizedBox(width: 16),
                Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(color: kAccentGreen, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.check, color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Imari Vase is crafted by merging three Level 4 Traditional Pots. This transformation occurs as the rustic terracotta is refined and glazed with rare floral pigments.",
            style: TextStyle(color: kTextSubtle, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestableRewards() {
    return _sectionContainer(
      title: "Harvestable Rewards",
      icon: Icons.inventory_2,
      child: Row(
        children: [
          _rewardMiniPill("Petal Shard", "COMMON DROP"),
          const SizedBox(width: 12),
          _rewardMiniPill("Rare EXP", "BONUS REWARD"),
        ],
      ),
    );
  }

  Widget _buildNextStageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: kAccentGreen),
              SizedBox(width: 8),
              Text("Helpful Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                visualDensity: VisualDensity(vertical: -3),
                contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: -2),
                leading:  const Icon(Icons.play_circle_sharp, size: 15), // Custom widget or Icon
                title: Text('Your list item content'),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 5,),
              itemCount: 5,
          )
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _sectionContainer({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: kAccentGreen),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _infoTag(String label, Color bg, Color text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.bold)),
  );

  Widget _statBox(String label, String value, String sub) => Container(
    width: 100,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
    child: Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: kTextSubtle, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(sub, style: const TextStyle(fontSize: 10, color: kTextSubtle)),
      ],
    ),
  );

  Widget _rewardMiniPill(String name, String type) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Row(
        children: [
          const Icon(Icons.grain, size: 18, color: kAccentGreen),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text(type, style: const TextStyle(fontSize: 9, color: kTextSubtle)),
            ],
          ),
        ],
      ),
    ),
  );
}