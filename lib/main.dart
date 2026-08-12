import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/home.dart';

void main() async{

    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    HiveProvider.appBox=await Hive.openBox('app');
    HiveProvider.goals=await Hive.openBox('goals');
    HiveProvider.session=await Hive.openBox('session');
    await HiveProvider.session.clear();
    await HiveProvider.appBox.put('type', 'items');

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
        colorScheme: ColorScheme.fromSeed(seedColor: cBackground),
      ),
      home: const Dashboard(),
    );
  }
}