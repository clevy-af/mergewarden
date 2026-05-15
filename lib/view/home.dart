import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/calculator.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/bug_report.dart';
import 'package:mergewarden/view/components/goal_card.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/whats_new.dart';
import 'package:web/web.dart' as web;

enum Destinations{calculator,goals}
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Destinations _selectedPage;

  late BuildContext scaffoldContext;

  Widget  get navigationRail => NavigationLine(
      index: _selectedPage.index,
      onChanged: (value) {
        HiveProvider.appBox.put('homepage',value);
    var destinations = Destinations.values.elementAt(value);
        setState(() {
    _selectedPage=destinations;
  });
        HiveProvider.appBox.put('chain', null);

        if(destinations==Destinations.goals&&HiveProvider.goals.keys.isNotEmpty) {
          HiveProvider.appBox.put('goalIndex', HiveProvider.goals.keys.first);
          // print('home');
        }
      },
  );

  @override
  void initState() {
    _selectedPage = Destinations.values.elementAt(HiveProvider.appBox.get('homepage')??0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext=context;
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

            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                // width:MediaQuery.of(context).size.width*0.9 ,
                padding:  EdgeInsets.symmetric(horizontal: context.isDesktop?MediaQuery.of(context).size.width*0.05:0),

                child:[
                  CalculatorScreen(),
                  GoalScreenView(),
                ][_selectedPage.index],
              ),
            ),
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
    slivers: [

      // Central Progress Card
      SliverToBoxAdapter(

        child:  CentralStatsCard(),
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
                            child: ValueListenableBuilder(
                              valueListenable: HiveProvider.appBox.listenable(keys: ['breakdown','chain','type']),
                              builder: (context, value, child) {
                                final List data=value.get('breakdown')??[];
                                if(data.isEmpty) return  Text('Fill out your target details to get started');
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 180,
                                    mainAxisExtent: 180,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    var isWildlife = value.get('type')=='wildlife';
                                    return LevelCard(
                                      level: data.elementAt(index)['stage'],
                                      potions: data.elementAt(index)['potions'],
                                    count: data.elementAt(index)['count'],
                                    chainId: value.get('chain')?.toString().replaceAll(' ', isWildlife?'':'_'),
                                    isWildlife: isWildlife,
                                  );
                                  },
                                );
                              }
                            ),
                          ),
                        ),
    ],
                    );
  }
}

class GoalScreenView extends StatefulWidget {
  const GoalScreenView({
    super.key,
  });

  @override
  State<GoalScreenView> createState() => _GoalScreenViewState();
}

class _GoalScreenViewState extends State<GoalScreenView> {
  List<GoalData> goals=[];
  GoalData? activeGoal;

