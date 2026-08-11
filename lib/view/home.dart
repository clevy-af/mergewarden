import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/utils/strings.dart';
import 'package:mergewarden/view/active_issues.dart';
import 'package:mergewarden/view/bug_report.dart';
import 'package:mergewarden/view/calculator/calculator_screen.dart';
import 'package:mergewarden/view/components/goal_card.dart';
import 'package:mergewarden/view/discord_invite.dart';
import 'package:mergewarden/view/ledger/discovery_page.dart';
import 'package:mergewarden/view/version_number_and_caching.dart';
import 'package:mergewarden/view/ledger/animated_stack.dart';
import 'package:mergewarden/view/whats_new.dart';
import 'package:web/web.dart' as web;

enum Destinations{calculator,goals,ledger,discovery}
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Destinations _selectedPage;

  late BuildContext scaffoldContext;

  void onChangedDestination(int index){
    HiveProvider.appBox.put('homepage',index);
    var destination = Destinations.values.elementAt(index);
    setState(() {
      _selectedPage=destination;
    });
    HiveProvider.appBox.put('chain', null);

    if(destination==Destinations.goals&&HiveProvider.goals.keys.isNotEmpty) {
      HiveProvider.appBox.put('goalIndex', HiveProvider.goals.keys.first);
      // print('home');
    }
  }

  Widget  get navigationRail => NavigationLine(
      index: _selectedPage.index,
      onChanged: onChangedDestination,
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
      appBar: context.isDesktop||HiveProvider.session.get('isExporting')==true?null: AppBar(
        backgroundColor: cCard,
        leading: Builder(
        builder: (context) {
          return IconButton(onPressed: () {
            Scaffold.of(context).openDrawer();
          } , icon:Icon( Icons.menu));
        }
      ),
      actions: [
        Builder(
          builder: (context) {
            return ActiveIssueButton(scaffoldContext: context,);
          }
        )
      ],
      title: TextLogo(),

      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sidebar
          if(context.isDesktop) navigationRail,

            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    // width:MediaQuery.of(context).size.width*0.9 ,
                    padding:  EdgeInsets.symmetric(horizontal: context.isDesktop?MediaQuery.of(context).size.width*0.05:0),

                    child:Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: AssetCacheBanner()),
                          ],
                        ),
                        Expanded(
                          child: [
                            CalculatorScreen(),
                            GoalScreenView(),
                            SandwichStack(),
                            ChroniclesPage(),
                            // LedgerPage(),
                          ][_selectedPage.index],
                        ),
                      ],
                    ),
                  ),
                  if(context.isDesktop)  Positioned(
                    top:0,
                    right: 0,
                    child: Builder(
                        builder: (context) {
                          return ActiveIssueButton(scaffoldContext: context,);
                        }
                    ),
                  ),

                ],
              ),
            ),
        ],
      ),
      endDrawer: Drawer(

          child: ActiveIssuesDrawer()
      ),
    );
  }
}

class ActiveIssueButton extends StatelessWidget {
  const ActiveIssueButton({
    super.key, required this.scaffoldContext,
  });
  final BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    if(activeIssues.isNotEmpty) {
      return IconButton(
            tooltip: 'MG Active Issues',
              onPressed: () {
            Scaffold.of(scaffoldContext).openEndDrawer();
          } , icon:Row(
            children: [
              Icon( Icons.running_with_errors,color: cRed,),
              Container(
                  decoration:BoxDecoration(color: cRed,borderRadius: BorderRadius.circular(15)),
                  padding:EdgeInsets.symmetric(horizontal: 3),
                child: Text(activeIssues.length.toString(),style: TextStyle(color: Colors.white),),
              )
            ],
          ));
    }
    return SizedBox();
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
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: AssetImage('assets/logo.webp'))
              ),
              height: 60,width: 60,
            ),
            VersionNumber(),
            //
            // LinkButton(
            //   link: 'https://futureplaygames.zendesk.com/hc/en-us/categories/360002343379-Merge-Gardens',
            //   text: 'Futureplay',
            // ),
            // LinkButton(
            //   link: 'https://mergegardens.com/',
            //   text: 'Website',
            // ),
            // LinkButton(
            //   link: 'https://merge-gardens.fandom.com/wiki/Merge_Gardens_Wiki',
            //   text: 'Wiki',
            // ),
            // LinkButton(
            //   link: 'https://store.mergegardens.com/en/',
            //   text: 'Web Store',
            // ),
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
          icon: Icon(Icons.format_list_numbered),
          label: Text('Goals',style: TextStyle(color: Colors.white),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.book),
          label: Text('Ledger',style: TextStyle(color: Colors.white),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.yard_outlined),
          label: Text('Chronicles',style: TextStyle(color: Colors.white),),
        ),

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
              onPressed: ()=>DiscordInviteButton().showDiscordPopup(context),
              child: Text('Discord Server',style: TextStyle(color: cCreme),)
          ),
          ValueListenableBuilder(
            valueListenable: HiveProvider.session.listenable(keys: ['app_update']),
            builder: (context,data,_) {
              return TextButton(
                  onPressed: () => showAdaptiveDialog(context: context,
                    barrierDismissible: true,
                    builder: (context) => Center(child: ChangelogPage()),),
                  child: Stack(
                    alignment: AlignmentGeometry.topRight,
                    children: [
                      Text('Changelog',style: TextStyle(color: cCreme),),
                    if(data.toMap()['app_update']==true)  Icon(Icons.new_releases_outlined,color: cRed,),
                    ],
                  )
              );
            }
          ),
        ],
      ),
      selectedIndex: index,
      trailingAtBottom: true,
      onDestinationSelected: (value) {
        onChanged(value);
        HiveProvider.session.delete(sBreakdownKey);
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
    return  Text.rich(TextSpan(
      text: 'Merge Warden,\t',
      style: TextStyle(fontFamily: 'Waterfall',fontSize: 40),
      children:[
        TextSpan(
          text: 'for Merge Gardens.',
          style: TextStyle(
            fontWeight: FontWeight.normal,fontSize: MediaQuery.of(context).size.width*(0.016),

          ),
        ),
      ],
    ),
      style: TextStyle(fontSize: MediaQuery.of(context).size.width*(isDesktop?0.02:0.04),fontWeight: FontWeight.bold),
      maxLines: 3,
      textAlign: TextAlign.right,
      softWrap: true,
    );
  }
}