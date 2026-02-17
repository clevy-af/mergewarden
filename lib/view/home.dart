import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:web/web.dart' as web;

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
  // int _selectedIndex = 0;
  Map<int,int> stageBreakdown={};

  Widget get sidebar=> Container(
    color: cCard,
    padding:  const EdgeInsets.all(8),
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: AssetImage('assets/mg_logo.jpeg'))
          ),
          height: 80,width: 80,
        ),
        SizedBox(height: 15,),
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
      ],
    ),
  );

  bool get isDesktop=>MediaQuery.of(context).size.width>500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground,
      drawer: isDesktop?null:sidebar,
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
          if(isDesktop) sidebar,
          // if(isDesktop) const VerticalDivider(thickness: 1, width: 1),

          // Main Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('mg_text.svg',height: max(MediaQuery.of(context).size.width*0.1,kMinInteractiveDimension),),
                      const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder(
                          valueListenable: HiveProvider.appBox.listenable(keys: ['type']),
                          builder: (context,data,_) {
                            return ActionChip(
                              tooltip: 'Items Calculator',
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
                              tooltip: 'Wildlife Calculator',
                                label: Text('Wildlife'),
                              side: data.get('type')=='wildlife'?BorderSide(color: Colors.green):null,
                              onPressed: () async => await  HiveProvider.appBox.put('type', 'wildlife'),
                            );
                          }
                        ),
                      ),
                      Spacer(),
                      Text('Merge Warden, for Merge Gardens.',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.01,),
                        maxLines: 3,
                        softWrap: true,
                      ),
                      const SizedBox(width: 10),

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
                      maxCrossAxisExtent: 180,
                      mainAxisExtent: 180,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: stageBreakdown.keys.length,
                    itemBuilder: (context, index) =>  LevelMiniCard(
                        level: stageBreakdown.keys.elementAt(index),
                      count: stageBreakdown.values.elementAt(index),
                      chainId: HiveProvider.appBox.get('chain'),
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

