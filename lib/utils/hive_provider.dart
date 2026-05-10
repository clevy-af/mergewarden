import 'package:hive/hive.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';

class HiveProvider {
  static Box appBox = Hive.box('app');
  static Box goals = Hive.box('goals');
  static Box form = Hive.box('adjustForm');

  void putGoal(GoalData data) =>goals.put(data.uid,data.toJson());
  dynamic getGoalBreak(String id) =>goals.get(id)['inventory'];
  void putBreakDown(List<Breakup> data) =>appBox.put('breakdown',data.map((e) => e.toJson(),).toList());
  List<Breakup> getBreakDown() =>(appBox.get('breakdown') as List?)?.map((e) => Breakup.fromJson(e),).toList()??[];
}