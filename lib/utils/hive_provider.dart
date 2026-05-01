import 'package:hive/hive.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';

class HiveProvider {
  static Box appBox = Hive.box('app');
  static Box goals = Hive.box('goals');

  void putGoal(GoalData data) =>goals.add(data.toJson());
  dynamic getGoalBreak(int index) =>goals.getAt(index)['inventory'];
  void putBreakDown(List<Breakup> data) =>appBox.put('breakdown',data.map((e) => e.toJson(),).toList());
  List<Breakup> getBreakDown() =>(appBox.get('breakdown') as List?)?.map((e) => Breakup.fromJson(e),).toList()??[];
}