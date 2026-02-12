import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/dummies.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';

class CentralStatsCard extends StatefulWidget {
  const CentralStatsCard({super.key, required this.onSubmit,});
  final Function(Map<int,int>) onSubmit;

  @override
  State<CentralStatsCard> createState() => _CentralStatsCardState();
}

class _CentralStatsCardState extends State<CentralStatsCard> {
  TargetItem? targetItem;
  TextEditingController chainController = TextEditingController();
  TextEditingController countController=TextEditingController();
  TextEditingController stageController=TextEditingController();
  ValueNotifier<String?> chainId=ValueNotifier(null);

  @override
  void dispose() {
    chainController.dispose();
    countController.dispose();
    stageController.dispose();
    chainId.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Center(

      child: Container(
        width:max(MediaQuery.of(context).size.width*0.6,450),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 20)],
        ),
        child: targetItem==null?Column(
          children: [

            ValueListenableBuilder(
              valueListenable:  HiveProvider.appBox.listenable(keys: ['type']),
              builder:(context,data,_) {
                bool isWildlife=data.get('type')=='wildlife';
                return Align(child: Text('Target ${isWildlife?'Wildlife' : 'Item'} Calculator',style:  TextStyle(fontSize: MediaQuery.of(context).size.width*0.025, fontWeight: FontWeight.bold),));
              }
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:ValueListenableBuilder(
                  valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                  // key: ValueKey(null),
                  builder: (context,data,_) {
                    bool isWildlife=data.get('type')=='wildlife';

                    if(isWildlife){
                      chainController = TextEditingController()..text=chainId.value='Wildlife';
                      data.put('chain',chainController.text);

                    }
                    else {
                      chainController.clear();
                    }
                    return Container(
                      key: ValueKey(data.get('type')),
                      child: isWildlife?TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter ${isWildlife?'Wildlife' : 'Chain'} Name',
                          labelText: '${isWildlife?'Wildlife' : 'Chain'} Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        readOnly: isWildlife,
                        controller: chainController,
                      ):
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return chains.map((e) => e['name'].toString(),).where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Material(
                            child: ListView.builder(
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
                          print('You selected: $selection');
                        HiveProvider.appBox.put('chain', chains.firstWhere((element) => element['name'].contains(selection),orElse: () => {'id':null},)['id']);

                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          // chainController=controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration:  InputDecoration(
                              labelText: 'Chain Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),),
                          );
                        },
                      ),
                    );
                  }
              ),
            ),

            Stack(
              alignment: Alignment.centerLeft,
              children: [
                ValueListenableBuilder(
                    valueListenable: HiveProvider.appBox.listenable(keys: ['chain']),
                    // key: ValueKey(null),
                    builder: (context,data,_) {
                      String? chainId=data.get('chain');
                      if(chainId!=null) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Color(0xFF000000),width: 0.6)
                          ),
                          margin: EdgeInsets.all(8),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: int.tryParse(stageController.text),
                            underline: SizedBox(),
                            onChanged: ( newValue) {
                              setState(() { stageController.text = (newValue??0) .toString(); });
                            },
                            items: chainId=='Wildlife'?List.generate(8, (index) => DropdownMenuItem<int>(
                              value: index+1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Stage ${index+1}'),
                              ),
                            )
                            ): List.generate(chains.firstWhere((element) => element['id']==chainId,orElse: () => {'stages':0})['stages'], (index) => DropdownMenuItem<int>(
                              value: index+1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Stage ${index+1}'),
                              ),
                            ),),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
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
                  child: TextField(
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
                child: Text('Fields marked with * are mandatory.',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.009),)
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () { setState(() {
                  String? chainName,chainUrl;
                  if(stageController.text.isEmpty||countController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filling in target details mandatory.')));
                    return;
                  }

                  if(chainController.text.isNotEmpty&&chainController.text!='Wildlife') {
                    chainName=chains.firstWhere((element) => element['name'].contains(chainController.text),orElse: () => {'id':null},)['id'];
                    if(chainName!=null){
                      Map? data=chainItems[chainName]?.firstWhere((element) => element['stage']==stageController,orElse: () => {'name':null,'url':null},);
                      chainName=data?['name'];
                      chainUrl=data?['url'];
                    }
                  }
                  targetItem=TargetItem(
                      name: chainName,
                      url: chainUrl,
                      chain: chainController.text, count: int.tryParse(countController.text)??0,
                      stage: int.parse(stageController.text)
                  );
                });
                widget.onSubmit(
                    HiveProvider.appBox.get('type')=='wildlife'?MergeCalculator.calculateWildlife(targetItem!.stage, targetItem!.count):
                    MergeCalculator.getFullBreakdown(targetItem!.stage, targetItem!.count)
                );
                },
                style: TextButton.styleFrom(
                  backgroundColor: cBackground,
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10)
                ),
                child: Text("Calculate!",
                  style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black),)
            ),
          ],
        ):
        Column(
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Reset',
                    onPressed: () {
                  setState(() {
                    targetItem=null;HiveProvider.appBox.delete('chain');
                    stageController.clear();
                    countController.clear();
                  });
                }, icon: Icon(Icons.refresh))
              ],
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      color: cCard,
                      backgroundColor: Colors.black,
                      strokeWidth: 5,
                      value: 0,//0.4,
                    ),
                  ),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFFF0F4F0),
                    backgroundImage: NetworkImage('https://store-images.s-microsoft.com/image/apps.41185.14321666486326182.fa278455-44db-4ead-94ab-964c9c1f1290.ab4dc92b-e9f7-4a07-93f7-60053e3f7868?h=253'),
                    // child:ClipRRect(
                    //   borderRadius: BorderRadiusGeometry.all(Radius.circular(50)),
                    //   child: NativeImage(targetItem!.url!=null?'https://api.allorigins.win/get?url=${targetItem!.url!}':'https://store-images.s-microsoft.com/image/apps.41185.14321666486326182.fa278455-44db-4ead-94ab-964c9c1f1290.ab4dc92b-e9f7-4a07-93f7-60053e3f7868?h=253',
                    //     // height: 45.toString(),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

             Text(
                (targetItem!.name??targetItem!.chain).toString(),
                style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50)),
              ),
            Text(
              "Breakdown for ${targetItem!.count} Stage ${targetItem!.stage} ${HiveProvider.appBox.get('type')=='wildlife'?'Wildlife':'Items'}",
              style: TextStyle(letterSpacing: 1.5, fontSize:MediaQuery.of(context).size.width*0.02, fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: 5,),
            // Text("PROGRESS: 0%", style: TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.width*0.03, fontWeight: FontWeight.bold)),

          ],
        ),
      ),
    );
  }
}

class LevelMiniCard extends StatelessWidget {
  final int level;
  final int count;
  final bool isWildlife;
  const LevelMiniCard({super.key, required this.level,  this.count=0, this.isWildlife=false});

  @override
  Widget build(BuildContext context) {
    String title="Stage $level";
    if (isWildlife) {
      if (level == 45) {
        title = "Magnificent Eggs";
      } else  if(level==0){
        title = "Eggs";
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.spaceBetween,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: const TextStyle(color: Colors.grey)),
          // SizedBox(width: ,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF9BAE96).withValues(alpha:0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}