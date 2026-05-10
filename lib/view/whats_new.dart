import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  Widget _buildComingSoon({
    required String title,
    required String brief,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cLightBackground,
        borderRadius: BorderRadius.circular(20),
        // Dashed border look
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:  Colors.lightGreen[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.lightGreen[400]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5
                    )
                ),
                const SizedBox(height: 4),
                Text(brief,
                    style: TextStyle(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cBackground,
      child: Container(
        constraints:  BoxConstraints(maxWidth: 600), // Perfect for Web
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(mainAxisAlignment:MainAxisAlignment.end,children: [CloseButton()],),

            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [

                  _buildComingSoon(brief: 'Wildlife images and up-to-date quest list!',icon: Icons.timer, title: 'What\'s Brewing?'),
                  const SizedBox(height: 20),
                  const Text("Ledger of the Keeper",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A5D4A))),
                  const SizedBox(height: 20),
                  // _buildLogEntry(
                  //   date: "April 2026",
                  //   version: "v2.1.0",
                  //   title: "The Potential Plan Update",
                  //   description: "We've added a new master calculator to see how far your current inventory can grow!",
                  //   icon: Icons.auto_awesome,
                  //   color: Colors.orangeAccent,
                  // ),
                  _buildLogEntry(
                    date: "May 2026",
                    version: "v1.6.1",
                    title: "Goals Remastered",
                    description: "Listened to feedback and made the goal updating experience better.",
                    icon: Icons.update,
                    color: Colors.cyan,
                  ),
                  _buildLogEntry(
                    date: "Apr 2026",
                    version: "v1.6.0",
                    title: "The Workbench Journal",
                    description: "Say hello to \n1.Goals: you can adjust your calculations with items you have in game or made later."
                        "\n2.Bug Reports: If you see any issues, report it back to me."
                        "\n3.Choice Memory: The website opens to where you last left from and remembers your merge5 preference too."
                        "\nAlso, the calculator engine got corroded, needed some greasing!",
                    icon: Icons.bookmark,
                    color: Colors.deepPurple,
                  ),
                  _buildLogEntry(
                    date: "Apr 2026",
                    version: "v1.5.2",
                    title: "Pest Control",
                    description: "Tongue-eating Louse caused Stage number to be replaced by stage name; found it, squished it. ",
                    icon: Icons.bug_report_outlined,
                    color: Colors.redAccent,
                  ),
                  _buildLogEntry(
                    date: "March 2026",
                    version: "v1.2.0",
                    title: "Potions & Whimsy",
                    description: "All chain items aesthetics captured. Potion addition to calculations, along with option to decide whether to include merge3 or not.",
                    icon: Icons.phone_iphone,
                    color: Colors.lightBlueAccent,
                  ),
                  _buildLogEntry(
                    date: "Feb 2026",
                    version: "v1.0.0",
                    title: "Let's Calculate",
                    description: "Initial launch of assitant platform for MG. Merge calculator tailored for MG rocked the show. Happy merging!",
                    icon: Icons.local_florist,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntry({
    required String date,
    required String version,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Timeline indicator
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              Container(
                width: 2,
                height: 100, // Fixed height or use IntrinsicHeight
                color: Colors.grey[200],
              ),
            ],
          ),
          const SizedBox(width: 16),
          // The Content Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(version, style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(date, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3E2D))),
                  const SizedBox(height: 8),
                  Text(description, style: TextStyle(color: Colors.grey[600], height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}