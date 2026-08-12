import 'dart:js_interop';
import 'dart:math';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/constants.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/info_button.dart';
import 'package:mergewarden/view/home.dart';
import 'dart:ui' as ui;
import 'package:web/web.dart' as web;

class ChroniclesPage extends StatefulWidget {
  const ChroniclesPage({super.key});

  @override
  State createState() => _ChroniclesPageState();
}

class _ChroniclesPageState extends State {

// RepaintBoundary key for capturing checklist image
  final GlobalKey _repaintKey = GlobalKey(debugLabel: 'discovery_page');
  bool _isExporting = false;


  Future<void> _exportAsImage() async {
    // 1. Declare state variables for the dynamic dialog
    bool isLoading = true;
    Uint8List? generatedBytes;
    String? errorMessage;

    // 2. Open the dialog immediately showing a loading state
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing mid-render
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // 3. Trigger the actual image capture ONCE the dialog is mounted
            if (isLoading && generatedBytes == null && errorMessage == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                try {
                  // Hide any capture-sensitive UI (like buttons) on the main page
                  if (mounted) setState(() => _isExporting = true);
                  HiveProvider.session.put('isExporting', true);
                  // Wait for the UI layout frame to settle without the button
                  await Future.delayed(const Duration(milliseconds: 300));

                  final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
                  if (boundary == null) {
                    throw Exception("UI boundary is not mounted yet.");
                  }

                  final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

                  if (byteData == null) {
                    throw Exception("Failed to encode PNG bytes.");
                  }

                  // Update dialog state with the processed image
                  setDialogState(() {
                    generatedBytes = byteData.buffer.asUint8List();
                    isLoading = false;
                  });
                } catch (e) {
                  setDialogState(() {
                    errorMessage = e.toString();
                    isLoading = false;
                  });
                } finally {
                  // Restore main page state (show buttons back)
                  if (mounted) setState(() => _isExporting = false);
                  HiveProvider.session.delete('isExporting');

                }
              });
            }

            return AlertDialog(
              backgroundColor: cCard,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(
                    isLoading ? Icons.hourglass_top_rounded : Icons.image,
                    color: cCreme,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isLoading ? "Generating Image..." : "Exported Image Preview",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(color: Colors.black),
                    const SizedBox(height: 24),
                    const Text(
                      "Capturing your discovery layout...",
                      style: TextStyle(color: Colors.black38, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                  ] else if (errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      "Error: $errorMessage",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                  ] else if (generatedBytes != null) ...[
                    Container(
                      constraints: const BoxConstraints(maxHeight: 380),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(generatedBytes!, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Discovery Progress PNG generated! Click Download below to save or share.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ],
              ),
              actions: [
                if (!isLoading && generatedBytes != null)
                  TextButton(
                    onPressed: () {
                      final u8List = Uint8List.fromList(generatedBytes!);
                      final jsArrayBuffer = u8List.buffer.toJS;
                      final jsArray = [jsArrayBuffer].toJS;
                      final blob = web.Blob(jsArray, web.BlobPropertyBag(type: 'image/png'));
                      final url = web.URL.createObjectURL(blob);

                      final web.HTMLAnchorElement anchor =
                      web.document.createElement('a') as web.HTMLAnchorElement;
                      anchor.href = url;
                      anchor.download = 'WardenChronicles.png';
                      anchor.style.display = 'none';

                      web.document.body?.appendChild(anchor);
                      anchor.click();
                      anchor.remove();
                      web.URL.revokeObjectURL(url);
                    },
                    child: const Text("DOWNLOAD", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    isLoading ? "CANCEL" : "CLOSE",
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<MergeChain> get _masterpieces=>mergeChains.where((element) => element.masterpiece!=null,).toList();

/* STREAMING_CHUNK:Building main responsive layout and stack structure... */
  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(
      key: _repaintKey,
      child: DecoratedBox(
        decoration: BoxDecoration(color: cBackground),
        child: Stack(
          children: [
            // 2. Main Content Canvas
            SafeArea(
              child: _buildMasterpieceGrid(_masterpieces..sort((a, b) => a.masterpiece!.compareTo(b.masterpiece!),)),
            ),
          ],
        ),
      ),
    );


  }

/* STREAMING_CHUNK:Rendering header section and progress indicator... */
  Widget _buildHeaderBar() {
    return Container(
      height: kMinInteractiveDimension,
      padding: EdgeInsetsGeometry.all(8),
      child: Row(
        mainAxisAlignment: _isExporting?MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.yard_outlined, color: Colors.black87, size: 22),
              const SizedBox(width: 12),
              Text(
                "Warden Chronicles".toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black,
                  fontFamily: 'Waterfall',
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                ),
              ),
            ],
          ),
        if(!_isExporting)
            Row(
            children: [
            // Export as Image Action Button
              IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
            tooltip: "Export Page as Image",
            onPressed: _isExporting ? null : _exportAsImage,
            ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:5),
                child: InfoButton(onPressed:  _showHelpDialog,color: Colors.black,),
              ),
            ]
            ),

        ],
      ),
    );
  }