  @override
  void initState() {

    HiveProvider.goals.toMap().values.map((value) {
      goals.add(GoalData.fromJson(value));
    },).toList();
    if(goals.isNotEmpty) activeGoal=goals.first;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // print(activeGoal);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if(context.isDesktop)TextLogo(),
                if(context.isDesktop) SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    height: kMinInteractiveDimension,
                    child: ListView.separated(
                      shrinkWrap: true,
                      key: ObjectKey(goals),
                      separatorBuilder: (context, index) => SizedBox(width: 8,),
                      scrollDirection: Axis.horizontal,
                      itemCount: goals.length,
                      itemBuilder: (context, index) => ActionChip(
                          tooltip: 'Goal Item ${index+1}',
                          side:goals.elementAt(index).uid==activeGoal?.uid? BorderSide(color: cCard,width: 2):null,
                          onPressed: () {
                            setState(() {
                            activeGoal=goals.elementAt(index);
                            });
                          },
                          label: Text(goals.elementAt(index).targetItem.stageName??'Item  ${index+1}')
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
        ),
        // Central Progress Card
        SliverToBoxAdapter(
          child:  Container(
            alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: CentralGoalCard(
            onUpdate: (Map<int,int>p0) {
              // print(p0);
                TargetItem target=activeGoal!.targetItem;
                bool showConfetti=false;
              for (var element in p0.entries) {
                List<Breakup> list=target.isWildlife?MergeCalculator.calculateWildlife(element.key, element.value,false):MergeCalculator.getFullBreakdown(element.key, element.value,activeGoal!.potions,target.has0,false);

                // print(list);
                for (var element in list) {
                 int x= activeGoal!.inventory.indexWhere((e) => element.stage==e.stage,);
                 if(x.isNegative) continue;
                   activeGoal!.inventory[x].have+=element.count;
                   if(activeGoal!.inventory[x].have>=activeGoal!.inventory[x].count){
                  showConfetti=true;
                   }
                }
              }
                final highest=(p0.keys.reduce(max));
              Map<int,int> maxLevels=MergeCalculator.calculateMaxReachStat(
                  {highest:activeGoal!.inventoryMap()[highest]??0},merge5Only:activeGoal!.targetItem.merge5);
              // maxLevels.entries.toList().sort((a, b) => a.key.compareTo(b.key),);
              // print(maxLevels);

              // for(var element in p0.entries){
              //   maxLevels.remove(highest);
              // }

                for (var element in  maxLevels.entries) {

                  int x= activeGoal!.inventory.indexWhere((e) => element.key==e.stage,);
                  if(x.isNegative) continue;
                  activeGoal!.inventory[x].have=element.value;
                  if(activeGoal!.inventory[x].have>=activeGoal!.inventory[x].count){
                    showConfetti=true;
                  } }



              HiveProvider.goals.put(activeGoal!.uid,activeGoal!.toJson());

                int update=goals.indexWhere((element) => element.uid==activeGoal?.uid,);
                if(update.isNegative) return false;
              setState(() {
                goals[update]=activeGoal!;
              });
              return showConfetti;
              // if(showConfetti) showCompletionDialog(context);
            },
            onReset: () {
              GoalData goal=activeGoal!;
              for (var element in goal.inventory) {
                element.have=0;
              }
              HiveProvider.goals.put(goal.uid,goal.toJson());
                int update=goals.indexWhere((element) => element.uid==activeGoal?.uid,);
                if(update.isNegative) return;
              setState(() {
                activeGoal=goals[update]=goal;
              });
            },
            goalData:activeGoal,
            key: ObjectKey(activeGoal),
            onDelete: () {
              HiveProvider.goals.delete(activeGoal?.uid);
              setState(() {
                goals.removeWhere((element) => element.uid==activeGoal?.uid,);
                if(goals.isNotEmpty) {
                  activeGoal=goals.first;
                }
                else {
                  activeGoal=null;
                }
              });
              // print('deleted');
            },
          )
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
        ),
        SliverToBoxAdapter(
          child:  Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Required per Level".toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:activeGoal==null?Text('Nothing to show for now'):
            Builder(
                builder: (context) {

                  return ListView.separated(
                    key: ObjectKey(activeGoal!.inventorySorted),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 8,),
                    itemCount:activeGoal!.inventorySorted .length,
                    itemBuilder: (context, index) =>  GoalLevelCard(
                      isWildlife: activeGoal!.targetItem.isWildlife,
                      key: ValueKey(activeGoal!.inventorySorted[index]),
                    inventory: activeGoal!.inventorySorted[index],
                      chainId: activeGoal!.targetItem.chainId,
                    ),
                  );

                }
            ),
          ),
        ),
      ],
    );

    // return ValueListenableBuilder(
    //     valueListenable: HiveProvider.appBox.listenable(keys: ['goalIndex']),
    //     builder: (context, value, child) {
    //       int? index=value.get('goalIndex');
    //       // print(index);
    //       return CustomScrollView(
    //       slivers: [
    //
    //         // Central Progress Card
    //         SliverToBoxAdapter(
    //           child:  Center(child: CentralGoalCard(currentIndex: index,)),
    //         ),
    //         SliverPadding(
    //           padding: EdgeInsetsGeometry.symmetric(vertical: 10),
    //         ),
    //         SliverToBoxAdapter(
    //           child: const Text(
    //             "Required by Level",
    //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black),
    //           ),
    //         ),
    //         SliverToBoxAdapter(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child:index==null||HiveProvider.goals.isEmpty||!HiveProvider.goals.keys.contains(index)?Text('Fill out your target details to get started'):
    //             ValueListenableBuilder(
    //                 valueListenable: HiveProvider.appBox.listenable(keys: ['goalIndex']),
    //                 builder: (context, value, child) {
    //                   if(HiveProvider.goals.isEmpty||!HiveProvider.goals.keys.contains(index)) return  Text('Each stage stats will be shown here');
    //                   return ValueListenableBuilder(
    //                     key: ValueKey(index),
    //                     valueListenable: HiveProvider.goals.listenable(keys: [index]),
    //                     builder: (context, goalData, child) {
    //                       print(goalData.keys);
    //
    //                       var json = goalData.get(index);
    //                       if(json==null) return Text('Nothing to show');
    //                       final goalValue=GoalData.fromJson(json);
    //                       // print(goalValue.targetItem.chainId);
    //
    //                       List<Inventory> sorted=goalValue.inventory..sort((a, b) => (a.have==a.count?1:0),) ;
    //                       return ListView.separated(
    //                         key: ObjectKey(sorted),
    //                         shrinkWrap: true,
    //                         physics: const NeverScrollableScrollPhysics(),
    //                          separatorBuilder: (context, index) => SizedBox(height: 8,),
    //                         itemCount:sorted .length,
    //                         itemBuilder: (context, index) =>  GoalLevelCard(
    //                           key: ValueKey(sorted[index]),
    //                           level: sorted[index].stage,
    //                            // needed: sorted[index].count,
    //                            count: sorted[index].count,
    //                            // title:'Stage ${sorted[index].stage}',
    //                           potions: sorted[index].potions,
    //                           have: sorted[index].have,
    //                           chainId: goalValue.targetItem.chainId,
    //                           isWildlife: goalValue.targetItem.isWildlife,
    //                         ),
    //                       );
    //                     }
    //                   );
    //                 }
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   }
    // );
  }
}

