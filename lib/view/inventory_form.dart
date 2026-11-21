import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mergewarden/model/knowledge_base.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/constants.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/view/components/info_button.dart';
import 'package:mergewarden/view/components/stat_card.dart';

class InventoryPopup extends StatefulWidget {
  final String? chainID;
  final int targetStage;
  final List<Inventory> inventory;
  final bool isWildlife;
  final Function(Map<int, int>) onUpdate;

  const InventoryPopup({
    super.key,
    required this.onUpdate, required this.chainID, required this.targetStage, required this.isWildlife, required this.inventory,
  });


  @override
  State<InventoryPopup> createState() => _InventoryPopupState();
}

class _InventoryPopupState extends State<InventoryPopup> {
    Map<int, int> tempInventory={};
    TextEditingController stageController=TextEditingController();

    @override
  void dispose() {
    stageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Stack(
            alignment: AlignmentGeometry.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildHeader(),
                    const Divider(height: 32, color: Color(0xFFE0D8C3)),
                    Builder(

                        builder: (context) {
                          List<Widget> children=[];
                          for (var entry in  tempInventory.entries){
                            children.add(_InventoryCard(
                              level: entry.key,
                              maxCount: widget.inventory.firstWhere((element) => element.stage==entry.key,).count,
                              isWildlife: widget.isWildlife,
                              chainId: widget.chainID,
                              count: entry.value,
                              stageName:MergeCalculator.stageName(widget.chainID,entry.key,widget.isWildlife) ,
                              onChanged: (newVal) {
                                setState(() => tempInventory[entry.key] = newVal);
                              },
                            ));
                          }
                          children.add( Container(
                            width: 210,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE0D8C3)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Builder(

                                    builder: (context) {

                                      Iterable stages=[];
                                      if(widget.chainID==null) {
                                        return Semantics(
                                        label: 'Update Inventory TextField',
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Enter stage of item',
                                              labelText: 'Item Stage',
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  borderSide: BorderSide()
                                              ),
                                            ),
                                            controller: stageController,
                                          ),
                                        ),
                                      );
                                      }
                                      else {
                                        if (widget.isWildlife) {
                                          stages = wildlifeStages.sublist(0,
                                              wildlifeStages.indexWhere((
                                                  value) =>
                                              value['stage'] ==
                                                  widget.targetStage,));
                                        }
                                        else {
                                          stages = chainItems[widget.chainID]
                                              ?.sublist(
                                              0, widget.targetStage) ?? [];
                                        }
                                        // print(stages);
                                        if (stages.isNotEmpty || widget.isWildlife) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(15.0),
                                                border: Border.all(
                                                    color: Color(0xFF000000),
                                                    width: 0.6)
                                            ),
                                            margin: EdgeInsets.all(8),
                                            child: DropdownButton<int>(
                                                isExpanded: true,
                                                dropdownColor: cLightBackground,
                                                focusColor: cCreme,
                                                value: int.tryParse(
                                                    stageController.text),
                                                underline: SizedBox(),
                                                menuWidth: context.screenSize
                                                    .width *
                                                    (context.screenSize.width >
                                                        kDesktopBreak
                                                        ? 0.25
                                                        : 0.6),
                                                onChanged: (newValue) {
                                                  if (newValue != null) {
                                                    setState(() =>
                                                    tempInventory[newValue] =
                                                    1);
                                                  }
                                                },
                                                items: stages.map((e) =>
                                                    DropdownMenuItem<int>(
                                                      value: e['stage'],
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8.0),
                                                        child: Text(
                                                            "Stage ${e['stage']}: ${e['name']}"),
                                                      ),
                                                    )
                                                ).toList()
                                            ),
                                          );
                                        }
                                        else {
                                          return SizedBox();
                                        }
                                      }
                                    }
                                ),
                                if(widget.chainID==null)
                                  Builder(
                                    builder: (context) {
                                      return TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: cCard,
                                        ),
                                        // borderRadius: BorderRadius.circular(50),
                                        onPressed: () {
                                          if (stageController.text.isEmpty) {
                                            return;
                                          }
                                          int? stage= int.tryParse(stageController.text);
                                          if (stage!=null) {
                                            setState(() =>
                                            tempInventory[stage] =
                                            1);
                                          }
                                          else {
                                            stageController.clear();
                                          }
                                        },
                                        child: Text('Submit',style: TextStyle(color: Colors.white),),
                                      );
                                    }
                                  ),
                                SizedBox(height: kMinInteractiveDimension,),
                                Text(
                                    '${widget.chainID==null?'Type':'Select'} a stage to add'
                                ),
                              ],
                            ),
                          ));
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: children,
                          );
                        }
                    ),
                    const SizedBox(height: kMinInteractiveDimension),

                  ],
                ),
              ),
              Positioned(
                bottom:0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: kMinInteractiveDimension),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.transparent
                      ),
                      // width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => widget.onUpdate(tempInventory),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E7356), // Forest Green
                          foregroundColor: Colors.white,
                          // padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text("Update Calculation", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
    void showExplainerDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('How to Update Inventory'),
            actionsPadding: EdgeInsets.only(bottom: 10,right: 10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• To get started, you will see a card with stage selector;choose one.'),
                  const Text('\t- Target Stage Item image and name will be displayed.'),
                  const Text('\t- Update Inventory: Add/subtract your inventory items to adjust your progress. PS:This adds/subtracts per submit, and will auto-update other stages to accommodate the item(eg. adding 5 stage 2s would update stage 3: 2, stage 2: 5, stage 1: 13.)'),
                  const Text('\t- Steppers (+/-): To change 1 quantity tap once. To change multiple, tap and hold, the longer you hold the faster the stepper will count.'),
                  const Text('\t- To Reset/ Start over,either subtract/add inversely. Eg, you added 5 stage 2s incorrectly, subtract 5 stage 2s to counter it. You could also use Reset from goal screen, but that would change all stage progress to 0.'),
                  const Divider(height: 20),
                  const Text('• To submit, click Update Calculation:'),
                  const Text('\t- You should see the entered amount added(if some already present) to the level card.'),
                  const Text('\t- As mentioned,other stages also auto update if merges are possible, so appropriate levels(above and below) also would add up.'),
                  const SizedBox(height: 10),

                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it!'),
              ),
            ],
          );
        },
      );
    }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.inventory_2_outlined, color: Color(0xFF5E7356)),
            const SizedBox(width: 12),
            const Text(
              "Adjust Inventory",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF5D534A)),
            ),

            Spacer(),
            InfoButton(onPressed:  showExplainerDialog),

            CloseButton(),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "Enter items you already have to update your calculation.",
            style: TextStyle(color: Color(0xFFA6998A), fontSize: 13),
          ),
        ),
      ],
    );
  }

}

