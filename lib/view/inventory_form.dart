import 'package:flutter/material.dart';
import 'package:mergewarden/model/json.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/constants.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/view/components/stat_card.dart';

class InventoryPopup extends StatefulWidget {
  final String? chainID;
  final int targetStage;
  final Function(Map<int, int>) onUpdate;

  const InventoryPopup({
    super.key,
    required this.onUpdate, required this.chainID, required this.targetStage,
  });


  @override
  State<InventoryPopup> createState() => _InventoryPopupState();
}

class _InventoryPopupState extends State<InventoryPopup> {
    Map<int, int> tempInventory={};

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
                              chainId: widget.chainID,
                              count: entry.value,
                              stageName:MergeCalculator.stageName(widget.chainID,entry.key) ,
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
                                      TextEditingController stageController=TextEditingController();

                                      Iterable stages=[];
                                      if(widget.chainID=='Wildlife')
                                        {
                                         stages= wildlifeChain.sublist(0, wildlifeChain.indexWhere((value)=>value['stage']==widget.targetStage,));
                                        }
                                      else{
                                        stages=chainItems[widget.chainID]?.sublist(0,widget.targetStage)??[];
                                      }
                                      // print(stages);
                                      if(widget.chainID!=null&&stages.isNotEmpty||widget.chainID=='Wildlife') {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              border: Border.all(color: Color(0xFF000000),width: 0.6)
                                          ),
                                          margin: EdgeInsets.all(8),
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            dropdownColor: cLightBackground,
                                            focusColor: cCreme,
                                            value: int.tryParse(stageController.text),
                                            underline: SizedBox(),
                                            menuWidth: context.screenSize.width*(context.screenSize.width>kDesktopBreak?0.25:0.6),
                                            onChanged: ( newValue) {
                                              if(newValue!=null) {
                                                setState(() => tempInventory[newValue] = 1);
                                              }
                                            },
                                            items:stages.map((e) => DropdownMenuItem<int>(
                                              value: e['stage'] ,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child:Text("Stage ${e['stage']}: ${e['name']}" ),
                                              ),
                                            )
                                            ).toList()
                                            //     :
                                            // List.generate(widget.targetStage, (index) => DropdownMenuItem<int>(
                                            //   value: stages.elementAt(index)['stage'],
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            //     child: Text('Stage ${stages.elementAt(index)['stage']}: ${stages.elementAt(index)['name']}'),
                                            //   ),
                                            // ),),
                                          ),
                                        );
                                      } else {
                                        return Semantics(
                                          label: 'Merge Gardens Calculation Target Stage TextField',
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Enter stage of target item',
                                                labelText: 'Target Stage',
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
                                    }
                                ),
                                SizedBox(height: kMinInteractiveDimension,),
                                Text('Select a stage to add'),
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

class _InventoryCard extends StatelessWidget {
  final int level;
  final int count;
  final String? chainId;
  final String? stageName;
  final ValueChanged<int> onChanged;

  const _InventoryCard({required this.level, required this.count, required this.onChanged, required this.chainId, this.stageName});

  @override
  Widget build(BuildContext context) {
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
              merge5: false, has0: false, count: count, stage: level,
              isWildlife: chainId=='Wildlife',chainId: chainId,
            stageName: stageName
          )
          ) ,

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: cCreme.withAlpha(100), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: cRed
                  ),
                  onPressed: () => onChanged(count > 0 ? count - 1 : 0),
                  icon: const Icon(Icons.remove, size: 18, color: Colors.white), // Terracotta Red
                ),
                Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton.filled(
                  style: IconButton.styleFrom(
                      backgroundColor: cCard
                  ),
                  onPressed: () => onChanged(count + 1),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white), // Forest Green
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}