import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:mergewarden/model/knowledge_base.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/utils/strings.dart';
import 'package:mergewarden/view/home.dart';

class CentralStatsCard extends StatefulWidget {
  const CentralStatsCard({super.key, });

  @override
  State<CentralStatsCard> createState() => _CentralStatsCardState();
}

class _CentralStatsCardState extends State<CentralStatsCard> {
  TargetItem? targetItem;
  TextEditingController chainController = TextEditingController();
  TextEditingController countController=TextEditingController();
  TextEditingController stageController=TextEditingController();
  TextEditingController potionController=TextEditingController();


  @override
  void dispose() {
    chainController.dispose();
    countController.dispose();
    stageController.dispose();
    potionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if(context.isDesktop)  TextLogo(),
                if(context.isDesktop) const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                      valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                      builder: (context,data,_) {
                        return ActionChip(
                            tooltip: 'Basic Item Calculator',
                            side: data.get('type')=='items'?BorderSide(color: cCard,width: 2):null,
                            onPressed: () async {
                              await  HiveProvider.appBox.put('type', 'items');
                              await  HiveProvider.appBox.put('chain', null);
                              HiveProvider.session.delete(sBreakdownKey);
                              stageController.clear();
                              countController.clear();
                              chainController.clear();
                            },
                            label: Text('Items')
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:ValueListenableBuilder(
                      valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                      builder: (context,data,_) {
                        return ActionChip(
                          tooltip: 'Basic Wildlife Calculator',
                          label: Text('Wildlife'),
                          side: data.get('type')=='wildlife'?BorderSide(color: cCard,width: 2):null,
                          onPressed: () async {
                            await  HiveProvider.appBox.put('type', 'wildlife');
                            HiveProvider.session.delete(sBreakdownKey);
                            stageController.clear();
                            countController.clear();
                            chainController.clear();
                            },
                        );
                      }
                  ),
                ),
              ],
            ),
          ),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 5),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal:context.isDesktop?MediaQuery.of(context).size.width*0.15:18),
          child: CardBox(

            child: targetItem==null?Column(
              children: [
                ValueListenableBuilder(
                  valueListenable:  HiveProvider.appBox.listenable(keys: ['type']),
                  builder:(context,data,_) {
                    bool isWildlife=data.get('type')=='wildlife';
                    // print({'type':data.get('type')});
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Semantics(
                            label: 'Merge Gardens Calculator Header',
                            child: Text('Target ${isWildlife?'Wildlife' : 'Item'} Calculator',
                              style:  TextStyle(fontSize:context.isDesktop?30:20,
                                  fontWeight: FontWeight.bold),),
                        ),
                        Tooltip(
                          message: 'How to Use',
                          // message: 'Enter Chain name to select and get stage details easily, add count for target items.\n The required items will be calculated and broken down per stage, visible below.',
                          preferBelow: true,
                          triggerMode: TooltipTriggerMode.tap,
                          child: IconButton(
                              onPressed: showExplainerDialog,
                              icon: Icon(Icons.question_mark_outlined,color: cCard,),
                            // tooltip: 'Info',
                          ),
                        ),
                      ],
                    );
                  }
                ),
                ValueListenableBuilder(
                    valueListenable: HiveProvider.appBox.listenable(keys: ['type','chain']),
                    builder: (context,data,_) {
                      bool isWildlife=data.get('type')=='wildlife';

                      if(isWildlife){
                        // chainController = TextEditingController()..text='Wildlife';
                        // data.put('chain',chainController.text);

                      }
                      else {
                        chainController.clear();
                      }
                      return Container(
                        margin: const EdgeInsets.all(8.0),

                        key: ValueKey(data.get('type')),
                        child: Semantics(
                          label: 'Merge Gardens Calculation Chain Autocomplete',
                          child: Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              if(isWildlife) {
                                return wildlifeList.where((String option) {
                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                              }
                                return chains.map((e) => e['name'].toString(),).where((String option) {
                                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Material(
                                color: cLightBackground,
                                surfaceTintColor: cCreme,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemExtent: 50,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              );
                            },
                            // displayStringForOption: (option) => option,
                            onSelected: (String selection) {
                              // print('You selected: $selection');
                            HiveProvider.appBox.put('chain', selection);

                            },
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              // chainController=controller;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration:  InputDecoration(
                                  labelText: '${isWildlife?'Wildlife':'Chain'} Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),),
                              );
                            },
                          ),
                        ),
                      );
                    }
                ),

                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: HiveProvider.appBox.listenable(keys: ['chain','type']),
                        // key: ValueKey(null),
                        builder: (context,data,_) {
                          bool isWildlife=data.get('type')=='wildlife';
                          String? chainId=data.get('chain')?.toString().replaceAll(' ', isWildlife?'':'_');
                          Iterable stages=chainItems[chainId]??[];
                          HiveProvider.appBox.put('chain0', stages.where((element) => element['stage']==0,).isNotEmpty);
                          // print( HiveProvider.appBox.get('chain0',));
                          if(chainId!=null&&stages.isNotEmpty||isWildlife) {
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
                                onChanged: ( newValue) {
                                  setState(() { stageController.text = (newValue??0) .toString(); });
                                },
                                items:isWildlife?List.generate(wildlifeStages.length, (index) => DropdownMenuItem<int>(
                                  value: wildlifeStages[index]['stage'] ,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child:Text( wildlifeStages[index]['name'] ),
                                  ),
                                )
                                ): List.generate(stages.length, (index) => DropdownMenuItem<int>(
                                  value: stages.elementAt(index)['stage'],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Stage ${stages.elementAt(index)['stage']}: ${stages.elementAt(index)['name']}'),
                                  ),
                                ),),
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
                    Positioned(
                        top: 0,
                        left: 5,
                        child: Text('*')
                    )
                  ],
                ),

                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Semantics(
                        label: 'Merge Gardens Calculation Target Count TextField',
                        child:TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter number of target items',
                            labelText: 'Target Count',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          controller: countController,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 5,
                        child: Text('*')
                    )
                  ],
                ),
                ValueListenableBuilder(
                    valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                    builder: (context,data,_) {
                      bool isWildlife=data.get('type')=='wildlife';
                      if(isWildlife) return SizedBox();
                    return Semantics(
                      label: 'Merge Gardens Calculation Potion TextField',
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter number of potions available',
                            labelText: 'Potion Count',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide()
                            ),
                          ),
                          controller: potionController,
                        ),
                      ),
                    );
                  }
                ),
                Container(
                  alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Fields marked with * are mandatory.',style: hintStyle,)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ValueListenableBuilder(
                          valueListenable:  HiveProvider.appBox.listenable(keys: ['merge5Checkbox']),
                          builder:(context,data,_) {
                            bool merge5Only=data.get('merge5Checkbox')??false;
                          return Semantics(
                            value: 'Checkbox for Merge 5 Only calculation',
                            child: Checkbox(
                                value: merge5Only,
                                activeColor: cCard,
                                onChanged:(value) => HiveProvider.appBox.put('merge5Checkbox',value),
                            ),
                          );
                        }
                      ),
                      Text('Merge 5 Only')
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  label: 'Merge Gardens Calculation Button',
                  child: TextButton(
                      onPressed: () {
                        String? targetName;
                        if(stageController.text.isEmpty||countController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filling in target details mandatory.')));
                          return;
                        }
                        var merge5Only = HiveProvider.appBox.get('merge5Checkbox')??false;

                        int? stageCount,stageLevel;
                        stageCount=int.tryParse(countController.text);
                        stageLevel=int.tryParse(stageController.text);
                        if([stageLevel,stageCount].contains(null)) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Numeric values make sense, don\'t they?')));
                          return;
                        }
                        // print('still going ahead?');
                        bool isWildlife=HiveProvider.appBox.get('type')=='wildlife';
                        String? chainId=HiveProvider.appBox.get('chain')?.toString().replaceAll(' ', isWildlife?'':'_');
                        // print({'chain':chainId,'stage':stageController.text,
                        //   'count':countController.text,
                        //   'type':HiveProvider.appBox.get('type'),
                        //   'chain0':HiveProvider.appBox.get('chain0'),
                        //
                        // });
                        // print(chainController.text);
                        int stageNumber = int.parse(stageController.text);
                        // print(stageNumber);

                        if(chainId!=null&&!isWildlife) {
                          // chainName=chains.firstWhere((element) => element['name'].contains(chainController.text),orElse: () => {'id':null},)['id'];

                          Map? data=chainItems[chainId]?.firstWhere((element) => element['stage']==stageNumber,orElse: () => {'name':null,'url':null},);
                          targetName=data?['name'];
                          // print(targetName);
                        }

                        setState(() {


                        targetItem=TargetItem(
                          isWildlife:isWildlife ,
                          has0: HiveProvider.appBox.get('chain0')??false,
                            merge5: merge5Only,
                            stageName:isWildlife?wildlifeStages.firstWhere((element) => element['stage']==stageNumber,orElse: () => {'name':'Wildlife'},)['name']:targetName??'Stage $stageNumber ${'Item'}',
                            chainId: chainId, count: int.tryParse(countController.text)??0,
                            stage: stageNumber
                        );
                      });
                        HiveProvider().putBreakDown(isWildlife?MergeCalculator.calculateWildlife(targetItem!.stage, targetItem!.count,merge5Only):
                        MergeCalculator.getFullBreakdown(targetItem!.stage, targetItem!.count,int.tryParse(potionController.text)??0,HiveProvider.appBox.get('chain0'),merge5Only)
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: cCard,
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10)
                      ),
                      child: Text("Calculate!",
                        style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                  ),
                ),
              ],
            ):
            TargetPage(
              targetItem: targetItem,
                onReset: () {
              setState(() {
                targetItem=null;
                HiveProvider.appBox.delete('chain');
                stageController.clear();
                countController.clear();
                potionController.clear();
                HiveProvider.session.delete(sBreakdownKey);
              });
            },
              onGoalSet: () {
                List<Inventory> inventories=[];
                for(int i=1;i<HiveProvider.session.get(sBreakdownKey).length;i++)
                  {
                    inventories.add(Inventory.fromJson(HiveProvider.session.get(sBreakdownKey)[i]));
                  }
                HiveProvider().putGoal(
                    GoalData(
                      uid: DateTime.now().millisecondsSinceEpoch.toString(),
                      potions: int.tryParse(potionController.text)??0,
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                        targetItem: targetItem!,
                        inventory: inventories
                    )
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void showExplainerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('How to use Target Item Calculator'),
          actionsPadding: EdgeInsets.only(bottom: 10,right: 10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• Make sure you have selected the correct tab above the form: Items / Wildlife.'),
                const Text('• In the form -'),
                const Text('1. Select your chain: e.g., Oak Trees, Tulips, etc. (Optional)'),
                const Text('2. Enter target level you want to reach.'),
                const Text('3. Enter how many of those items you need.'),
                const Text('4. Enter how many potions you have available. (Optional)'),
                const Text('5. Select whether to calculate merges by 5 only. (If you intend to repeat the target, leave it checked.)'),
                const Divider(height: 30),
                const Text('Example Calculation:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Example Table
                Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  children: const [
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('Input', style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
                    ]),
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('Chain')),
                      Padding(padding: EdgeInsets.all(8), child: Text('Oak Trees')),
                    ]),
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('Target Stage')),
                      Padding(padding: EdgeInsets.all(8), child: Text('4')),
                    ]),
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('Target Quantity')),
                      Padding(padding: EdgeInsets.all(8), child: Text('2')),
                    ]),
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('Potion Quantity')),
                      Padding(padding: EdgeInsets.all(8), child: Text('1')),
                    ]),
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(8), child: Text('Merge 5 Only')),
                      Padding(padding: EdgeInsets.all(8), child: Text('True')),
                    ]),
                  ],
                ),

                const SizedBox(height: 15),
                const Text('• View Result: All required items will be calculated and broken down per stage, shown below the form.'),
                const SizedBox(height: 15),

                const Text(
                      'NB: If Merge by 5 is unchecked, calculation is optimal, without extras; 5-merges till possible, then 3-merge as needed. For merge by 5, if count is odd, it will be rounded up to accommodate 5-merges only. Potions are used starting from highest stage, once per merge(5 or 3).',
                  style: hintStyle,
                ),
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
}