class NavigationLine extends StatelessWidget {
  const NavigationLine({super.key, required this.index, required this.onChanged});
  final int index;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
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
                  image: DecorationImage(image: AssetImage('assets/logo.webp'))
              ),
              height: 60,width: 60,
            ),

            LinkButton(
              link: 'https://futureplaygames.zendesk.com/hc/en-us/categories/360002343379-Merge-Gardens',
              text: 'Futureplay',
            ),
            LinkButton(
              link: 'https://mergegardens.com/',
              text: 'Website',
            ),
            LinkButton(
              link: 'https://merge-gardens.fandom.com/wiki/Merge_Gardens_Wiki',
              text: 'Wiki',
            ),
            LinkButton(
              link: 'https://store.mergegardens.com/en/',
              text: 'Web Store',
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
      indicatorColor: cCreme,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.calculate),
          label: Text('Calculator',style: TextStyle(color: Colors.white),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.checklist_outlined),
          label: Text('Goals',style: TextStyle(color: Colors.white),),
        ),
        // NavigationRailDestination(
        //   icon: Icon(Icons.new_releases_outlined),
        //   label: Text('What\'s New',style: TextStyle(color: Colors.white),),
        // ),

      ],
      trailing:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: () => showAdaptiveDialog(context: context,
                barrierDismissible: true,
                builder: (context) => Center(
                        child: BugReportForm()
                ),
              ),
              child: Text('Report Bug',style: TextStyle(color: cCreme),)
          ),
          TextButton(
              onPressed: () => showAdaptiveDialog(context: context, builder: (context) => Center(child: ChangelogPage()),),
              child: Text('Changelog',style: TextStyle(color: cCreme),)
          ),
        ],
      ),
      selectedIndex: index,
      trailingAtBottom: true,
      onDestinationSelected: (value) {
        onChanged(value);
        HiveProvider.appBox.delete('breakdown');
        if(Scaffold.of(context).isDrawerOpen) Scaffold.of(context).closeDrawer();
      },
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key, required this.link, required this.text,
  });
  final String link;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        overlayColor: cCreme
      ),
      onPressed: () => web.window.open(link),
      child: Text(text,style: TextStyle(color: Colors.white),),
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