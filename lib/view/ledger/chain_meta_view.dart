import 'package:flutter/material.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';

// --- STYLES ---
const Color kCardBg = Colors.white;
const Color kTextDark = Color(0xFF2D3436);
const Color kTextSubtle = Colors.black54;
const Color kAccentGreen = Color(0xFF2D6A4F);
const Color kSurfaceBg = Color(0xFFF9F9F9);

class ChainDetailView extends StatelessWidget {
  final MergeChain chainData;
  final VoidCallback onBack;
  final Function(int) onTapStage;

  const ChainDetailView({
    super.key,
    required this.chainData,
    required this.onBack, required this.onTapStage,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildOverviewRow(),
            const SizedBox(height: 32),
            _buildStagesSection(),
            const SizedBox(height: 32),
            if(chainData.masterpiece!=null)
            _buildMasterpieceSpotlight(context),
            const SizedBox(height: 12),
            // const SizedBox(height: 32),
            // _buildCalculatorCta(),
          ],
        ),
      ),
    );
  }

  // Header with Breadcrumb-style title
  Widget _buildHeader() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(chainData.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextDark)),
        const Text("A beautiful collection of ceramic vessels used for holding flora.", style: TextStyle(color: kTextSubtle)),
        SizedBox(height: 8,),
        Flexible(
          child: Row(
            children: List.generate(chainData.tags.length, (index) => ChainLabel(label: chainData.tags.elementAt(index).name),),
            // [
            //   ChainLabel(label: '📌 Must Have'),
            //   ChainLabel(label:'🛠️ Good to Have'),
            //   ChainLabel(label:'🎀 Decoration'),
            //   // ChainLabel(label:'🪹 Spawner'),
            //   ChainLabel(label:'👑 Premium'),
            // ],
          ),
        ),
      ],
    );
  }

  // "Getting Started" and "Rewards" side-by-side
  Widget _buildOverviewRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Getting Started", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Vases are primarily obtained through Ancient Ruins or Garden Chests.", style: TextStyle(color: kTextSubtle, height: 1.5)),
              const SizedBox(height: 16),
              Row(
                children: [
                  // _sourcePill(chainData.sources.length>1?Icons.looks_one, "Primary Source", "Ancient Ruins"),
                  const SizedBox(width: 12),
                  // _sourcePill(Icons.inventory, "Harvest Rewards", "Standard Chests"),
                ],
              )
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF43534C), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                _rewardRow("Daisy's Level Quests:", "75, 80, 88, 90"),
                const SizedBox(height: 12),
                _sourcePill(chainData.produceEggs,"Produce Eggs:", "Sometimes"),// Often | Never
                const SizedBox(height: 12),
                // _sourcePill(chainData.,"Daily Checklist:", "Never"),// Often | Never
                // const SizedBox(height: 12),

                ],
            ),
          ),
        )
      ],
    );
  }

  // Horizontal Stages Scroller
  Widget _buildStagesSection() {
    List<MergeItem> stages=chainData.items;
    ScrollController scrollController=ScrollController();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Chain Stages (${chainData.totalStages})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Row(
            //   children: [
            //     TextButton(onPressed: () {}, child: const Text("List View", style: TextStyle(color: kTextSubtle))),
            //     const Text("|", style: TextStyle(color: Colors.black12)),
            //     TextButton(onPressed: () {}, child: const Text("Grid View", style: TextStyle(color: kAccentGreen))),
            //   ],
            // )
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: Scrollbar(
            trackVisibility: true,
            controller: scrollController,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stages.length,
              controller: scrollController,
              separatorBuilder: (_, __) => Padding(padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_forward_ios, size: 12, color: cCreme),
              ),
              itemBuilder: (context, index) => _stageCard(index ,stages[index]),
            ),
          ),
        ),
      ],
    );
  }

  // Masterpiece Spotlight (Imperial Jar)
  Widget _buildMasterpieceSpotlight(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFE8EAE6), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Expanded(child: StageItemImage(
            assetName: 'Stage_${chainData.items.last.stage}_-_${chainData.items.last.name.replaceAll(' ', '_')}',
           heightValue: context.screenSize.height*0.2, ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("# Masterpiece ${chainData.masterpiece}", style: TextStyle(letterSpacing: 1.2, fontSize: 10, fontWeight: FontWeight.bold, color: kTextSubtle)),
                const SizedBox(height: 4),
                 Text("${chainData.items.last.name} (Stage ${chainData.items.last.stage})", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                 Text(chainData.items.last.description, style: TextStyle(color: kTextSubtle, height: 1.4)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _statPill("SELL VALUE", chainData.items.last.sellValue??0),
                    const SizedBox(width: 12),
                    _statPill("MERGE BONUS", 2),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // UI Helpers
  Widget _rewardRow(String label, String value) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ],
  );

  Widget _sourcePill( bool value,String label, String sub) {
    IconData icon =value?Icons.check_circle_outline:Icons.cancel_outlined;
    return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
    child: Row(
      children: [
        Icon(icon, size: 20, color: kAccentGreen),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: kTextSubtle)),
            Text(sub, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    ),
  );
  }

  Widget _stageCard(int level,MergeItem data) => InkWell(
    onTap: () => onTapStage(level),
    child: Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StageItemImage(heightValue: kMinInteractiveDimension*2.5, assetName:'Stage_${data.stage}_-_${data.name.replaceAll(' ', '_')}'),
          const SizedBox(height: 8),
          Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),maxLines: 2,textAlign: TextAlign.center,),
          Text("Stage ${data.stage}", style: const TextStyle( fontSize: 14)),
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text("2", style: TextStyle(fontSize: 12, color: kTextSubtle)),
          //     Icon(Icons.arrow_forward_ios, size: 12, color: kTextSubtle),
          //   ],
          // )
        ],
      ),
    ),
  );

  Widget _statPill(String label, int? val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: kTextSubtle, fontWeight: FontWeight.bold)),
        Text(val.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _buildCalculatorCta() {
    String plural = chainData.items.firstWhere((
            element) => element.stage==1,
            orElse:() => chainData.items.first
        ).name.split(' ').last.toLowerCase();
    if(!plural.endsWith('s')){
      plural+='s';
    }
    return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFFFDECE8), borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        const Icon(Icons.calculate, color: Color(0xFF8B4513)),
        const SizedBox(width: 16),
        Expanded(child: Text("${chainData.title} Calculator: Exactly how many $plural you need.",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B4513)))),
        ElevatedButton(
          onPressed: () async {

            await HiveProvider.appBox.put('chain', chainData.id);
            await HiveProvider.appBox.put('type', 'items');

          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white),
          child: const Text("Open Calculator"),
        )
      ],
    ),
  );
  }
}

class ChainLabel extends StatelessWidget {
  const ChainLabel({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cCreme,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
      margin: EdgeInsets.all(3),
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
        child: Text(label),
      ),
    );
  }
}