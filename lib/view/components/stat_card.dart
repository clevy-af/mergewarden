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

  @override
  void dispose() {
    chainController.dispose();
    countController.dispose();
    stageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Center(

      child: Container(
        width:max(MediaQuery.of(context).size.width*0.6,450),
        padding: const EdgeInsets.all(30),
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text('Target ${isWildlife?'Wildlife' : 'Item'} Calculator',style:  TextStyle(fontSize: MediaQuery.of(context).size.width*0.025, fontWeight: FontWeight.bold),),
                    Tooltip(
                      message: 'Enter Chain name to select and get stage details easily, add count for target items.\n The required items will be calculated and broken down per stage, visible below.',
                      preferBelow: true,
                      triggerMode: TooltipTriggerMode.tap,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline),
                        // tooltip: 'Info',
                      ),
                    ),],
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:ValueListenableBuilder(
                  valueListenable: HiveProvider.appBox.listenable(keys: ['type','chain']),
                  // key: ValueKey(null),
                  builder: (context,data,_) {
                    bool isWildlife=data.get('type')=='wildlife';

                    if(isWildlife){
                      chainController = TextEditingController()..text='Wildlife';
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
                          // print('You selected: $selection');
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
                      Iterable stages=chainItems[chainId]??[];
                      HiveProvider.appBox.put('chain0', stages.where((element) => element['stage']==0,).isNotEmpty);
                      if(chainId!=null&&stages.isNotEmpty||chainId=='Wildlife') {
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
                onPressed: () {
                  String? targetName,chainUrl;
                  if(stageController.text.isEmpty||countController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filling in target details mandatory.')));
                    return;
                  }

                  int? stageCount,stageLevel;
                  stageCount=int.tryParse(countController.text);
                  stageLevel=int.tryParse(stageController.text);
                  if([stageLevel,stageCount].contains(null)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Numeric values make sense, don\'t they?')));
                    return;
                  }
                  // print('still going ahead?');
                  String? chainId=HiveProvider.appBox.get('chain');
                  setState(() {

                  // print(chainController.text);
                  if(chainId!=null&&chainController.text!='Wildlife') {
                    // chainName=chains.firstWhere((element) => element['name'].contains(chainController.text),orElse: () => {'id':null},)['id'];

                      Map? data=chainItems[chainId]?.firstWhere((element) => element['stage']==int.parse(stageController.text),orElse: () => {'name':null,'url':null},);
                      targetName=data?['name'];
                      chainUrl=data?['url'];
                      // print(chainUrl);
                  }
                  targetItem=TargetItem(
                      name: targetName,
                      url: chainUrl,
                      chain: chainController.text, count: int.tryParse(countController.text)??0,
                      stage: int.parse(stageController.text)
                  );
                });
                widget.onSubmit(
                    HiveProvider.appBox.get('type')=='wildlife'?MergeCalculator.calculateWildlife(targetItem!.stage, targetItem!.count):
                    MergeCalculator.getFullBreakdown(targetItem!.stage, targetItem!.count,HiveProvider.appBox.get('chain0'))
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
                        widget.onSubmit({});
                      });
                    }, icon: Icon(Icons.refresh))
              ],
            ),
            if(targetItem!.url!=null)
            Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height*0.4,
              width:MediaQuery.of(context).size.height*0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: cBackground,blurRadius: 3,spreadRadius: 3)
                ],
                image: DecorationImage(
                    image: AssetImage('assets/Stage_${targetItem!.stage}_-_${targetItem!.name?.replaceAll(' ', '_')}.webp'),
                    fit: BoxFit.contain
                ),
              ),
            ),
            const SizedBox(height: 20),

             Text(
                (targetItem?.name??targetItem?.chain).toString(),
                style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50)),
              ),
            Text(
              "Breakdown for ${targetItem?.count} Stage ${targetItem?.stage} ${HiveProvider.appBox.get('type')=='wildlife'?'Wildlife':'Items'}",
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
  final String? chainId;
  const LevelMiniCard({super.key, required this.level, this.chainId, this.count=0, this.isWildlife=false});

  @override
  Widget build(BuildContext context) {
    Map? data=chainItems[chainId??0]?.firstWhere((element) => element['stage']==level,orElse: () => {'name':"Stage $level"},);
   String title=data?['name']??'Stage $level';
   String? url=data?['url'];
    if (isWildlife) {
      if (level == 45) {
        title = "Magnificent Eggs";
      } else  if(level==0){
        title = "Eggs";
      }
    }
    var showStage = !(title.contains('Stage')||title.contains('Eggs'));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          if(url!=null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            height: kMinInteractiveDimension,
            width:kMinInteractiveDimension,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: chainId!=null?DecorationImage(image: AssetImage('assets/Stage_${level}_-_${title.replaceAll(' ', '_')}.webp'),):null,
            ),
          ),
          if(showStage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Stage $level', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            margin: showStage?null:const EdgeInsets.symmetric(vertical: 8),
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