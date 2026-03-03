
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/target_item.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/home.dart';

import 'components/stat_card.dart';

class TargetGoalScreen extends StatelessWidget {
  const TargetGoalScreen({super.key, required this.stageBreakdown, required this.targetItem});
  final Map<int, int> stageBreakdown;
  final TargetItem targetItem;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              children: [
                if(context.isDesktop)TextLogo(),
                if(context.isDesktop) SizedBox(width: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*(context.isDesktop?0.5:0.8),
                  height: kMinInteractiveDimension,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(width: 8,),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ActionChip(
                        tooltip: 'Items Calculator',
                        side: BorderSide(color: cCard,width: 2),
                        onPressed: () async {
                          await  HiveProvider.appBox.put('type', 'items');
                          await  HiveProvider.appBox.put('chain', null);
                        },
                        label: Text('Items')
                    ),
                  itemCount: 5,),
                )
              ],
            ),
            const SizedBox(height: 10),
            _buildHeader("TARGET GOAL"),
            const SizedBox(height: 20),
            _buildMainProgressCard(context),
            const SizedBox(height: 20),
            _buildHeader("Inventory".toUpperCase()),
            const SizedBox(height: 20),
             ListView.separated(
             shrinkWrap: true,
             physics:const NeverScrollableScrollPhysics(),
             separatorBuilder: (context, index) => Padding(
               padding: const EdgeInsets.all(8.0),
               child: Divider(height: 1,),
             ),
             itemCount:5,// stageBreakdown.keys.length,
             itemBuilder: (context, index) =>  InventoryCard(
               level: stageBreakdown.keys.elementAt(index),
               count: stageBreakdown.values.elementAt(index),
               chainId: HiveProvider.appBox.get('chain')??'Coins',
               isWildlife: HiveProvider.appBox.get('type')=='wildlife',
               potions: 0,
             ),
                       ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF2D3E2D),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMainProgressCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // margin:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(targetItem.name!=null)
                Semantics(
                  label: 'Merge Gardens Calculation Target Item',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    // margin: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height*0.2,
                    width:MediaQuery.of(context).size.height*0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cCard,
                      // boxShadow: [
                      //   BoxShadow(color: cCard,blurRadius: 3,spreadRadius: 3)
                      // ],
                      image: DecorationImage(
                          image: AssetImage('assets/Stage_${targetItem.stage}_-_${targetItem.name?.replaceAll(' ', '_')}.webp'),
                          fit: BoxFit.contain
                      ),
                    ),
                  ),
                ),
              SizedBox(
                width: 20,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Merge Gardens Calculation Target Text',
                    child: Text(
                      'Stage ${targetItem.stage}',
                      style: TextStyle(fontSize: context.isDesktop?20:15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height:  10,
                  ),
                  Semantics(
                    label: 'Merge Gardens Calculation Target Text',
                    child: Text(
                      (targetItem.name??targetItem.chain).toString(),
                      style: TextStyle(fontSize: context.isDesktop?40:30, fontWeight: FontWeight.w200, color: Color(0xFF2C3E50)),
                    ),
                  ),
                ],
              ),

            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(height: 1,),
          ),
          Semantics(
            label: 'Merge Gardens Calculation Target Text',
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
               '30% Complete'.toString(),
                style: TextStyle(fontSize: context.isDesktop?20:15, fontWeight: FontWeight.w200, color: cCard),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key, required this.iconData,
  });
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 32,
      // height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF6B8E6B).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(iconData),
    );
  }
}