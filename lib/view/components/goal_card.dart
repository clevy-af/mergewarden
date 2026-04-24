import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/dummies.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/constants.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';

class CentralGoalCard extends StatefulWidget {
  const CentralGoalCard({super.key, });

  @override
  State<CentralGoalCard> createState() => _CentralGoalCardState();
}

class _CentralGoalCardState extends State<CentralGoalCard> {
  TargetItem? targetItem= TargetItem(merge5: false, has0: false, count: 2, stage: 4, isWildlife: false);
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
    return LayoutBuilder(

      builder: (context,c) {
        Widget child2= Column(
          children: [
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
                            dropdownColor: cLightBackground,
                            focusColor: cCreme,
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
                  onPressed: targetItem==null?null:() {
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
                    bool isWildlife=HiveProvider.appBox.get('type')=='wildlife';
                    // print({'chain':chainId,'stage':stageController.text,'count':countController.text,'type':HiveProvider.appBox.get('type')});
                    setState(() {

                    // print(chainController.text);
                    var stageNumber = int.parse(stageController.text);
                    if(chainId!=null&&chainController.text!='Wildlife') {
                      // chainName=chains.firstWhere((element) => element['name'].contains(chainController.text),orElse: () => {'id':null},)['id'];

                        Map? data=chainItems[chainId]?.firstWhere((element) => element['stage']==stageNumber,orElse: () => {'name':null,'url':null},);
                        targetName=data?['name'];
                        chainUrl=data?['url'];
                        // print(chainUrl);
                    }
                    targetItem=TargetItem(
                      merge5: false,
                      isWildlife:isWildlife ,
                      has0: HiveProvider.appBox.get('chain0'),
                        stageName: targetName??'Stage $stageNumber ${HiveProvider.appBox.get('type')=='wildlife'?'Wildlife':'Item'}',
                        url: chainUrl,
                        chainId: chainId, count: int.tryParse(countController.text)??0,
                        stage: stageNumber
                    );
                  });
                    HiveProvider().putBreakDown(isWildlife?MergeCalculator.calculateWildlife(targetItem!.stage, targetItem!.count):
                    MergeCalculator.getFullBreakdown(targetItem!.stage, targetItem!.count,0,HiveProvider.appBox.get('chain0'),false)
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
        );
        Widget child1=
        TargetPage(
          targetItem: targetItem,
            onReset: () {
          setState(() {
            targetItem=null;HiveProvider.appBox.delete('chain');
            stageController.clear();
            countController.clear();
            HiveProvider.appBox.delete('breakdown');
          });
        },
          onGoalSet: () {
            List<Inventory> inventories=[];
            for(int i=0;i<HiveProvider.appBox.get('breakdown').length;i++)
              {
                inventories.add(Inventory.fromJson(HiveProvider.appBox.get('breakdown')[i]));
              }
            HiveProvider().putGoal(
                GoalData(
                  potions: 0,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                    targetItem: targetItem!,
                    inventory: inventories
                )
            );
          },
        );
        Widget child;
        if(c.maxWidth>kDesktopBreak) {
          child=Row(
          children: [child1,child2],
        );
        } else {
          child = Column(
            children: [
              child1,child2
            ],
          );
        }
        return CardBox(child: child);
      }
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