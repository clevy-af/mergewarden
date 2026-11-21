import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/constants.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/mg_models.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/ledger/tile_format.dart';


class StageMetaView extends StatelessWidget {
  final MergeItem itemData;
  final String chainName;
  final VoidCallback onBack;
  final Function(int)? onNextItem;

  const StageMetaView({
    super.key,
    required this.itemData,
    required this.onBack, required this.chainName, required this.onNextItem,
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
            buildRewardsAndSourcePanel(context.screenSize.width>600),
          ],
        ),
      ),
    );
  }

  Widget buildRewardsAndSourcePanel(bool isDesktop) {
    if(isDesktop) {
      return Row(
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
                child: _buildHelpfulTipsCard(),
              ),
            ],
          );
    }
    return Column(
      children: [
        _buildWhereToFind(),
        const SizedBox(height: 24),
        _buildHarvestableRewards(),
        const SizedBox(height: 24),
        _buildHelpfulTipsCard(),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    var isDesktop = context.screenSize.width>600;
    var infoColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  ActionChip(
                    label: Text(itemData.format.toText()),
                    onPressed: () => gridSizeBox(context, itemData.format),
                  ),
                  const SizedBox(width: 8),

                  _infoTag("RARE ITEM", Colors.orange.shade100, Colors.orange.shade900),
                  const SizedBox(width: 8),
                  _infoTag(chainName, Colors.grey.shade200, Colors.black),
                ],
              ),
              const SizedBox(height: 24),
              if(itemData.description.isNotEmpty)
                QuotedDescription(text: itemData.description),
              if(itemData.description.isNotEmpty)
                const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statBox("SELL VALUE", itemData.sellValue?.toString()??"NA", "coin"),
                  _statBox("Gem Price", itemData.gemPrice?.toString()??"NA", "gem"),
                  _statBox("Puzzle Coins", itemData.puzzleCoins?.toString()??"NA", "puzzle-coin"),
                  _statBox("Upgrade", itemData.upgradeValue?.toString()??"NA", "gem"),
                ],
              ),
            ],
          );
    Widget nameAndBack = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(itemData.name, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kTextDark)),
        Padding(
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
        )
      ],
    );

    var children = [
        // Large Item Image
      SizedBox(height:10,),
      LargeStageImage(itemData:itemData),

      SizedBox(width:  isDesktop?40:0,height: isDesktop?10:40,),
        // Item Description & Stats
        infoColumn,
      ];
    if(isDesktop) {
      return Column(
        children: [
          nameAndBack,
          Row(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: children,
          ),
        ],
      );
    }
      else {
     return Column(
       // mainAxisSize: MainAxisSize.min,
      children: [nameAndBack]+children,
         );
    }
  }

  Widget _buildWhereToFind() {
    return _sectionContainer(
      title: "Where to find",
      icon: Icons.edit_note,
      child:  Wrap(
        spacing: 8,
        runSpacing: 8,
        children:itemData.sourced.isEmpty?[Text('Nothing to show')]:  List.generate(itemData.sourced.length, (index) =>  ActionChip(
          label: Text(itemData.sourced.elementAt(index).value.split(':').last),
          onPressed: () {

          },
        ),
        ),
      ),
    );
  }

  Widget _buildHarvestableRewards() {
    return _sectionContainer(
      title: "Harvestable Rewards",
      icon: Icons.inventory_2,
      child: Wrap(
        children:itemData.harvestRewards.isEmpty?[Text('Nothing to show')]: List.generate(itemData.harvestRewards.length, (index) =>
            _rewardMiniPill(itemData.harvestRewards.elementAt(index).value.split(':').last, "COMMON"),
        ),
      ),
    );
  }

  Widget _buildHelpfulTipsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: kAccentGreen),
              SizedBox(width: 8),
              Text("Helpful Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          if(itemData.notes.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                visualDensity: VisualDensity(vertical: -3),
                contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: -2),
                leading:  const Icon(Icons.play_circle_sharp, size: 15), // Custom widget or Icon
                title: Text(itemData.notes[index]),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 5,),
              itemCount: itemData.notes.length,
          )
          else const Text('Nothing to show'),
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
    child: Text(label, style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.bold)),
  );

  Widget _statBox(String label, String value, String assetName) => Container(
    width: 100,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
    child: Column(
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, color: kTextSubtle, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset( '$assetName.webp',height: kMinInteractiveDimension/2,),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        )
        // Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // Text(sub, style: const TextStyle(fontSize: 10, color: kTextSubtle)),
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

class LargeStageImage extends StatelessWidget {
  const LargeStageImage({
    super.key,
    required this.itemData,
  });

  final MergeItem itemData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenSize.shortestSide*0.4,
      height: context.screenSize.shortestSide*0.4,
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20)],
      ),
      alignment: AlignmentGeometry.center,
      child: Stack(
        children: [
          StageItemImage(heightValue: context.screenSize.shortestSide*0.3, assetName: 'Stage_${itemData.stage}_-_${itemData.name.replaceAll(' ', '_')}'),
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
    );
  }
}

class QuotedDescription extends StatelessWidget {
  const QuotedDescription({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Card(
          color: Colors.white,
          // margin: EdgeInsets.all(8),
          child: Container(
            width: max(kDesktopBreak/2,context.screenSize.width*0.5),
            padding: const EdgeInsets.all(12),
            child:  AutoSizeText(
             text,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: kTextSubtle, height: 1.6),
              textAlign: TextAlign.center,
              maxLines: 3,
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
    );
  }
}