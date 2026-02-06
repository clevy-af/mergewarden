import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/home.dart';

void main() async{

    WidgetsFlutterBinding.ensureInitialized();

    HiveProvider.appBox=await Hive.openBox('app');

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    return MaterialApp(
      title: 'Merge Warden',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: cBackground),

      ),
      home: const Dashboard(),
    );
  }
}


// void main() {
//   var calc = MergeCalculator();
//   int targetLevel = 10;
//   int count = 1;
//
//   print('To get $count of Level $targetLevel:');
//   print('${calc.totalBaseNeeded(targetLevel, count)} Level 0 items needed.');
// }