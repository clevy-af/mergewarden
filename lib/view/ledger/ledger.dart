import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mergewarden/model/knowledge_base.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/utils/hive_provider.dart';
import 'package:mergewarden/view/components/info_button.dart';
import 'package:mergewarden/view/components/stat_card.dart';
import 'package:mergewarden/view/ledger/stage_meta_view.dart';

class _ExplainerContent extends StatelessWidget {
  const _ExplainerContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('1. Breadcrumb Navigation'),
          _buildBulletPoint('Active Tab (default is Ledger): ', 'Indicates the current active section of the application. On clicking any card, your next active tab would be the chain. And likewise for stage item. Clicking any of these labels takes you back. Alternatively, you can click back button in subsequent screens to navigate.'),
          const Divider(height: 24),
          _buildSectionHeader('2. Filters'),
          _buildBulletPoint('Preset Filters: ', 'Quick toggles like "All", "Saved", and "Masterpiece" for quick access.'),
          _buildBulletPoint('Alphabetical Index: ', 'A-Z buttons to jump directly to specific chain names.'),

          const Divider(height: 24),

          _buildSectionHeader('3. Chain Cards'),
          _buildBulletPoint('Visual Asset: ', 'A square showing the  first and last element for reference.'),
          _buildBulletPoint('Chain Name: ', 'Bold text identifying the chain (e.g., Amber Wishing Stars).'),
          _buildBulletPoint('Masterpiece Tag: ', 'Small sub-text for showing if the chain is a masterpiece,eg. #MASTERPIECE 12.'),
          _buildBulletPoint('Save Button: ', 'A bookmark icon at the bottom-right to save the item for later use.'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildBulletPoint(String prefix, String body) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3),
          children: [
            const TextSpan(text: '• ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: prefix, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: body),
          ],
        ),
      ),
    );
  }
}

// --- MAIN PAGE ---
class LedgerGridView extends StatefulWidget {
  const LedgerGridView({super.key, required this.onTapCard});
  final Function(MergeChain) onTapCard;

  @override
  State<LedgerGridView> createState() => _LedgerGridViewState();
}

class _LedgerGridViewState extends State<LedgerGridView> {
  late String _activeAlpha;

  final List<String> _alphabet = ["All","Saved","Masterpiece"]+getAvailableAlphabets();
  List<MergeChain> filteredList=[];


