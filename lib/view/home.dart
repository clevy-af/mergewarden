import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/goals.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:web/web.dart' as web;

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
  List<Breakup> stageBreakdown=[

  ];
  // Map<int,int> stageBreakdown={5: 2, 4: 5, 3: 13, 2: 33, 1: 83, 0: 208};

  Widget get navigationRail => NavigationRail(
    backgroundColor: cCard,
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        if(!isDesktop)Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CloseButton(color: Colors.black,)
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: AssetImage('assets/mg_logo.jpeg'))
          ),
          height: 80,width: 80,
        ),
        TextButton(
          onPressed: () => web.window.open('https://futureplaygames.zendesk.com/hc/en-us/categories/360002343379-Merge-Gardens'),
          child: Text('Futureplay',style: TextStyle(color: Colors.white),),
        ),
        TextButton(
          onPressed: () => web.window.open('https://mergegardens.com/'),
          child: Text('Website',style: TextStyle(color: Colors.white),),
        ),
        TextButton(
          onPressed: () => web.window.open('https://merge-gardens.fandom.com/wiki/Merge_Gardens_Wiki'),
          child: Text('Wiki',style: TextStyle(color: Colors.white),),
        ),
        TextButton(
          onPressed: () => web.window.open('https://store.mergegardens.com/en/'),
          child: Text('Web Store',style: TextStyle(color: Colors.white),),
        ),

        Container(
          padding: const EdgeInsets.all(8.0),
          width: 88,
          child: Divider(color: Colors.white,thickness: 1,endIndent: 5,indent: 5,),
        ),
      ],
    ),
  ),
  labelType: NavigationRailLabelType.all,
  destinations: [
    NavigationRailDestination(
        icon: Icon(Icons.calculate),
      label: Text('Calculator',style: TextStyle(color: Colors.white),),
    ),
    // NavigationRailDestination(
    //     icon: Icon(Icons.track_changes),
    //   label: Text('Goals',style: TextStyle(color: Colors.white),),
    // ),

  ],
  selectedIndex: _selectedIndex,
    onDestinationSelected: (value) => setState(() {
      _selectedIndex=value;
    }),
  );


  bool get isDesktop=>MediaQuery.of(context).size.width>500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      drawer: isDesktop?null:Drawer(
        width: max(MediaQuery.of(context).size.width/3,200),
          child: navigationRail,
      ),
      appBar: isDesktop?null: AppBar(
        backgroundColor: cCard,
        leading: Builder(
        builder: (context) {
          return IconButton(onPressed: () {
            Scaffold.of(context).openDrawer();
          } , icon:Icon( Icons.menu));
        }
      ),),
      body: Row(
        children: [
          // Sidebar
          if(isDesktop) navigationRail,
          // if(isDesktop) const VerticalDivider(thickness: 1, width: 1),

          // Main Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
              child: [
                Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextLogo(),
                      const SizedBox(width: 20),
                      Padding(
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
                      ),
                       Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:ValueListenableBuilder(
                            valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                            builder: (context,data,_) {
                            return ActionChip(
                              tooltip: 'Wildlife Calculator',
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
                        // print(p0);
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  // Levels Grid
                  const Text("REQUIRED ITEMS BY LEVEL", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  if(stageBreakdown.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      mainAxisExtent: 180,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: stageBreakdown.length,
                    itemBuilder: (context, index) =>  LevelCard(
                        level: stageBreakdown.elementAt(index).stage,
                        potions: stageBreakdown.elementAt(index).potionsUsed,
                      count: stageBreakdown.elementAt(index).count,
                      chainId: HiveProvider.appBox.get('chain'),
                      isWildlife: HiveProvider.appBox.get('type')=='wildlife',
                    ),
                  )
                  else Text('Fill out your target details to get started'),
                ],
              ),
                GoalsPage(stageBreakdown: {}),
              ][_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}


class TextLogo extends StatelessWidget {
  const TextLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(TextSpan(
          text: 'Merge Warden\n',
          children:[
            TextSpan(
              text: 'for Merge Gardens.',
              style: TextStyle(
                  fontWeight: FontWeight.normal,fontSize: MediaQuery.of(context).size.width*0.01,

              ),
            ),
          ]
        ),
          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.02,fontWeight: FontWeight.bold),
          maxLines: 3,
          textAlign: TextAlign.right,
          softWrap: true,
        ),
      ],
    );
  }
}

