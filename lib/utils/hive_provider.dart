import 'package:hive/hive.dart';
import 'package:mergewarden/model/goal_data.dart';
import 'package:mergewarden/model/requirements.dart';
import 'package:mergewarden/utils/strings.dart';

class HiveProvider {
  static Box appBox = Hive.box('app');
  static Box goals = Hive.box('goals');
  static Box session = Hive.box('session');

  void putGoal(GoalData data) =>goals.put(data.uid,data.toJson());
  dynamic getGoalBreak(String id) =>goals.get(id)['inventory'];
  void putBreakDown(List<Breakup> data) =>session.put(sBreakdownKey,data.map((e) => e.toJson(),).toList());
  List<Breakup> getBreakDown() =>(session.get(sBreakdownKey) as List?)?.map((e) => Breakup.fromJson(e),).toList()??[];
}