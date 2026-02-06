import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/dummies.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF5E7356),
                ),
              ),
              const Icon(Icons.local_florist, size: 40, color: Color(0xFF5E7356)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Level 17 Life Flower",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class InventoryItem extends StatelessWidget {
  final String title;
  const InventoryItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.eco_outlined, color: cCard),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          const StepperButton(icon: Icons.remove),
          const StepperButton(icon: Icons.add),
        ],
      ),
    );
  }
}

class StepperButton extends StatelessWidget {
  final IconData icon;
  const StepperButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF5E7356).withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF5E7356)),
    );
  }
}

class QuickAddBar extends StatelessWidget {
  const QuickAddBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Type to add (e.g., 3 x Lvl 5)",
          icon: Icon(Icons.keyboard_command_key, color: Colors.grey),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  Map<int,int> stageBreakdown={};

  Widget get navigationRail=>  NavigationRail(
    backgroundColor: Colors.white.withValues(alpha:0.5),
    selectedIndex: _selectedIndex,
    // trailing: ,
    onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
    labelType: NavigationRailLabelType.all,
    leading: Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: AssetImage('assets/mg_logo.jpeg'))
          ),
          height: 80,width: 80,
        ),
        Text('Chains')
      ],
    ),
    destinations: const [
      NavigationRailDestination(icon: Icon(Icons.local_florist,color: cCard,), label: Text('Life Flowers')),
      NavigationRailDestination(icon: Icon(Icons.park), label: Text('Fruit Trees')),
      NavigationRailDestination(icon: Icon(Icons.egg), label: Text('Dragons')),
    ],
  );

  bool get isDesktop=>MediaQuery.of(context).size.width>500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      drawer: isDesktop?null:navigationRail,
      appBar: isDesktop?null: AppBar(leading: IconButton(onPressed: () {} , icon:Icon( Icons.menu)),),
      body: Row(
        children: [
          // Sidebar - Merge Chains
          if(isDesktop) navigationRail,
          if(isDesktop) const VerticalDivider(thickness: 1, width: 1),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('mg_text.svg',height: 80,),
                      const SizedBox(width: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder(
                          valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                          builder: (context,data,_) {
                            return ActionChip(
                              side: data.get('type')=='items'?BorderSide(color: Colors.green):null,
                                onPressed: () async => await  HiveProvider.appBox.put('type', 'items'),
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
                                label: Text('Wildlife'),
                              side: data.get('type')=='wildlife'?BorderSide(color: Colors.green):null,
                              onPressed: () async => await  HiveProvider.appBox.put('type', 'wildlife'),
                            );
                          }
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 30),

                  // Central Progress Card
                  CentralStatsCard(
                    onSubmit: (p0) {
                      setState(() {
                        stageBreakdown=p0;
                      });
                    },
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
                      maxCrossAxisExtent: 250,
                      mainAxisExtent: 100,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: stageBreakdown.keys.length,
                    itemBuilder: (context, index) =>  LevelMiniCard(
                        level: stageBreakdown.keys.elementAt(index),
                      count: stageBreakdown.values.elementAt(index),
                      isWildlife: HiveProvider.appBox.get('type')=='wildlife',
                    ),
                  )
                  else Text('Fill out your target details to get started'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CentralStatsCard extends StatefulWidget {
  const CentralStatsCard({super.key, required this.onSubmit,});
  final Function(Map<int,int>) onSubmit;

  @override
  State<CentralStatsCard> createState() => _CentralStatsCardState();
}

class _CentralStatsCardState extends State<CentralStatsCard> {
  TargetItem? targetItem;
  TextEditingController chainController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController stageController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 20)],
      ),
      child: targetItem==null?Column(
        children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child:ValueListenableBuilder(
               valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
               builder: (context,data,_) {
                 bool isWildlife=data.get('type')=='wildlife';
                if(isWildlife){
                  chainController.text='Wildlife';
                }
                else {
                  chainController.clear();
                }
                return isWildlife?TextField(
                 decoration: InputDecoration(
                   hintText: 'Enter ${isWildlife?'Wildlife' : 'Chain'} Name',
                   labelText: '${isWildlife?'Wildlife' : 'Chain'} Name',
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15.0),
                   ),
                 ),
                 readOnly: isWildlife,
                 controller: chainController,
               ): Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return chains.map((e) => e['name'].toString(),).where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    print('You selected: $selection');
                    // Save selection to your state
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Chain Name',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                );
             }
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: TextField(
             decoration: InputDecoration(
               hintText: 'Enter stage of target item',
               labelText: 'Target Stage',
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(15.0),
               ),
             ),
             controller: stageController,
           ),
         ),
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
          const SizedBox(height: 20),
          TextButton(
            onPressed: () { setState(() {
              targetItem=TargetItem(
                  chain: chainController.text, count: int.tryParse(countController.text)??0,
                  stage: int.tryParse(stageController.text)??0
              );
            });
              widget.onSubmit(
                  HiveProvider.appBox.get('type')=='wildlife'?MergeCalculator.calculateWildlife(targetItem!.stage, targetItem!.count):
                  MergeCalculator.getFullBreakdown(targetItem!.stage, targetItem!.count)
              );
              },
            child: Text("Calculate!",
            style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold),)
          ),
        ],
      ):
      Column(
        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {
                setState(() {
                  targetItem=null;
                });
              }, icon: Icon(Icons.refresh))
            ],
          ),
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFFF0F4F0),
            child: Icon(Icons.local_florist, size: 50, color: Color(0xFF5E7356)),
          ),
          const SizedBox(height: 20),
          const Text("PROGRESS: 75%", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
           Text(
            targetItem!.chain.toString(),
            style: TextStyle(fontSize: 80, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50)),
          ),
          Text(
            "Items needed for ${targetItem!.count}  Stage  ${targetItem!.stage} items: ${MergeCalculator.totalBaseNeeded(targetItem!.stage, targetItem!.count)}",
            style: TextStyle(letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title:", style: const TextStyle(color: Colors.grey)),
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