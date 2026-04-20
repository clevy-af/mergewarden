import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/dummies.dart';
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
  int currentIndex=0;

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
                            side:index==currentIndex? BorderSide(color: cCard,width: 2):null,
                            onPressed: () async {
                              // final value=  (HiveProvider.goals.getAt(index));
                              // // print(value);
                              // goalNotifier.value=GoalData.fromJson(value );
                              currentIndex=index;
                              setState(() {

                              });
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
                        surplus: index<goal.inventory.length-1?goal.inventory[index+1].count:0,
                        showCounter:goal.inventory[index].stage !=goal.inventory.last.stage,
                        chainId: goal.targetItem.chainId,
                         key: ObjectKey(goal),
                        isWildlife: goal.targetItem.chainId=='Wildlife',
                        inventory: goal.inventory[index],
                        onCounter: (int v) async {
                          List<Inventory> inventories=goal.inventory;
                          final value= inventories.removeAt(index);
                          List<Breakup> reductions=goal.targetItem.isWildlife?MergeCalculator.calculateWildlife(goal.inventory[index].stage==45?45:goal.inventory[index].stage+1, v.abs(),false):
                          MergeCalculator.getFullBreakdown(goal.inventory[index].stage, 1,goal.potions,goal.targetItem.has0,goal.targetItem.merge5);

                          // print(reductions);
                          inventories.insert(index, Inventory(stage: value.stage, count: value.count, potions: value.potions,
                              have: value.have+v,mergeBy5: value.mergeBy5,mergeBy3: value.mergeBy3,
                            surplus: value.surplus,

                          ));
                          for(int i=index+1;i<goal.inventory.length;i++){
                            int removeIndex=reductions.indexWhere((e)=>e.stage==inventories[i].stage);
                            Inventory inventory=inventories.removeAt(i);
                            var j = v.sign==-1?(inventory.have-reductions[removeIndex].count):inventory.have+reductions[removeIndex].count;
                            inventories.insert(i, Inventory(
                                stage: inventory.stage, count:inventory.count,
                                potions:inventory.potions,
                                have:j.clamp(0, inventory.count),
                                havePotions: inventory.havePotions,
                               surplus: inventory.surplus,
                               mergeBy3: v==-1?inventory.mergeBy3-1:v==1?inventory.mergeBy3+1:inventory.mergeBy3,
                               mergeBy5: v==-2?inventory.mergeBy5-1:v==2?inventory.mergeBy5+1:inventory.mergeBy5,
                            )
                            );
                          }

                          for(int i=index-1;i>=0;i--){
                            Inventory prevInventory=inventories.elementAt(i+1);
                            Inventory inventory=inventories.removeAt(i);
                            // print({
                            //   'c':inventory,
                            //   'p':prevInventory,
                            // });
                            inventories.insert(i, Inventory(
                              stage: inventory.stage, count:inventory.count,
                              potions: inventory.potions,
                              have:(inventory.have+inventory.potions+prevInventory.have+prevInventory.potions)>4?(prevInventory.have+prevInventory.potions)~/5 *2:0,
                              havePotions: inventory.havePotions,
                              surplus: inventory.surplus,
                              mergeBy3: inventory.mergeBy3,
                              mergeBy5: inventory.mergeBy5,
                            )
                            );
                          }
                          GoalData goalNew=GoalData(targetItem: goal.targetItem, inventory: inventories, createdAt: goal.createdAt);
                          await HiveProvider.goals.putAt(currentIndex, goalNew.toJson());
                        },
                        onPotion: () async {
                          List<Inventory> inventories=goal.inventory;
                          final value= inventories.removeAt(index);
                          inventories.insert(index,
                              Inventory(
                                  stage: value.stage, count: value.count, potions: value.potions, have: value.have,
                              havePotions: value.havePotions+1,mergeBy5: value.mergeBy5,mergeBy3: value.mergeBy3,
                                surplus: value.surplus,
                              )
                          );
                          GoalData goalNew=GoalData(
                              targetItem: goal.targetItem, inventory: inventories,
                              createdAt: goal.createdAt,
                          );
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
               '${progress.clamp(0, 100).percent}% Complete'.toString(),
                style: TextStyle(fontSize: context.isDesktop?20:15, fontWeight: FontWeight.w200, color: cCard),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {

  final bool isWildlife;
  final bool showCounter;
  final String? chainId;
  final Inventory inventory;
  final int surplus;
  final Function(int) onCounter;
  final Function() onPotion;
  const InventoryCard({super.key,
    required this.inventory, required this.chainId,required this.surplus, this.isWildlife=false,
    required this.onCounter, required this.onPotion, this.showCounter=true,
  });

  @override
  Widget build(BuildContext context) {
    int level=inventory.stage;
    // print(chainItems[chainId]);
    // print({
    //   'stage':inventory.stage,
    //   'prev':surplus,
    //   'surplus':surplus~/5*2-inventory.count,
    //   'inv':inventory.count,
    // });
    Map? data=chainItems[chainId]?.firstWhere((element) => element['stage']==level,orElse: () => {'name':"Stage $level"},);
    String title=data?['name']??'Stage $level';
    if (isWildlife) {
      if (level == 45) {
        title = "Magnificent Eggs";
      } else  if(level==0){
        title = "Eggs";
      }
    }
    var showStage = !(title.contains('Stage')||title.contains('Eggs'));
    var stageStyle= TextStyle(fontWeight: FontWeight.bold,color: Colors.black);
    const double cardHeight = kMinInteractiveDimension*1.6;
    return Semantics(
      label: 'Merge Gardens Goal: Stage $level Item',
      child: LayoutBuilder(
          builder: (context,c) {
            bool isDesktop=c.maxWidth>600;
            // print(c.maxWidth);
            Widget child;
            var counterColumn = showCounter?Container(
              width: kMinInteractiveDimension*2,
              margin: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(inventory.have<inventory.count&&inventory.mergeBy3>0)
                          CounterButton(
                              iconData:"-1",
                              onTap: () => onCounter(-1)
                          ),
                        const SizedBox(width: 8),

                        if(inventory.mergeBy5>0&&inventory.have>0)//inventory.have<inventory.count&&
                          CounterButton(
                              iconData:"-2",
                              onTap: () => onCounter(-2)
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(inventory.have<inventory.count&&inventory.mergeBy3>0)

                          CounterButton(
                              iconData: "+1",
                              onTap: () => onCounter(1)
                          ),

                        const SizedBox(width: 8),
                        if(inventory.have<inventory.count&&inventory.mergeBy5>0)

                          CounterButton(
                              iconData: "+2",
                              onTap: () => onCounter(2)
                          ),
                      ],
                    ),
                  ),

                ],
              ),
            ):SizedBox(width: kMinInteractiveDimension,);
            Widget potionView=inventory.potions>0?PotionView(
              cardHeight: cardHeight,
              showCounter: false,//inventory.havePotions<inventory.potions,
              potions: inventory.potions,
              onPotion: onPotion,
            ):SizedBox();

            var currentSurplus = surplus~/5*2-inventory.count;

            double progress = inventory.count==0||inventory.have>inventory.count?100:inventory.have.clamp(0, inventory.count)/ inventory.count*100;


            var countRow = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text((inventory.have.clamp(0, inventory.count)).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    // key: ValueKey(inventory.have),
                  ),
                ),
                if(surplus>0&&currentSurplus>0&&inventory.have>inventory.count)

                  SizedBox( width: 8,),
                if(surplus>0&&currentSurplus>0&&inventory.have>inventory.count)
                  Text('+ $currentSurplus', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,
                      fontSize: 15)),
              ],
            );

            if(isDesktop) {
               // print({'clamp':clamp,'inv':inventoryCount,'have':inventory.have});
              child= Row(
                children: [
                  CountView(height: cardHeight,count: inventory.count,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProgressCircle(progress:progress,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      height: cardHeight,
                                      width:cardHeight,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(image: AssetImage('assets/${chainId!='Wildlife'?'Stage_${level}_-_${title.replaceAll(' ', '_')}':'wildlife'}.webp'),),
                                      ),
                                    ),
                                    countRow,
                                  ],
                                ),
                              ),
                              Text(title, style: showStage?const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold):stageStyle),
                            ],
                          ),
                          potionView,
                        ],
                      ),
                    ),
                  ),
                  counterColumn,

                ],
              );
            }
            else {
              child= Row(
                children: [
                  CountView(height: cardHeight,count: 35,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(title,
                            style: showStage?const TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.bold)
                                :stageStyle,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    if(chainId!=null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        height: cardHeight,
                                        width:cardHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: chainId!='Wildlife'?DecorationImage(image: AssetImage('assets/Stage_${level}_-_${title.replaceAll(' ', '_')}.webp'),):null,
                                        ),
                                      ),
                                    countRow,
                                  ],
                                ),
                              ),
                              potionView
                            ],
                          ),

                          Flexible(child: LinearProgressIndicator(value: progress,color: cCard,)),

                        ],
                      ),
                    ),
                  ),
                  counterColumn,

                ],
              );
            }

            return Container(
              // padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              height: isDesktop?100:200,
              child: child,
            );
          }
      ),
    );
  }

}

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key, required this.iconData, required this.onTap,
  });
  final String iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6B8E6B).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          // child: Icon(iconData),
          child: Text(iconData),
        ),

      ),
    );
  }
}