class _InventoryCard extends StatefulWidget {
  final int level;
  final int count;
  final int maxCount;
  final bool isWildlife;
  final String? chainId;
  final String? stageName;
  final ValueChanged<int> onChanged;

  const _InventoryCard({required this.level, required this.count, required this.onChanged, required this.chainId, this.stageName, required this.isWildlife, required this.maxCount});

  @override
  State<_InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<_InventoryCard> {

  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.maxCount);
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0D8C3)),
      ),
      child: Column(
        children: [
          TargetItemView(
            height: kMinInteractiveDimension,
              targetItem: TargetItem(
              merge5: false, has0: false, count: widget.count, stage: widget.level,
              isWildlife:widget.isWildlife,chainId: widget.chainId,
            stageName: widget.stageName
          )
          ) ,

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: cCreme.withAlpha(100), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.onChanged(widget.count > 0 ? widget.count - 1 : 0),
                  onLongPressEnd: (e)=>_timer?.cancel(),
                  onLongPressStart: (details) => _timer=Timer.periodic(Duration( milliseconds: 100),(t)=> widget.onChanged(widget.count > 0 ? widget.count - 1 : 0)),
                  child: Card(
                    color: cRed,
                    shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.remove, size: 18, color: Colors.white),
                    ), // Forest Green
                  ),
                ),
                Text("${widget.count}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => widget.onChanged(widget.count<widget.maxCount?widget.count + 1:widget.count),
                  onLongPressEnd: (e)=>_timer?.cancel(),
                  onLongPressStart: (details) => _timer=Timer.periodic(Duration( milliseconds: 100),(t)=> widget.onChanged(widget.count<widget.maxCount?widget.count + 1:widget.count)),
                  child: Card(
                      color: cCard,
                    shape:  RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.add, size: 18, color: Colors.white),
                    ), // Forest Green
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}