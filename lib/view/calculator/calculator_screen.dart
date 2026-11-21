import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/utils/strings.dart';
import 'package:mergewarden/view/components/stat_card.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({
    super.key, this.data,
  });
  final CalculateMe? data;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [

        // Central Progress Card
        SliverToBoxAdapter(
          child:  CentralStatsCard(data: data,),
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
                valueListenable: HiveProvider.session.listenable(keys: [sBreakdownKey,]),
                builder: (context, value, child) {
                  final List data=value.get(sBreakdownKey)??[];
                  final chainId=HiveProvider.appBox.get('chain');
                  if(data.isEmpty) return  Text('Fill out your target details to get started');
                  var isWildlife = HiveProvider.appBox.get('type')=='wildlife';
                  final double boxSize = chainId!=null?170:120;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: boxSize,
                      mainAxisExtent: boxSize,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return LevelCard(
                        level: data.elementAt(index)['stage'],
                        potions: data.elementAt(index)['potions'],
                        count: data.elementAt(index)['count'],
                        chainId: chainId,
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
