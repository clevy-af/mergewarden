import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class AssetCacheBanner extends StatefulWidget {
  const AssetCacheBanner({super.key,});

  @override
  State<AssetCacheBanner> createState() => _AssetCacheBannerState();
}

class _AssetCacheBannerState extends State<AssetCacheBanner> {
  bool _isVisible = false;
  bool _isCaching = false;

  @override
  void initState() {
    _isVisible=!(HiveProvider.appBox.get('has_preloaded_assets')??false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0,top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        // A muted, elegant red that matches your green theme without being jarring
        color: const Color(0xFFD32F2F).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD32F2F).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Color(0xFFD32F2F)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pre-load Images?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isCaching
                      ? 'Caching images for offline use... Please wait.'
                      : 'Cache all items and wildlife images now for a smoother, offline-ready experience. Otherwise, they will load on-demand when online.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isCaching)
                TextButton(
                  onPressed: _handleCacheChoice,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Pre-load All'),
                ),
              if (_isCaching)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
                  ),
                ),
              // Close button disappears during caching
              if (!_isCaching) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isVisible = false;
                    });
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleCacheChoice() async {
    setState(() {
      _isCaching = true;
    });

    // Trigger your asset pre-loading logic
    await _downloadAssetsAndWipeOld();

    // Persist the choice to local storage
   HiveProvider.appBox.put('has_preloaded_assets', true);
    setState(() {
      _isCaching = false;
    });
    Future.delayed(Durations.long1,() {
      setState(() {
      _isVisible = false;
      });
    },);
  }


  Future<List<String>> _getImageAssets() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return assetManifest
        .listAssets()
        .where((String key) => key.endsWith('.webp'))
        .toList();
  }

  Future<void> _downloadAssetsAndWipeOld() async {
    // setState(() {
    //   _isDownloading = true;
    // });
    print('downloading');
    String currentVersion= HiveProvider.appBox.get('current_version')??'1';

    try {
      final String currentCacheName = 'flutter-assets-cache-v$currentVersion';

      // 1. Wipe Old caches to maintain browser storage health
      final caches = web.window.caches;
      final JSArray keysJS = await caches.keys().toDart;
      final List<dynamic> cacheKeys = keysJS.toDart;
      for (var key in cacheKeys) {
        if (key.toString().startsWith('flutter-assets-cache-') && key.toString() != currentCacheName) {
          await caches.delete(key.toString()).toDart;
        }
      }

      // 2. Fetch and Cache assets looping dynamically
      final List<String> images = await _getImageAssets();
      var totalFiles = images.length;
      print({'_totalFiles':totalFiles});
      final cacheJSObject = await caches.open(currentCacheName).toDart;
      final cache = cacheJSObject;
      await Future.delayed(Duration(seconds: 1));
      for (int i = 0; i < images.length; i++) {
        // setState(() { _currentIndex = i + 1; });
        final String correctedWebPath = 'assets/${images[i]}';
        try {
          await cache.add(correctedWebPath.toJS).toDart;
        } catch (_) {}
      }

      print({'cached':(await cache.keys().toDart).length});

    } catch (e) {}
    setState(() {
      _isVisible = true;
    });
  }
}

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
      print(e);
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
