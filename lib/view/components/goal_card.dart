import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/knowledge_base.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/constants.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/confetti.dart';
import 'package:mergewarden/view/home.dart';
import 'package:mergewarden/view/inventory_form.dart';

class CentralGoalCard extends StatefulWidget {
  const CentralGoalCard({super.key, required this.goalData, required this.onDelete, required this.onReset, required this.onUpdate, });
  final GoalData? goalData;
  final VoidCallback onDelete;
  final VoidCallback onReset;
  final bool Function(Map<int,int>) onUpdate;


  @override
  State<CentralGoalCard> createState() => _CentralGoalCardState();
}

class _CentralGoalCardState extends State<CentralGoalCard> {
  TargetItem? targetItem;
  Map<int,int> inventoryItem={};
  TextEditingController chainController = TextEditingController();
  TextEditingController countController=TextEditingController();
  TextEditingController stageController=TextEditingController();

  @override
  void initState() {
    targetItem=widget.goalData?.targetItem;
    super.initState();
  }
  @override
  void dispose() {
    chainController.dispose();
    countController.dispose();
    stageController.dispose();
    super.dispose();
  }

  void showExplainerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('How to use Goals'),
          actionsPadding: EdgeInsets.only(bottom: 10,right: 10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('You reached here after calculating a target stage breakdown, to track/sync your inventory with the breakdown.'),
                const Divider(height: 20),
                const Text('• In the top card, you can see your target details -'),
                const Text('\t- Target Stage Item image and name, along with count.'),
                const Text('\t- Progress of completing this goal. If this shows 100%, it means you have enough to merge up to target, if you haven\'t already.'),
                const Text('\t- Update Inventory: Add/subtract your inventory items to adjust your progress. This will auto-update other stages to accommodate the item(eg adding 5 stage 2s would update stage 3: 2, stage 2: 5, stage 1: 13.)'),
                const Text('\t- Reset: Start over, like turning a new leaf.'),
                const Text('\t- Delete: If you are done, you can remove this from goals to stop tracking it.'),
                const Divider(height: 20),
                const Text('• In the list below, you will find:'),
                const Text('\t- Stage Item image and name.'),
                const Text('\t- Needed: number of items you need to reach the target and Have: what you have currently.'),
                const Text('\t- Potion: number of potions used. Note that this count is not included in needed/have.'),
                const Text('\t- Progress Circle: your progress in collecting items of this stage, shows checkmark if done (needed=have).'),
                const SizedBox(height: 10),

                const Text(
                  'NB: You cannot change merge5Only or potion count preference here.',
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


  @override
  Widget build(BuildContext context) {
    // print(widget.goalData?.targetItem.chainId);
    return Column(
      children: [
        const SizedBox(height: 10),


        if([widget.goalData,targetItem].contains(null)) CardBox(
            child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height*0.4,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildTooltip(),

                      ],
                    ),
                    Spacer(),
                    Text('Create a Calculation to Get Started...'),
                    Spacer(),

                  ],
                )
            )
        )
        else
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF5E7356),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                // Image Placeholder
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                    // side: BorderSide(color: cCreme,width: 2)
                  ),
                  color:Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB( 8,16,8,8),
                    child: TargetItemView(
                      targetItem: targetItem,
                      width: context.screenSize.width*(context.screenSize.width>kDesktopBreak?0.14:0.3),
                      height: context.screenSize.height*0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          _buildBadge("CURRENT GOAL"),
                          Spacer(),
                          buildTooltip(),
                        ],
                      ),
                      Builder(
                          builder: (context) {
                            var indexWhere = chains.indexWhere((element) => element['id']==targetItem?.chainId,);
                            if(!indexWhere.isNegative&&chains[indexWhere]['masterpiece']!=null&&chains[indexWhere]['stages']==targetItem?.stage) {
                              return Text("# Masterpiece ${chains[indexWhere]['masterpiece']}", style:const TextStyle(color: Colors.white, fontSize: 10));
                            }
                            return SizedBox();
                          }
                      ),
                      const SizedBox(height: 10),
                      Text("${targetItem?.count} Stage ${targetItem?.stage} Items", style: TextStyle(fontSize:context.isDesktop?30:20,color: Colors.white70)),
                      const SizedBox(height: 10),
                      if(targetItem?.chainId!=null)
                      Text(targetItem?.isWildlife==true?'Of Wildlife':"Of ${chains.firstWhere((element) => element['id']==targetItem?.chainId,)['name']} Chain", style:const TextStyle(color: Colors.white, fontSize: 10)),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: LinearProgressIndicator(
                          value: (widget.goalData?.progress??0)/100,
                          color: Colors.white,
                          backgroundColor: Colors.white70,
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text("Progress: ${widget.goalData?.progress.clamp(0, 100).toStringAsFixed(2)} %", style: const TextStyle(fontSize: 18, color: Colors.white,)),
                      ),
                      // const SizedBox(height: 30),
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if(widget.goalData!.progress<100)
                            Tooltip(
                              message: 'Tap to Update Inventory of Goal',
                              child: TextButton.icon(

                                style: TextButton.styleFrom(backgroundColor: cBackground,padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15)),
                                label: Text("Update Inventory",style: TextStyle(color: Colors.white),),
                                icon:  Icon(Icons.inventory_2_outlined,color: Colors.white,),
                                onPressed: () {
                                  showAdaptiveDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) => InventoryPopup(
                                      chainID: targetItem?.chainId,
                                      isWildlife: targetItem?.isWildlife??false,
                                      targetStage: targetItem?.stage??0,
                                      onUpdate: (p0) {
                                      final result=widget.onUpdate(p0);
                                        Navigator.of(context).pop();
                                        // print(result);
                                        if(result==true) showCompletionDialog(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          Tooltip(
                            message: 'Tap to Reset Goal',
                            child: TextButton.icon(
                              style: TextButton.styleFrom(backgroundColor: cBackground,padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15)),
                              label: Text("Reset",style: TextStyle(color: Colors.white),),
                              icon:  Icon(Icons.replay,color: Colors.white,),
                              onPressed: widget.onReset,
                            ),
                          ),
                          Tooltip(
                            message: 'Tap to Delete Goal',
                            child: TextButton.icon(
                              style: TextButton.styleFrom(backgroundColor: cRed,padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15)),
                              label: Text("Delete",style: TextStyle(color: Colors.white),),
                              icon:  Icon(Icons.delete_outline,color: Colors.white,),
                              onPressed:widget.onDelete ,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  Tooltip buildTooltip() {
    return Tooltip(
                                message: 'How to Use',
                                // message: 'Enter Chain name to select and get stage details easily, add count for target items.\n The required items will be calculated and broken down per stage, visible below.',
                                preferBelow: true,
                                triggerMode: TooltipTriggerMode.tap,
                                child: IconButton(
                                  onPressed: showExplainerDialog,
                                  icon: Icon(Icons.question_mark_outlined,color: Colors.white,),
                                  // tooltip: 'Info',
                                ),
                              );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.all(8,),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: cCreme),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}
class GoalLevelCard extends StatelessWidget {
  final Inventory inventory;
  final String? chainId;
  final bool isWildlife;
  const GoalLevelCard({super.key, required this.inventory, this.chainId, required this.isWildlife});

  @override
  Widget build(BuildContext context) {
    int level=inventory.stage;
    int count=inventory.count;
    int have=inventory.have;
    // print(chainId);
    Map? data=chainItems[chainId??0]?.firstWhere((element) => element['stage']==level,orElse: () => {'name':"Stage $level"},);
    String title=data?['name']??'Stage $level';
    // var isWildlife = chainId=='Wildlife';
    if (isWildlife) {
      if (level == 45) {
        title = "Magnificent Eggs";
      } else  if(level==0){
        title = "Eggs";
      }
    }

    double progress=count==0?100:have/count*100;
    Widget rowChild=Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        if(chainId!=null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            height: context.screenSize.height*0.15,
            width: context.screenSize.height*0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image:DecorationImage(image: AssetImage(isWildlife?'wildlife/$chainId$level.webp':'Stage_${level}_-_${title.replaceAll(' ', '_')}.webp'),),
            ),
          ),
        SizedBox(width: 15,),
        _stat(isWildlife?'':'Stage $level', title),
        Spacer(
          flex: 2,
        ),
        _buildRequirementStats(),
        SizedBox(width: 15,),
        if(inventory.potions>0)
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
                  margin: isWildlife?null:const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: cCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(inventory.potions.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),

              ],
            ),
          ),
        Spacer(
          flex: 3,
        ),
        if(progress>=100)
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: Color(0xFF5E7356),
              borderRadius: BorderRadius.circular(12),
            ),
            child:  const Icon(Icons.check,color: Colors.white,),
          )
        else ProgressCircle(progress: progress),
        Spacer(),

      ],
    );
    Widget columnChild=Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(chainId!=null&&chainId!='Wildlife')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            height: context.screenSize.height*0.15,
            width: context.screenSize.height*0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: chainId!=null?DecorationImage(image: AssetImage('assets/Stage_${level}_-_${title.replaceAll(' ', '_')}.webp'),):null,
            ),
          ),
        Spacer(),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rowStat(isWildlife?'':'Stage $level', title,true),
            SizedBox(height: 10,),
            _buildRequirementStats(),
          ],
        ),
        Spacer(),
        if(inventory.potions>0)
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
                  margin: isWildlife?null:const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: cCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(inventory.potions.toString(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),

              ],
            ),
          ),
        if(progress>=100)
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: Color(0xFF5E7356),
              borderRadius: BorderRadius.circular(12),
            ),
            child:  const Icon(Icons.check,color: Colors.white,),
          )
        else ProgressCircle(progress: progress),
      ],
    );
    return Semantics(
      label: 'Merge Gardens Calculation Stage $level Item',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: LayoutBuilder(builder: (context, constraints) {
          if(constraints.maxWidth>kDesktopBreak) {
            return rowChild;
          }
          return columnChild;
        },),
      ),
    );
  }
  Widget _buildRequirementStats() {
    final formatter = NumberFormat.decimalPattern();
    final formattedNumber = formatter.format(inventory.count);
    return Row(
      children: [
        _stat("NEEDED", formattedNumber.toString()),
        const SizedBox(width: 24),
        _stat("HAVE", formatter.format(inventory.have).toString()),
      ],
    );
  }
  Widget _stat(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
      ],
    );
  }
  Widget _rowStat(String label, String val,[bool addDot=false]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        if(addDot)
          Text('\t•\t', style: const TextStyle(fontSize: 15, color: Colors.grey)),

        Text(val, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      ].reversed.toList(),
    );
  }

}


