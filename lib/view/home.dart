import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/dummies.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/goal_screen.dart';
import 'package:web/web.dart' as web;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;
  List<Breakup> stageBreakdown=[];
  // List<Breakup> stageBreakdown=[
  //   Breakup(stage: 5, count: 2, potionsUsed: 0),
  //   Breakup(stage: 4, count: 5, potionsUsed: 0),
  //   Breakup(stage: 3, count: 13, potionsUsed: 0),
  //   Breakup(stage: 2, count: 33, potionsUsed: 0),
  //   Breakup(stage: 0, count: 208, potionsUsed: 0),
  // ];

  Widget get navigationRail => NavigationRail(
    backgroundColor: cCard,
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        if(!context.isDesktop)Row(
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
    NavigationRailDestination(
        icon: Icon(Icons.track_changes),
      label: Text('Goals',style: TextStyle(color: Colors.white),),
    ),

  ],
  selectedIndex: _selectedIndex,
    onDestinationSelected: (value) => setState(() {
      _selectedIndex=value;
    }),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      drawer: context.isDesktop?null:Drawer(
        width: max(MediaQuery.of(context).size.width/3,200),
          child: navigationRail,
      ),
      appBar: context.isDesktop?null: AppBar(
        backgroundColor: cCard,
        leading: Builder(
        builder: (context) {
          return IconButton(onPressed: () {
            Scaffold.of(context).openDrawer();
          } , icon:Icon( Icons.menu));
        }
      ),
      title: TextLogo(),

      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sidebar
          if(context.isDesktop) navigationRail,

            Container(
              height: MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width*0.9 ,
              padding:  EdgeInsets.symmetric(horizontal: context.isDesktop?MediaQuery.of(context).size.width*0.1:0),

              child:[
                CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if(context.isDesktop)  TextLogo(),
                          if(context.isDesktop) const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder(
                                valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                                builder: (context,data,_) {
                                  return ActionChip(
                                      tooltip: 'Items Calculator',
                                      side: data.get('type')=='items'?BorderSide(color: cCard,width: 2):null,
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
                                    side: data.get('type')=='wildlife'?BorderSide(color: cCard,width: 2):null,
                                    onPressed: () async => await  HiveProvider.appBox.put('type', 'wildlife'),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                  ),
                  // Central Progress Card
                  SliverToBoxAdapter(

                    child:  Padding(
                      padding: EdgeInsets.symmetric(horizontal:context.isDesktop?MediaQuery.of(context).size.width*0.15:18),
                      child: CentralStatsCard(
                        onSubmit: (p0) {
                          setState(() {
                            stageBreakdown=p0;
                            // print(p0);
                          });
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                  ),

                                    // Levels Grid
                  SliverToBoxAdapter(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text("REQUIRED ITEMS BY LEVEL", style: TextStyle(fontWeight: FontWeight.bold)),
                  )),
                  SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: stageBreakdown.isNotEmpty?
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
                                        : Text('Fill out your target details to get started'),
                                      ),
                                    ),
                ],
              ),
                TargetGoalScreen(
                  stageBreakdown: {6:6,5: 2, 4: 5, 3: 13, 2: 33, 1: 83, 0: 208},
                  targetItem: TargetItem(count: 2, stage: 4,
                      name: chainItems[chains.first['id']]?.firstWhere((element) => element['stage']==4,)['name'],
                      chain: chains.first['id']),
                ),
              ][_selectedIndex],
            ),
        ],
      ),
    );
  }
}

class CalculatorSwitch extends StatefulWidget {
  const CalculatorSwitch({
    super.key,
  });

  @override
  State<CalculatorSwitch> createState() => _CalculatorSwitchState();
}

class _CalculatorSwitchState extends State<CalculatorSwitch> {
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context,value,_) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () => valueNotifier.value=!value,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: value?Color(0xffD7B494):cBrown,strokeAlign: 0.5,width: 3),
              visualDensity: VisualDensity(),
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
              maximumSize: Size.fromWidth(kMinInteractiveDimension*3)
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: kMinInteractiveDimension/2,
                  backgroundImage:AssetImage('${ value?'wildlife':'book'}.webp') ,
                ),
                SizedBox(width: 8,),
                Text(value?'Wildlife':'Items',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        );
      }
    );
  }
}


class TextLogo extends StatelessWidget {
  const TextLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop=MediaQuery.of(context).size.width>500;
    return Row(
      children: [
        Text.rich(TextSpan(
          text: 'Merge Warden\n',
          children:[
            TextSpan(
              text: 'for Merge Gardens.',
              style: TextStyle(
                  fontWeight: FontWeight.normal,fontSize: MediaQuery.of(context).size.width*(isDesktop?0.01:0.02),

              ),
            ),
          ],
        ),
          style: TextStyle(fontSize: MediaQuery.of(context).size.width*(isDesktop?0.02:0.04),fontWeight: FontWeight.bold),
          maxLines: 3,
          textAlign: TextAlign.right,
          softWrap: true,
        ),
      ],
    );
  }
}