class CardBox extends StatelessWidget {
  const CardBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:max(MediaQuery.of(context).size.width*0.6,450),
      padding: const EdgeInsets.only(bottom: 15,left: 15,right: 15,top: 10),
      // alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 20)],
      ),
      child: child,
    );
  }
}

class LineIndicator extends StatelessWidget {
  const LineIndicator({super.key, required this.value, this.width});
  final double value;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LinearProgressIndicator(
        color: cCard,
        value: value/100,
      ),
    );
  }
}


class TargetPage extends StatelessWidget {
  const TargetPage({super.key,  this.targetItem, required this.onReset, required this.onGoalSet});
  final TargetItem? targetItem;
  final VoidCallback onReset;
  final VoidCallback onGoalSet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Tooltip(
              message: 'Add To GoalS',
              child: TextButton(

                onPressed: onGoalSet,
                child: Text('Add As Goal'),
              ),
            ),
            SizedBox(width: 8,),
            Semantics(
              label: 'Merge Gardens Calculation Reset Button',
              child: IconButton(
                  tooltip: 'Reset',
                  onPressed: onReset, icon: Icon(Icons.refresh)),
            ),
          ],
        ),

        TargetItemView(targetItem: targetItem),

        Semantics(
          label: 'Merge Gardens Calculation Result',
          child: Text(
            "Breakdown for ${targetItem?.count} Stage ${targetItem?.stage==45?4.5:targetItem?.stage} ${HiveProvider.appBox.get('type')=='wildlife'?'Wildlife':'Items'}",
            style: TextStyle(letterSpacing: 1.5, fontSize:context.isDesktop?20:15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class TargetItemView extends StatelessWidget {
  const TargetItemView({
    super.key,
    required this.targetItem, this.width, this.height,
  });

  final TargetItem? targetItem;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var heightValue =height?? MediaQuery.of(context).size.height*0.3;
    var assetName = '';
    if(targetItem?.chainId!=null){
      if(targetItem?.isWildlife==false) {
        assetName ='Stage_${targetItem?.stage}_-_${targetItem?.stageName?.replaceAll(' ', '_')}';
      } else {
        assetName='wildlife/${targetItem?.chainId}${targetItem?.stage}';
      }
    }
    else {
      if(targetItem?.isWildlife==false) {
        assetName ='book';
      } else {
        assetName='wildlife';
      }
    }
    return SizedBox(
      width: width??MediaQuery.of(context).size.width,
      child: Column(

        children: [
          if(targetItem!.chainId!=null)

            Semantics(
              label: 'Merge Gardens Target Item',
              child: StageItemImage(heightValue: heightValue, assetName: assetName),
            ),
          const SizedBox(height: 20),

          Semantics(
            label: 'Merge Gardens Target Text',
            child: Text(
              (targetItem?.stageName??targetItem?.chainId).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.isDesktop?30:20, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50),),
            ),
          ),
        ],
      ),
    );
  }
}

