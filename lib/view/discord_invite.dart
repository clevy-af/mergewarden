import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mergewarden/model/secrets.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:web/web.dart' as web;

/// A Text Button that launches the stylized Merge Warden Discord Invitation Portal.
class DiscordInviteButton extends StatelessWidget {

  const DiscordInviteButton({super.key});

  void showDiscordPopup(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          constraints: BoxConstraints(maxWidth: min(450,context.screenSize.width*0.5)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Theme Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: cCard,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        SizedBox(width: kMinInteractiveDimension,),
                        Image.asset('outpost.png', height: 50,width: 50,),
                        CloseButton(),
                      ],),

                      const SizedBox(height: 8),
                      const Text(
                        "MERGE WARDEN OUTPOST",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "The Official Community Conservatory",
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

                // Portal Description Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        "Step through the portal into our community conservatory! The Outpost is where players and the developer gather to cultivate the ultimate experience for the gardener community.",
                        style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 20),

                      // Landmark Features
                      _buildFeatureRow(Icons.rule,Colors.brown, "The Warden's Code", "Decent, organized spaces managed by Guards."),//"📜",
                      _buildFeatureRow(Icons.info_outlined,Colors.blue, "Crowdsourced Ledgers", "Contribute to every bit of information from prices to loots, directly to our database."),//"🗃️",
                      _buildFeatureRow(Icons.science_outlined, Colors.green, "Mutation Watcher Feeds", "Get real-time patch updates, new releases, and suggest changes direct from/to the engineering soil."),//"🔬",
                      _buildFeatureRow(Icons.notifications_on_outlined,Colors.amber,"Notifications", "Get real-time updates on game alerts not provided by MG, managed by Warden caretaker."),//"🔔",

                      const SizedBox(height: 15),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Stay here", style: TextStyle(color: Colors.black54)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () async => web.window.open(discordUrl),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff5865F2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text("Enter Outpost"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(IconData icon,Color color, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,size: 20,color: color,),
          // Text(emoji, style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B4D3E))),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showDiscordPopup(context),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF1B4D3E),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.forum_outlined, size: 18),
      label: const Text(
        "Join our Discord Outpost",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, decoration: TextDecoration.underline),
      ),
    );
  }
}