class GoalScreenView extends StatefulWidget {
  const GoalScreenView({
    super.key,
  });

  @override
  State<GoalScreenView> createState() => _GoalScreenViewState();
}

class _GoalScreenViewState extends State<GoalScreenView> {
  List<GoalData> goals=[];
  GoalData? activeGoal;

  @override
  void initState() {

    HiveProvider.goals.toMap().values.map((value) {
      goals.add(GoalData.fromJson(value));
    },).toList();
    if(goals.isNotEmpty) activeGoal=goals.first;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // print(activeGoal);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if(context.isDesktop)TextLogo(),
                if(context.isDesktop) SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    height: kMinInteractiveDimension,
                    child: ListView.separated(
                      shrinkWrap: true,
                      key: ObjectKey(goals),
                      separatorBuilder: (context, index) => SizedBox(width: 8,),
                      scrollDirection: Axis.horizontal,
                      itemCount: goals.length,
                      itemBuilder: (context, index) => ActionChip(
                          tooltip: 'Goal Item ${index+1}',
                          side:goals.elementAt(index).uid==activeGoal?.uid? BorderSide(color: cCard,width: 2):null,
                          onPressed: () {
                            setState(() {
                              activeGoal=goals.elementAt(index);
                            });
                          },
                          label: Text(goals.elementAt(index).targetItem.stageName??'Item  ${index+1}')
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
        ),
        // Central Progress Card
        SliverToBoxAdapter(
          child:  Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: CentralGoalCard(
                onUpdate: (Map<int,int>p0) {
                  // print(p0);
                  TargetItem target=activeGoal!.targetItem;
                  bool showConfetti=false;
                  for (var element in p0.entries) {
                    List<Breakup> list=target.isWildlife?MergeCalculator.calculateWildlife(element.key, element.value,false):MergeCalculator.getFullBreakdown(element.key, element.value,activeGoal!.potions,target.has0,false);

                    // print(list);
                    for (var element in list) {
                      int x= activeGoal!.inventory.indexWhere((e) => element.stage==e.stage,);
                      if(x.isNegative) continue;
                      activeGoal!.inventory[x].have+=element.count;
                      if(activeGoal!.inventory[x].have>=activeGoal!.inventory[x].count){
                        showConfetti=true;
                      }
                    }
                  }
                  final highest=(p0.keys.reduce(max));
                  Map<int,int> maxLevels=MergeCalculator.calculateMaxReachStat(
                      {highest:activeGoal!.inventoryMap()[highest]??0},merge5Only:activeGoal!.targetItem.merge5);
                  // maxLevels.entries.toList().sort((a, b) => a.key.compareTo(b.key),);
                  // print(maxLevels);

                  // for(var element in p0.entries){
                  //   maxLevels.remove(highest);
                  // }

                  for (var element in  maxLevels.entries) {

                    int x= activeGoal!.inventory.indexWhere((e) => element.key==e.stage,);
                    if(x.isNegative) continue;
                    activeGoal!.inventory[x].have=element.value;
                    if(activeGoal!.inventory[x].have>=activeGoal!.inventory[x].count){
                      showConfetti=true;
                    } }



                  HiveProvider.goals.put(activeGoal!.uid,activeGoal!.toJson());

                  int update=goals.indexWhere((element) => element.uid==activeGoal?.uid,);
                  if(update.isNegative) return false;
                  setState(() {
                    goals[update]=activeGoal!;
                  });
                  return showConfetti;
                  // if(showConfetti) showCompletionDialog(context);
                },
                onReset: () {
                  GoalData goal=activeGoal!;
                  for (var element in goal.inventory) {
                    element.have=0;
                  }
                  HiveProvider.goals.put(goal.uid,goal.toJson());
                  int update=goals.indexWhere((element) => element.uid==activeGoal?.uid,);
                  if(update.isNegative) return;
                  setState(() {
                    activeGoal=goals[update]=goal;
                  });
                },
                goalData:activeGoal,
                key: ObjectKey(activeGoal),
                onDelete: () {
                  HiveProvider.goals.delete(activeGoal?.uid);
                  setState(() {
                    goals.removeWhere((element) => element.uid==activeGoal?.uid,);
                    if(goals.isNotEmpty) {
                      activeGoal=goals.first;
                    }
                    else {
                      activeGoal=null;
                    }
                  });
                  // print('deleted');
                },
              )
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
        ),
        SliverToBoxAdapter(
          child:  Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Required per Level".toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:activeGoal==null?Text('Nothing to show for now'):
            Builder(
                builder: (context) {

                  return ListView.separated(
                    key: ObjectKey(activeGoal!.inventorySorted),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 8,),
                    itemCount:activeGoal!.inventorySorted .length,
                    itemBuilder: (context, index) =>  GoalLevelCard(
                      isWildlife: activeGoal!.targetItem.isWildlife,
                      key: ValueKey(activeGoal!.inventorySorted[index]),
                      inventory: activeGoal!.inventorySorted[index],
                      chainId: activeGoal!.targetItem.chainId,
                    ),
                  );

                }
            ),
          ),
        ),
      ],
    );
  }
}