class StageItemImage extends StatelessWidget {
  const StageItemImage({
    super.key,
     this.heightValue,
    required this.assetName, this.borderRadius,
  });

  final double? heightValue;
  final BorderRadius? borderRadius;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // margin: EdgeInsets.all(8),
      height: heightValue,
      width:heightValue,
      decoration: BoxDecoration(
        borderRadius: borderRadius??BorderRadius.circular(15),
        color: cCard,
        image: DecorationImage(
            image: AssetImage('$assetName.webp'),
            fit: BoxFit.contain
        ),
      ),
    );
  }
}


class LevelCard extends StatelessWidget {
  final int level;
  final int count;
  final int potions;
  final bool isWildlife;
  final String? chainId;
  const LevelCard({super.key, required this.level, this.chainId, this.count=0, this.isWildlife=false, this.potions=0});

  @override
  Widget build(BuildContext context) {
    Map? data=chainItems[chainId??0]?.firstWhere((element) => element['stage']==level,orElse: () => {'name':"Stage $level"},);
   String title=data?['name']??'Stage $level';
   // print(isWildlife);
   // print(chainId.runtimeType);
    if (isWildlife) {
      if (level == 45) {
        title = "Magnificent Eggs";
      } else  if(level==0){
        title = "Eggs";
      }
    }
    var showStage = !(title.contains('Stage')||title.contains('Eggs'));
    var stageStyle= TextStyle(fontWeight: FontWeight.bold,color: Colors.black);
    final formatter = NumberFormat.decimalPattern();
    final formattedNumber = formatter.format(count);
    return Semantics(
      label: 'Merge Gardens Calculation Stage $level Item',
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(showStage?'Stage $level':title, style: showStage?const TextStyle(color: Colors.grey):stageStyle),
                if(chainId!=null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  height: kMinInteractiveDimension,
                  width:kMinInteractiveDimension,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(image: AssetImage(isWildlife?chainId!=null?'wildlife/$chainId$level.webp':'wildlife.webp':'assets/Stage_${level}_-_${title.replaceAll(' ', '_')}.webp'),),
                  ),
                ),
                if(showStage)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FittedBox(child: Text(title, style: stageStyle,maxLines: 1,)),
                ),
                Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      margin: showStage?null:const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: cCard,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(formattedNumber.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
              ],
            ),
          ),
          if(potions>0)
            Padding(
              padding: EdgeInsetsGeometry.all(5),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,),
                    height: kMinInteractiveDimension,
                    alignment: Alignment.bottomCenter,
                    width:kMinInteractiveDimension,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image:DecorationImage(image: AssetImage('assets/Stage_4_-_Potent_Concoction.webp'),fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    margin: showStage?null:const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: cCard,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(potions.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                  ),

                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CountView extends StatelessWidget {
  const CountView({super.key, required this.count, required this.height});
  final int count;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      // margin: const EdgeInsets.symmetric(horizontal: 8),//showStage?null:
      decoration: BoxDecoration(
        color: Colors.black54.withAlpha(50),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: FittedBox(child: Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20))),
    );
  }
}


class PotionView extends StatelessWidget {
  const PotionView({
    super.key,
    required this.cardHeight,
    required this.showCounter,
    required this.potions, required this.onPotion,
  });

  final double cardHeight;
  final bool showCounter;
  final int potions;
  final VoidCallback onPotion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8,vertical: 5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            height: cardHeight,
            alignment: Alignment.bottomCenter,
            width:cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image:DecorationImage(image: AssetImage('assets/Stage_4_-_Potent_Concoction_old.webp'),),
            ),
          ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              // margin: showStage?null:const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: cCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(potions.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          if(showCounter)
          Positioned(
            right:0,
            left: 0,
            top:0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onPotion ,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.remove,color: Colors.white,),
                  ),
                ),
                GestureDetector(
                  onTap: onPotion ,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add,color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({
    super.key, required this.progress,
  });
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: kMinInteractiveDimension+8,
          width: kMinInteractiveDimension+8,
          margin: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: cCard,
            value: (progress/100).clamp(0, 100),
            backgroundColor: cBackground,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${(progress).clamp(0, 100).percent}%',),
        )
      ],
    );
  }
}