  void showExplainerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'How To Use Ledger',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF556B2F)),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          children: [
            const SizedBox(width: 500, child: _ExplainerContent()),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it', style: TextStyle(color: Color(0xFF556B2F))),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _activeAlpha=_alphabet.first;
    filteredList=mergeChains..sort((a, b) => a.title.toString().compareTo(b.title),);
    super.initState();
  }

  Widget _buildFilterStrip() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
      height: kMinInteractiveDimension,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: _alphabet.length,
        itemBuilder: (context, index) {
          final char= _alphabet[index];
          bool isSelected = _activeAlpha == char;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: ActionChip(
              backgroundColor: isSelected ? cCard : Colors.transparent,

              onPressed: () {
                _activeAlpha = char;
                switch(_activeAlpha.toLowerCase()){
                  case 'saved':
                    List<String> chainIds= HiveProvider.appBox.get('savedChains')??[];
                    filteredList=mergeChains.where((element) => chainIds.contains(element.id.value ),).toList();break;
                  case 'all':filteredList=mergeChains; break;
                  case 'masterpiece': filteredList=mergeChains.where((element) => element.masterpiece!=null,).toList()..sort((a, b) => a.masterpiece!.compareTo(b.masterpiece!),);break;
                  default: filteredList=mergeChains.where((element) => element.title[0]==char,).toList();
                }
                setState(() {});
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: isSelected ?Colors.transparent:cCreme),
                  borderRadius: BorderRadiusGeometry.circular(15)
              ),
              label: Text(
                char,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ),
          );

        },
      ),
    );
  }

  Widget _buildChainCard(MergeChain chain) {

    var lastItem = chain.items.last;
    var firstItem = chain.items.first;
    return GestureDetector(
      onTap:() => widget.onTapCard(chain),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border:  Border.all(color: cCreme.withAlpha(150))
          // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // margin: EdgeInsets.only(top: 3),
              height: 180, // Define your card height
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Image 1: Bottom-Left Triangle (Rotated Clipper)
                  Positioned.fill(
                    child: RotatedBox(
                      quarterTurns: 2, // Flips the clipper to the opposite corner
                      child: ClipPath(
                        clipper: GappedDiagonalClipper(gap: 3.0, isTopRight: false),
                        child: RotatedBox(
                          quarterTurns: 2, // Flips the image back right-side up
                          child: StageItemImage(
                            assetName: 'Stage_${lastItem.stage}_-_${lastItem.name.replaceAll(' ', '_')}',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Image 2: Top-Right Triangle
                  Positioned.fill(
                    child: ClipPath(
                      clipper: GappedDiagonalClipper(gap: 4.0, isTopRight: false),
                      child: StageItemImage(
                        assetName: 'Stage_${firstItem.stage}_-_${firstItem.name.replaceAll(' ', '_')}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(child: AutoSizeText(chain.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    minFontSize: 12,
                    maxLines: 1,
                  )
                  ),
                  const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (chain.masterpiece!=null)
                        Text('#${'Masterpiece'.toUpperCase()} '"${chain.masterpiece}",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F))
                        )
                        else SizedBox(),
                      ValueListenableBuilder(
                        valueListenable: HiveProvider.appBox.listenable(keys: ['savedChains']),
                        builder: (context, value, child) {
                                List<String> chainIds= value.toMap()['savedChains']??[];
                                bool isSaved= chainIds.contains(chain.id.value);
                          return IconButton.outlined(
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                                  side: BorderSide(color: cCreme),
                              visualDensity: VisualDensity(vertical: -3)
                            ),
                              onPressed: () async {
                                if(isSaved) {
                                  chainIds.remove(chain.id.value);
                                } else {
                                  chainIds.add(chain.id.value);

                                }
                                await HiveProvider.appBox.put('savedChains', chainIds);
                              },
                              icon:Icon(isSaved?Icons.bookmark_added_rounded:Icons.bookmark_border,color: isSaved?cCard:kTextDark,),
                          );
                        }
                      )
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: cFillBackground,
          borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(15),
            topRight:  Radius.circular(15),
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5,),
              Padding(
                padding: const EdgeInsets.all( 8),
                child: Text("Discover and interact with any chain from your garden.",
                  style: TextStyle(fontSize: context.screenSize.width*0.02,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8,right: 8.0),
                child: InfoButton(onPressed: () => showExplainerDialog(context)),
              )
            ],
          ),
          _buildFilterStrip(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:8,horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900 ? 5 : MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: MediaQuery.of(context).size.width < 900?MediaQuery.of(context).size.height/2.2:null,
                  childAspectRatio:0.8,//(context.screenSize.width/5)/(context.screenSize.height/2),// 0.83,
                ),
                itemCount: filteredList.length,
                itemBuilder:  (context, index) => _buildChainCard(filteredList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GappedDiagonalClipper extends CustomClipper<Path> {
  final double gap;
  final bool isTopRight;

  GappedDiagonalClipper({required this.gap, required this.isTopRight});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (isTopRight) {
      // Top-right triangle pulled back slightly from the bottom-left corner
      path.moveTo(gap, 0); // Start slightly to the right on top edge
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height - gap); // End slightly up on right edge
      path.close();
    } else {
      // Bottom-left triangle pulled back from the top-right corner
      path.moveTo(0, gap); // Start slightly down on left edge
      path.lineTo(0, size.height);
      path.lineTo(size.width - gap, size.height); // End slightly left on bottom edge
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant GappedDiagonalClipper oldClipper) {
    return oldClipper.gap != gap || oldClipper.isTopRight != isTopRight;
  }
}

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(seconds: 1),
  });

  @override
  FadeIndexedStackState createState() => FadeIndexedStackState();
}

class FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset beginOffset=Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool isIncoming = oldWidget.index == widget.index;


          if (widget.index>=oldWidget.index) {
            beginOffset = isIncoming ? const Offset(1.0, 0.0) : const Offset(0.0, 0.0);
          } else {
            beginOffset = isIncoming ? const Offset(0.0, 0.0) : const Offset(1.0, 0.0);
          }
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )),
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
