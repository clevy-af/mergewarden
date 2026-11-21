import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/discord_invite.dart';
final List<Map<String, String>> activeIssues = [
  {
    'title': 'Ads Glitch',
    'description': 'Some players report screen freeze when ads are viewed. No close button, black screen, only restarting fixes the game; but with loss of progress/rewards.',
    'image': 'mg_logo',
    'severity': 'Fatal',
  },
  {
    'title': 'Task Glitch',
    'description': 'Some players report technical glitches when completing daisy tasks in events. Once few completed more quests do not show up. No fix but you can contact support for rewards.',
    'image': 'mg_logo',
    'severity': 'Workaround',
  },
  {
    'title': 'Overall Lag',
    'description': 'Loading game, playing events or puzzles might incur a significant lag. Try restarting your device or playing on another device for a while.',
    'image': 'mg_logo',
    'severity': 'Workaround',
  },
];

class ActiveIssuesDrawer extends StatefulWidget {
  const ActiveIssuesDrawer({super.key});

  @override
  State<ActiveIssuesDrawer> createState() => _ActiveIssuesDrawerState();
}

class _ActiveIssuesDrawerState extends State<ActiveIssuesDrawer> {

  // Mock data for the active game issues

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: context.screenSize.width*0.4 ,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE2EBE2), // Slightly lighter/darker than your main background canvas
        border: Border(
          left: BorderSide(color: Color(0xFFC2CDC2), width: 1),
        ),
      ),
      child: _buildDrawerContent(),
    );
  }

  Widget _buildDrawerContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Game Issues',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E2C),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Scaffold.of(context).closeEndDrawer(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Keep an eye on active bugs / glitches currently affecting players, as reported on social channels.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const Text(
            'Fatal= DO NOT engage.\nWorkaround= Manageable.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const Divider(height: 24, color: Color(0xFFC2CDC2)),

          // List of Issue Cards
          Expanded(
            child: ListView.builder(
              itemCount: activeIssues.length,
              itemBuilder: (context, index) {
                final issue = activeIssues[index];
                final isHighSeverity = issue['severity'] == 'Fatal';

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFFF1F5F1), // Matches your primary clean card layout colors
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header (Image + Title + Severity Badge)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StageItemImage(assetName: issue['image'].toString(),heightValue: 30,),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    issue['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF2C3E2C),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isHighSeverity ? const Color(0xFFFFEBEE) : const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${issue['severity']}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isHighSeverity ? const Color(0xFFC62828) : const Color(0xFFEF6C00),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Card Body text
                        Text(
                          issue['description']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if( issue['fix']!=null)Container(
                          decoration: BoxDecoration(
                            color: cCard,
                            borderRadius: BorderRadius.circular(8)
                          ),
                           padding:EdgeInsets.all(5),
                          child: Text(
                            issue['fix']!,
                            style: const TextStyle(
                              fontSize: 12,
                              backgroundColor: cCard,

                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.center,
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(text: 'Join server to contribute. ',
              children: [
                TextSpan(text: 'Click here',style: TextStyle(color: cDiscord),recognizer: TapGestureRecognizer()..onTap=openDiscordLink)
              ]),
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}