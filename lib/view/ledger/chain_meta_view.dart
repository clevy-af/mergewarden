import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/mg_models.dart';
import 'package:mergewarden/view/components/stat_card.dart';



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
    Widget backButton = Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton.icon(
                            onPressed:onBack,
                            icon: const Icon(Icons.arrow_back_rounded, size: 14),
                            label: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2235),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        );
    return DecoratedBox(
      decoration: BoxDecoration(
          color: cFillBackground,
          borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(15),
            topRight:  Radius.circular(15),
          )),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, top: 16, bottom: 16,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 8),
                      _buildOverviewRow(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                if(chainData.richardTrades.isNotEmpty||chainData.produceEggs.isNotEmpty)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        backButton,
                        if(chainData.richardTrades.isNotEmpty)
                          _sourcePill(chainData.richardTrades,"Richard Trades:"),//"Daily Checklist:"
                        // _rewardRow("Daisy's Level Quests:", "75, 80, 88, 90"),
                        if(chainData.richardTrades.isNotEmpty)
                          const SizedBox(height: 12),
                        if(chainData.produceEggs.isNotEmpty)
                          _sourcePill(chainData.produceEggs,"Gives Eggs:"),// Often | Never
                        if(chainData.produceEggs.isNotEmpty)
                          const SizedBox(height: 12),
                        // _sourcePill(chainData.,"Daily Checklist:", "Never"),// Often | Never
                        // const SizedBox(height: 12),

                      ],
                    ),
                  )
                else backButton,
              ],
            ),

            _buildStagesSection(),
            const SizedBox(height: 22),
            if(chainData.masterpiece!=null)
            _buildMasterpieceSpotlight(context),
            if(chainData.masterpiece!=null)
            const SizedBox(height: 12),
            // const SizedBox(height: 32),
            // _buildCalculatorCta(),
          ],
        ),
      ),
    );
  }

  // Header with Breadcrumb-style title
  Widget _buildHeader(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(chainData.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextDark)),
        Text(chainData.subtitle, style: TextStyle(color: kTextSubtle)),
        SizedBox(height: 8,),
        Flexible(
          child: Row(
            children: List.generate(chainData.tags.length, (index) => DescriptorLabel(descriptor: chainData.tags.elementAt(index)),),
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
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(chainData.sources.isNotEmpty)
                const Text("Getting Started", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if(chainData.sources.isNotEmpty)
              const SizedBox(height: 8),
              if(chainData.sources.isNotEmpty)
              Wrap(
                 spacing: 8,
                runSpacing: 8,
                children: List.generate(chainData.sources.length, (index) =>  ActionChip(
                    label: Text(chainData.sources.elementAt(index).value.split(':').last.replaceAll('-', ' ')),
                  onPressed: () {

                  },
                ),
                ),
              ),
              if(chainData.sources.isNotEmpty)
                const SizedBox(height: 12),
              if(chainData.notes.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text.rich(TextSpan(
                      children: List.generate(chainData.notes.length, (index) => TextSpan(text:"⦿ ${chainData.notes[index]}\n" ),)
                  ), style: TextStyle(color: kTextSubtle, height: 1.5)),
                  const SizedBox(height: 16),
                ],

              ),
            ],
          ),
        ),
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
                    _statPill("SELL VALUE",( chainData.items.last.sellValue??0).toString()),
                    const SizedBox(width: 12),
                    _statPill("MERGE BONUS", chainData.items.last.mergingRewards.toString()),//.replaceAll(RegExp(r'[\[\]]'), ''),
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
  Widget _sourcePill( Iterable<MergeItem> value,String label) {
    // IconData icon =value?Icons.check_circle_outline:Icons.cancel_outlined;
    return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
    child: Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Wrap(
          children: List.generate(value.length, (index) => StageItemImage(
              assetName: 'Stage_${value.elementAt(index).stage}_-_${value.elementAt(index).name.replaceAll(' ', '_')}',
          heightValue: kMinInteractiveDimension,),
          ),
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

  Widget _statPill(String label, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: kTextSubtle, fontWeight: FontWeight.bold)),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  // Widget _buildCalculatorCta() {
  //   String plural = chainData.items.firstWhere((
  //           element) => element.stage==1,
  //           orElse:() => chainData.items.first
  //       ).name.split(' ').last.toLowerCase();
  //   if(!plural.endsWith('s')){
  //     plural+='s';
  //   }
  //   return Container(
  //   padding: const EdgeInsets.all(16),
  //   decoration: BoxDecoration(color: const Color(0xFFFDECE8), borderRadius: BorderRadius.circular(16)),
  //   child: Row(
  //     children: [
  //       const Icon(Icons.calculate, color: Color(0xFF8B4513)),
  //       const SizedBox(width: 16),
  //       Expanded(child: Text("${chainData.title} Calculator: Exactly how many $plural you need.",
  //           style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B4513)))),
  //       ElevatedButton(
  //         onPressed: () async {
  //
  //           await HiveProvider.appBox.put('chain', chainData.id);
  //           await HiveProvider.appBox.put('type', 'items');
  //
  //         },
  //         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513), foregroundColor: Colors.white),
  //         child: const Text("Open Calculator"),
  //       )
  //     ],
  //   ),
  // );
  // }
}
Map<Descriptor,String> descriptorLabels={
  Descriptor.goodToHave:'🛠️ Good to Have',
  Descriptor.mustHave:'📌 Must Have',
  Descriptor.decoration:'🎀 Decoration',
  Descriptor.premium:'👑 Premium',
};

class DescriptorLabel extends StatelessWidget {
  const DescriptorLabel({
    super.key,
    required this.descriptor,
  });

  final Descriptor descriptor;

  @override
  Widget build(BuildContext context) {

    return Card(
      color: cCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
      margin: EdgeInsets.all(3),
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
        child: Text(descriptorLabels[descriptor].toString(),style: TextStyle(color: Colors.white),),
      ),
    );
  }
}