/* STREAMING_CHUNK:Constructing responsive card grid... */
  Widget _buildMasterpieceGrid(List<MergeChain> items) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Transform.rotate(
          angle: pi*3,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: AssetImage('assets/discovery.webp'),fit: BoxFit.fill,)
              ),
            ),
          ),
        ),
        // if(_isExporting)
        Positioned(
            right: 8,
            bottom:8,
            child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),child: TextLogo())
        ),
        ValueListenableBuilder(
          valueListenable: HiveProvider.appBox.listenable( keys: ['discoveredMasterpieces']),
          builder: (context,box,_) {
            final double spacing = 8;
            final double cardWidth = context.screenSize.width>kDesktopBreak?130:100 -(context.isDesktop?0:10);
            List<String> completed=(box.toMap()['discoveredMasterpieces']as List?)?.map((e) => e.toString(),).toList()??[];

            double progress = completed.length/_masterpieces.length;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: _isExporting ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                    child: Container(
                      alignment: AlignmentGeometry.center,
                      margin: EdgeInsets.only(top: 8),
                      padding:EdgeInsets.symmetric(horizontal: 5),
                      child: Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: items.map((item) {
                          final masterpiece = item;
                          // print(box.toMap()['discoveredMasterpieces']);

                          return SizedBox(
                            width: cardWidth, // 👈 Explicit width prevents layout calculation crashes
                            height: cardWidth,
                            child: _buildMasterpieceCard(masterpiece,completed.contains(masterpiece.id.value),cardWidth),
                          );
                        }).toList() +[
                          SizedBox(
                            width: cardWidth, // 👈 Explicit width prevents layout calculation crashes
                            height: cardWidth,
                            child:  AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: cCard.withValues(alpha:  0.5 ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:  Colors.white.withValues(alpha:0.6),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Card Content Column
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: AlignmentGeometry.center,
                                          children: [
                                            SizedBox(
                                              height:cardWidth*.4,
                                              width:cardWidth*.4,
                                              child: CircularProgressIndicator(
                                                value: progress,
                                                backgroundColor: Colors.black26,
                                                color: cCreme,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('${(progress*100).toStringAsFixed(0)}%'),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        // Item Title & Subtitle
                                        AutoSizeText(
                                          'Discovered: ${completed.length} / ${_masterpieces.length}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF2D3436),
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );

          }
        ),
      ],
    );


  }

/* STREAMING_CHUNK:Styling individual masterpiece cards... */
  Widget _buildMasterpieceCard(MergeChain chain, bool isCompleted,double cardWidth) {
    final MergeItem item= chain.items.last;
    return InkWell(
      onTap: () {
        List<String> completed=(HiveProvider.appBox.get('discoveredMasterpieces') as List?)?.map((e) => e.toString(),).toList()??[];

        if(completed.contains(chain.id.value)){
          completed.remove(chain.id.value);
        }
        else {
          completed.add(chain.id.value);

        }
        HiveProvider.appBox.put('discoveredMasterpieces', completed);

      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: cCreme.withValues(alpha:isCompleted ? 0.92 : 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? cCard : Colors.white.withValues(alpha:0.6),
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? cCard.withValues(alpha:0.2)
                  : Colors.black.withValues(alpha:0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
        // Card Content Column
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Item Emoji / Image Container
                  Center(
                    child: Image.asset(
                      'assets/Stage_${item.stage}_-_${item.name.replaceAll(' ', '_')}.webp',
                      height:cardWidth-50,
                    ),
                  ),

        SizedBox( height: 8,),
        // Item Title & Subtitle
                  AutoSizeText(
                   chain.title,
                    style: const TextStyle(
                      fontFamily: 'Audiowide',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF2D3436),
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bottom-Left Masterpiece Number Badge
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cCreme.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "#${chain.masterpiece}",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            if(isCompleted)
            Positioned(
              top: 3,
              right: 3,
              child: Icon(
                Icons.check_circle,
                size: 24,
                color: cCard,
              ),
            ),
          ],
        ),
      ),
    );


  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cCard,
        title: const Text("Warden Chronicles", style: TextStyle(color: Colors.black)),
        content: const Text(
          "Merge Gardens features 23 unique Masterpieces at the end of key merge chains.\n\n"
              "Tap any card to toggle its status and track your progress! You can share this with friends or the web; click on the camera icon!",
          style: TextStyle(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("GOT IT", style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}