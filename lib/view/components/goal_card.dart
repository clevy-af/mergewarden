import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/json.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/home.dart';

class CentralGoalCard extends StatefulWidget {
  const CentralGoalCard({super.key, });

  @override
  State<CentralGoalCard> createState() => _CentralGoalCardState();
}

class _CentralGoalCardState extends State<CentralGoalCard> {
  TargetItem? targetItem;
  Map<int,int> inventoryItem={};
  TextEditingController chainController = TextEditingController();
  TextEditingController countController=TextEditingController();
  TextEditingController stageController=TextEditingController();
  int currentIndex=0;

  @override
  void dispose() {
    chainController.dispose();
    countController.dispose();
    stageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HiveProvider.goals.listenable(),
        builder: (context, value, child) {
          GoalData? goal;
          if(value.keys.contains(currentIndex)) {
            goal=GoalData.fromJson(value.get(currentIndex));
          }
          targetItem=goal?.targetItem;
          // print(goal.inventory.map((e)=>e.stage));
          return LayoutBuilder(

              builder: (context,c) {


                Widget child2= goal==null?SizedBox():Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(15),
                      child:  Text('Add items you have to include in calculation.',style: hintStyle.copyWith(fontStyle: FontStyle.normal),),
                    ),
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Builder(

                            builder: (context,) {
                              String? chainId=targetItem?.chainId;
                              List stages=chainItems[chainId]??[];
                              // print(chainId);
                              if(chainId!=null&&stages.isNotEmpty||chainId=='Wildlife') {
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
                                    items: chainId=='Wildlife'?List.generate(wildlifeChain.indexWhere((e)=> e['stage']==targetItem!.stage)+1, (index) => DropdownMenuItem<int>(
                                      value: wildlifeChain[index]['stage'] ,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(wildlifeChain[index]['name']),
                                      ),
                                    )
                                    ): List.generate(stages.indexWhere((e)=> e['stage']==targetItem!.stage)+1, (index) => DropdownMenuItem<int>(
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
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('All fields are mandatory.',style: hintStyle,)
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      label: 'Merge Gardens Calculation Button',
                      child: TextButton(
                          onPressed: ()  {
                            if(stageController.text.isEmpty||countController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filling in item details mandatory.')));
                              return;
                            }

                            int? stageCount,stageLevel;
                            stageCount=int.tryParse(countController.text);
                            stageLevel=int.tryParse(stageController.text);
                            if([stageLevel,stageCount].contains(null)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Numeric values make sense, don\'t they?')));
                              return;
                            }
                            inventoryItem={stageLevel!:stageCount!};

                            List<Breakup> list=goal!.targetItem.isWildlife?MergeCalculator.calculateWildlife(inventoryItem.keys.first, inventoryItem.values.first,targetItem?.merge5??false):
                            MergeCalculator.getFullBreakdown(inventoryItem.keys.first,inventoryItem.values.first,0,goal.targetItem.has0);

                            for (var e in list) {
                             // print (e.stage);
                              Inventory x =goal.inventory.firstWhere((element) => element.stage==e.stage,);
                              if(x.count>e.count) {
                                x.count-=e.count;
                              }
                              else {
                                x.count=0;
                              }
                            }
                            HiveProvider.goals.put(currentIndex, goal.toJson());

                          },
                          style: TextButton.styleFrom(
                              backgroundColor: cCard,
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10)
                          ),
                          child: Text("Submit",
                            style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),)
                      ),
                    ),
                  ],
                );
                Widget child1= Column(
                  children: [

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Track Your Goal',
                          style:  TextStyle(fontSize:context.isDesktop?30:20,
                              fontWeight: FontWeight.bold),),
                        SizedBox(width: 10,),
                        IconButton(
                          tooltip: 'Delete goal',
                          onPressed: () {
                          HiveProvider.goals.delete(currentIndex);
                        } , icon: Icon(Icons.delete_outline),color: Colors.red,)
                      ],
                    ),


                    if(targetItem!=null)
                      SizedBox(height: 20,),
                    if(targetItem!=null)
                      TargetItemView(targetItem: targetItem),

                  ],
                );
                Widget child;
                if(c.maxWidth>400) {

                  child=Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Flexible(child: child1), Flexible(child: child2)],
                  );
                } else {
                  child = Column(
                    children: [child1, child2],
                  );
                }
                return Column(
                  children: [
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        if(context.isDesktop)TextLogo(),
                        if(context.isDesktop) SizedBox(width: 10,),
                        SizedBox(
                          width: c.maxWidth*0.81,
                          height: kMinInteractiveDimension,
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => SizedBox(width: 8,),
                            scrollDirection: Axis.horizontal,
                            itemCount: value.keys.length,
                            itemBuilder: (context, index) => ActionChip(
                                tooltip: 'Goal Item ${index+1}',
                                side:value.keys.elementAt(index)==currentIndex? BorderSide(color: cCard,width: 2):null,
                                onPressed: ()  {
                                  // final value=  (HiveProvider.goals.getAt(index));
                                  // // print(value);
                                  // goalNotifier.value=GoalData.fromJson(value );
                                  setState(() {
                                  currentIndex=value.keys.elementAt(index);

                                  });

                                   HiveProvider.appBox.put('goalIndex', currentIndex);
                                },
                                label: Text(value.getAt(index)['targetItem']['name']??'Item  ${index+1}')
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    if(value.isEmpty||value.get(currentIndex)==null) CardBox(
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height*0.4,
                            child: Text('Add a Goal to Get Started...')
                        )
                    )
                else
                    CardBox(child: child),
                  ],
                );

              }
          );
        }
    );
  }
}