import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:mergewarden/utils/colors.dart';

/// A custom function to build a path for the confetti particle to follow
Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);

  // Starting point
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    // Corrected with '+' operators
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
Future<void> showCompletionDialog(BuildContext context) async {
 final  ConfettiController controllerTopCenter= ConfettiController(duration: const Duration(seconds: 1));
  // 4. Fire the confetti right away
  controllerTopCenter.play();
 ScaffoldMessenger.of(context).showSnackBar( SnackBar(
   backgroundColor: Colors.white,
     content: Stack(
   alignment: Alignment.center,
   children: [
     // --- THE CONFETTI LAYER ---
     ConfettiWidget(
       confettiController: controllerTopCenter,
       blastDirectionality: BlastDirectionality.explosive,
       blastDirection: pi*2,
       shouldLoop: false, // only play once
       colors: const [
         Colors.green,
         Colors.blue,
         Colors.pink,
         Colors.orange,
         Colors.purple
       ], // manually specify colors
       createParticlePath: drawStar, // custom particle shape
       gravity: 0.2, // how fast it falls (0.0 to 1.0)
       emissionFrequency: 0.1, // how often new particles are made
       numberOfParticles: 20, // number per emission
       maxBlastForce: 20, // how far they spread
       minBlastForce: 5,
     ),

     // --- THE ACTUAL DIALOG LAYER ---
     Row(
       children: [
         Icon(Icons.check_circle, color: cCard),
         SizedBox(width: 10),
         Text("Goal Complete / Achievable!", style: TextStyle(fontWeight: FontWeight.bold,color: cCard)),
       ],
     ),
   ],
 )));
  // await showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         // --- THE CONFETTI LAYER ---
  //         ConfettiWidget(
  //           confettiController: controllerTopCenter,
  //           blastDirectionality: BlastDirectionality.explosive, // radiate outwards
  //           shouldLoop: false, // only play once
  //           colors: const [
  //             Colors.green,
  //             Colors.blue,
  //             Colors.pink,
  //             Colors.orange,
  //             Colors.purple
  //           ], // manually specify colors
  //           createParticlePath: drawStar, // custom particle shape
  //           gravity: 0.2, // how fast it falls (0.0 to 1.0)
  //           emissionFrequency: 0.1, // how often new particles are made
  //           numberOfParticles: 20, // number per emission
  //           maxBlastForce: 20, // how far they spread
  //           minBlastForce: 5,
  //         ),
  //
  //         // --- THE ACTUAL DIALOG LAYER ---
  //         AlertDialog(
  //           backgroundColor: cBackground, // Your Merge Gardens Green
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           content: Row(
  //             children: [
  //               Icon(Icons.check_circle, color: cCard),
  //               SizedBox(width: 10),
  //               Text("Goal Complete / Achievable!", style: TextStyle(fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 backgroundColor: cCard,
  //               ),
  //               onPressed: () {
  //                 controllerTopCenter.stop(); // Stop the blasting if still active
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text("AWESOME", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold,)),
  //             ),
  //           ],
  //         ),
  //       ],
  //     );
  //   },
  // );

}