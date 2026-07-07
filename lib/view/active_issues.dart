import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/discord_invite.dart';
final List<Map<String, String>> activeIssues = [
  {
    'title': 'Gnome Glitch',
    'description': 'Some players report technical glitches when upgrading gnomes. Upgrading results in gnomes disappearing.',
    'image': 'Stage_1_-_Garden_Gnome',
    'severity': 'Fatal',
  },
  {
    'title': 'Rita\'s Training',
    'description': 'You get only 30 mins of unlimited lives. Choose to ignore the event or use the time wisely.',
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