import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/home.dart';
import 'components/stat_card.dart';

class TargetGoalScreen extends StatefulWidget {
  const TargetGoalScreen({super.key,});

  @override
  State<TargetGoalScreen> createState() => _TargetGoalScreenState();
}

class _TargetGoalScreenState extends State<TargetGoalScreen> {
  final ValueNotifier<GoalData?> goalNotifier=ValueNotifier(null);
  int currentIndex=0;
  @override
  void initState() {
    if(HiveProvider.goals.isNotEmpty) {
      // print(HiveProvider.goals.getAt(0));
      goalNotifier.value=GoalData.fromJson(HiveProvider.goals.getAt(0));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              children: [
                if(context.isDesktop)TextLogo(),
                if(context.isDesktop) SizedBox(width: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*(context.isDesktop?0.5:0.8),
                  height: kMinInteractiveDimension,
                  child: ValueListenableBuilder(
                    valueListenable: HiveProvider.goals.listenable(),
                    builder: (context, value, child) {
                      // final data= value.ge
                      // print(value.toMap());
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => SizedBox(width: 8,),
                        scrollDirection: Axis.horizontal,
                        itemCount: value.keys.length,
                        itemBuilder: (context, index) => ActionChip(
                            tooltip: 'Goal Item ${index+1}',
                            side: BorderSide(color: cCard,width: 2),
                            onPressed: () async {
                              final value=  (HiveProvider.goals.getAt(index));
                              // print(value);
                              goalNotifier.value=GoalData.fromJson(value );
                              currentIndex=index;
                            },
                            label: Text(value.getAt(index)['targetItem']['name']??'Item  ${index+1}')
                        ),
                     );
                    }
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: HiveProvider.goals.listenable(),
              builder: (context, value, child) {
                if(value.isEmpty||value.getAt(currentIndex)==null) return Text('Add a Goal to Get Started...');
                GoalData goal=GoalData.fromJson(value.getAt(currentIndex));
                // print(goal.inventory.map((e)=>e.stage));
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader("TARGET GOAL"),
                    const SizedBox(height: 20),
                    _buildMainProgressCard(context,goal.targetItem,goal.progress),
                    const SizedBox(height: 20),
                    _buildHeader("Inventory".toUpperCase()),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(height: 1,),
                      ),
                      itemCount:goal.inventory.length,// stageBreakdown.keys.length,
                      itemBuilder: (context, index) =>  InventoryCard(
                        showCounter: ![goal.targetItem.stage,goal.inventory.last.stage].contains(goal.inventory[index].stage),
                        chainId: goal.targetItem.chainId,
                         key: ObjectKey(goal),
                        isWildlife: goal.targetItem.chainId=='Wildlife',
                        inventory: goal.inventory[index],
                        onCounter: (int v) async {
                          List<Inventory> inventories=goal.inventory;
                          final value= inventories.removeAt(index);
                          List<Breakup> subtraction=goal.targetItem.isWildlife?MergeCalculator.calculateWildlife(goal.inventory[index].stage+1, 1,false):MergeCalculator.getFullBreakdown(goal.inventory[index].stage+1, 1,goal.potions,goal.targetItem.has0,false);

                          print(subtraction);
                          inventories.insert(index, Inventory(stage: value.stage, count: value.count, potions: value.potions, have: value.have+v));
                          for(int i=index+1;i<goal.inventory.length;i++){
                            int removeIndex=subtraction.indexWhere((e)=>e.stage==inventories[i].stage);
                            Inventory inventory=inventories.removeAt(i);
                            // print({inventories[i].stage:inventories[i].count - subtraction[removeIndex].count});
                            var j = v==1?(inventory.count-subtraction[removeIndex].count):inventory.count+subtraction[removeIndex].count;
                            inventories.insert(i, Inventory(
                                stage: inventory.stage, count:j.clamp(0, inventory.count),
                                potions: subtraction[removeIndex].potions,
                                have: inventory.have,
                                havePotions: inventory.havePotions
                            )
                            );
                          }
                          GoalData goalNew=GoalData(targetItem: goal.targetItem, inventory: inventories, createdAt: goal.createdAt);
                          await HiveProvider.goals.putAt(currentIndex, goalNew.toJson());
                        },
                        onPotion: () async {
                          List<Inventory> inventories=goal.inventory;
                          final value= inventories.removeAt(index);
                          inventories.insert(index, Inventory(stage: value.stage, count: value.count, potions: value.potions, have: value.have, havePotions: value.havePotions+1));
                          GoalData goalNew=GoalData(targetItem: goal.targetItem, inventory: inventories, createdAt: goal.createdAt);
                          await HiveProvider.goals.putAt(currentIndex, goalNew.toJson());
                        },

                      ),
                    ),
                  ],
                );
              }
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF2D3E2D),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMainProgressCard(BuildContext context,TargetItem targetItem,double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      // margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {
                HiveProvider.goals.deleteAt(currentIndex);
              } , icon: Icon(Icons.delete_outline))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(targetItem.chainId!=null)
                Semantics(
                  label: 'Merge Gardens Calculation Target Item',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    // margin: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height*0.2,
                    width:MediaQuery.of(context).size.height*0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cCard,
                      // boxShadow: [
                      //   BoxShadow(color: cCard,blurRadius: 3,spreadRadius: 3)
                      // ],
                      image: DecorationImage(
                          image: AssetImage('assets/${targetItem.chainId!=null&&targetItem.chainId!='Wildlife'?'Stage_${targetItem.stage}_-_${targetItem.stageName?.replaceAll(' ', '_')}':'wildlife'}.webp'),
                          fit: BoxFit.contain
                      ),
                    ),
                  ),
                ),
              SizedBox(
                width: 20,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Merge Gardens Calculation Target Text',
                    child: Text(
                      'Stage ${targetItem.stage}',
                      style: TextStyle(fontSize: context.isDesktop?20:15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height:  10,
                  ),
                  Semantics(
                    label: 'Merge Gardens Calculation Target Text',
                    child: Text(
                      (targetItem.stageName??targetItem.chainId).toString(),
                      style: TextStyle(fontSize: context.isDesktop?40:30, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50)),
                    ),
                  ),
                ],
              ),

            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(height: 1,),
          ),
          Semantics(
            label: 'Merge Gardens Calculation Target Text',
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
               '${progress.percent}% Complete'.toString(),
                style: TextStyle(fontSize: context.isDesktop?20:15, fontWeight: FontWeight.w200, color: cCard),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key, required this.iconData, required this.onTap,
  });
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6B8E6B).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(iconData),
      ),

    );
  }
}