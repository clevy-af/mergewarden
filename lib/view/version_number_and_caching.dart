import 'package:flutter/material.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionNumber extends StatefulWidget {
  const VersionNumber({super.key});

  @override
  State<VersionNumber> createState() => _VersionNumberState();
}

class _VersionNumberState extends State<VersionNumber> {
  bool _isVisible = false;
  String _currentVersion = '';

// Check storage if the current version's graphics have already been downloaded
  Future<void> _checkVersion() async {
    PackageInfo? packageInfo;
    try {

      packageInfo = await PackageInfo.fromPlatform();
    }
    catch(e){
      // print(e);
    }
    if(packageInfo!=null) {
      _currentVersion = packageInfo.version;
      HiveProvider.appBox.put('current_version', _currentVersion);

    }

      setState(() {
        _isVisible = true;
      });
  }

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return SizedBox(
      width: kMinInteractiveDimension*2,
        child: LinearProgressIndicator(color: Colors.black,)
    );
    }
    return Text('v$_currentVersion');
  }
}
