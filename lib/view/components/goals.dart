import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/dummies.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/home.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({
    super.key,
    required this.stageBreakdown,
  });

  final Map<int, int> stageBreakdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextLogo(),
            const SizedBox(width: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  children: List.generate(5, (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder(
                        valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                        builder: (context,data,_) {
                          return ActionChip(
                              tooltip: 'Items Calculator',
                              side: data.get('type')=='items'?BorderSide(color: Colors.green):null,
                              onPressed: () async {
                                await  HiveProvider.appBox.put('type', 'items');
                                await  HiveProvider.appBox.put('chain', null);
                              },
                              label: Text('Items')
                          );
                        }
                    ),
                  ),),
                ),
              ),
            ),

          ],
        ),
        const SizedBox(height: 30),

        // Central Progress Card
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CardBox(
                child: GoalCard(
                  completed: 50,
                  targetItem: TargetItem(count: 2, stage: 4,chain: chains.first['name'],name: chainItems[chains.first['id']]?.firstWhere((element) => element['stage']==4,)['name']),
                  onReset: () {},
                ),
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              flex: 2,
              child:  CardBox(
                child: Column(
                  children: [
                    Text("Inventory".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180,
                        mainAxisExtent: 180,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: stageBreakdown.keys.length~/2,
                      itemBuilder: (context, index) =>  InventoryCard(
                        level: stageBreakdown.keys.elementAt(index),
                        count: stageBreakdown.values.elementAt(index),
                        chainId: HiveProvider.appBox.get('chain'),
                        isWildlife: HiveProvider.appBox.get('type')=='wildlife',
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),

        const SizedBox(height: 40),

        // Levels Grid
        const Text("REQUIRED ITEMS BY LEVEL", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        if(stageBreakdown.keys.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisExtent: 180,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: stageBreakdown.keys.length,
            itemBuilder: (context, index) =>  LevelCard(
              potions: 0,
              level: stageBreakdown.keys.elementAt(index),
              count: stageBreakdown.values.elementAt(index),
              chainId: HiveProvider.appBox.get('chain'),
              isWildlife: HiveProvider.appBox.get('type')=='wildlife',
            ),
          )
        else Text('Fill out your target details to get started'),
      ],
    );
  }
}

class GoalCard extends StatelessWidget {
  const GoalCard({super.key,  this.targetItem, required this.onReset, this.completed});
  final TargetItem? targetItem;
  final double? completed;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Semantics(
              label: 'Merge Gardens Goal Delete Button',
              child: IconButton(
                  tooltip: 'Delete',
                  onPressed: onReset, icon: Icon(Icons.delete)),
            )
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label: 'Merge Gardens Goal Target Name',
              child: Text(
                (targetItem?.name??targetItem?.chain).toString(),
                style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.02, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50)),
              ),
            ),
            if(targetItem!.name!=null)
              Semantics(
                label: 'Merge Gardens Goal Target Item',
                child: Container(
                  padding: const EdgeInsets.all(8),
                  // margin: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  // height: MediaQuery.of(context).size.height*0.4,
                  // width:MediaQuery.of(context).size.height*0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: cCard,
                    // boxShadow: [
                    //   BoxShadow(color: cCard,blurRadius: 3,spreadRadius: 3)
                    // ],
                    image: DecorationImage(
                        image: AssetImage('assets/Stage_${targetItem!.stage}_-_${targetItem!.name?.replaceAll(' ', '_')}.webp'),
                        fit: BoxFit.contain
                    ),
                  ),
                ),
              )
            else SizedBox(width: 8,),
          ],
        ),
        if(completed!=null)
          SizedBox(height: 5,),
        if(completed!=null)
          LineIndicator(value: completed!),
        if(completed!=null)
          Text("PROGRESS: $completed%", style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.width*0.03, fontWeight: FontWeight.bold)),

      ],
    );
  }
}
