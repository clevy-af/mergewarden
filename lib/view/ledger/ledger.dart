import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mergewarden/model/knowledge_base.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/utils/extension.dart';
import 'package:mergewarden/view/home.dart';


// --- MAIN PAGE ---

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  Map<String,dynamic>? _selectedChain;
  Map<String,dynamic>? _selectedItem;
  int _currentIndex=0;
  int _previousIndex=0;

  bool get isMovingForward  => _currentIndex >= _previousIndex;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumbs(),
          // Expanded(
          //   child: AnimatedSwitcher(
          //     duration: kThemeAnimationDuration * 4,
          //     layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          //       // If moving backward, the old child (in previousChildren) needs to sit ON TOP of the new child
          //       if (!isMovingForward) {
          //         return Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             if (currentChild != null) currentChild, // New child underneath
          //             ...previousChildren,                   // Old child on top
          //           ],
          //         );
          //       }
          //
          //       // Default forward behavior: New child sits on top
          //       return Stack(
          //         alignment: Alignment.center,
          //         children: [
          //           ...previousChildren,                   // Old child underneath
          //           if (currentChild != null) currentChild, // New child on top
          //         ],
          //       );
          //     },
          //     transitionBuilder: (child, animation) {
          //       final ValueKey<int>? childKey = child.key as ValueKey<int>?;
          //       final bool isIncoming = childKey?.value == _currentIndex;
          //
          //       Offset beginOffset;
          //
          //       if (isMovingForward) {
          //         beginOffset = isIncoming ? const Offset(1.0, 0.0) : const Offset(0.0, 0.0);
          //       } else {
          //         beginOffset = isIncoming ? const Offset(0.0, 0.0) : const Offset(1.0, 0.0);
          //       }
          //
          //       return SlideTransition(
          //         position: Tween<Offset>(
          //           begin: beginOffset,
          //           end: Offset.zero,
          //         ).animate(CurvedAnimation(
          //           parent: animation,
          //           curve: Curves.easeInOut,
          //         )),
          //         child: child,
          //       );
          //     },
          //     child: _selectedItem != null ? ItemDetailView(
          //       key: const PageStorageKey(2),
          //       // Ensure view tracking keys match indices exactly
          //       chainName: _selectedChain?['name'] ?? 'MG',
          //       itemData: _selectedItem!,
          //       onBack: () {
          //         setState(() {
          //           _currentIndex = 1;
          //           _previousIndex = 2;
          //           _selectedItem = null;
          //         });
          //       },
          //     ) : _selectedChain != null ?
          //     ChainDetailView(
          //       key: const PageStorageKey(1),
          //       // Ensure view tracking keys match indices exactly
          //       onTapStage: (p0) {
          //         setState(() {
          //           _currentIndex = 2;
          //           _previousIndex = 1;
          //           _selectedItem = chainItems[_selectedChain?['id']]?[p0];
          //         });
          //       },
          //       chainData: _selectedChain!,
          //       onBack: () {
          //         setState(() {
          //           _currentIndex = 0;
          //           _previousIndex = 1;
          //           _selectedChain = null;
          //         });
          //       },
          //     )
          //         : LedgerGridView(
          //       key: const PageStorageKey(0),
          //           onTapCard:  (chain) {
          //             _currentIndex=1;
          //             _previousIndex=0;
          //             setState(() => _selectedChain = chain);
          //
          //           },
          //         ),
          //   ),
          //
          // ),
        ],
      ),
    );
  }

  // 1. BREADCRUMBS
  Widget _buildBreadcrumbs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [

          _breadcrumbItem("Ledger", isRoot: true, onTap:_selectedChain==null?null: () {
            setState(() {
              _selectedChain = null;
              _selectedItem = null;
              _currentIndex=0;
              _previousIndex=1;
            });
          }),
          if (_selectedChain != null) ...[
            _breadcrumbSeparator(),
            _breadcrumbItem(_selectedChain!['name'], onTap: _selectedItem==null?null:() => setState(() {
              _selectedItem = null;
              _currentIndex=1;
              _previousIndex=2;
            })),
          ],
          if (_selectedItem != null) ...[
            _breadcrumbSeparator(),
            _breadcrumbItem(_selectedItem!['name']),
          ],
          Spacer(),
          TextLogo(),

        ],
      ),
    );
  }

  Widget _breadcrumbItem(String label, {bool isRoot = false, VoidCallback? onTap}) {
    return TextButton(
      onPressed: onTap,
      child: Text(label,style: TextStyle(
        color: onTap != null ? Colors.white :cCard,
        fontWeight: onTap != null ? FontWeight.normal : FontWeight.bold,
        fontSize: 13,
      ),),
    );
  }

Widget _breadcrumbSeparator() => Text('‣',style: TextStyle(fontSize: 20),);



}

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
                  case 'saved': filteredList=[];break;
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: cCard,
              clipBehavior: Clip.antiAlias, // Ensures clean edges
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                height: 180, // Define your card height
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    // Image 1: Bottom-Left Triangle (Rotated Clipper)
                    Positioned.fill(
                      child: RotatedBox(
                        quarterTurns: 2, // Flips the clipper to the opposite corner
                        child: ClipPath(
                          clipper: GappedDiagonalClipper(gap: 4.0, isTopRight: false),
                          child: RotatedBox(
                            quarterTurns: 2, // Flips the image back right-side up
                            child: Image.asset(
                              'assets/''Stage_${lastItem.stage}_-_${lastItem.name.replaceAll(' ', '_')}.webp',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Image 2: Top-Right Triangle
                    Positioned.fill(
                    child: ClipPath(
                      clipper: GappedDiagonalClipper(gap: 4.0, isTopRight: false),
                      child: Image.asset(
                        'assets/''Stage_${firstItem.stage}_-_${firstItem.name.replaceAll(' ', '_')}.webp',
                        fit: BoxFit.cover,
                        ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
            // // Image Placeholder
            // Expanded(
            //   child: StageItemImage(
            //       borderRadius:BorderRadius.only(
            //           topLeft: Radius.circular(15),
            //           topRight: Radius.circular(15)
            //       ),
            //       assetName: 'Stage_${lastItem?['stage']}_-_${lastItem?['name'].toString().replaceAll(' ', '_')}'),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(child: AutoSizeText(chain.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    minFontSize: 12,
                    maxLines: 1,
                  )
                  ),
                  // const SizedBox(height: 4),
                  // Text(chain.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                  const SizedBox(height: 3),
                  if (chain.masterpiece!=null)
                    Text('#${'Masterpiece'.toUpperCase()} '"${chain.masterpiece}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F))),
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
          Padding(
            padding: const EdgeInsets.all( 8),
            child: Text("Discover and interact with any chain from your garden.",
              style: TextStyle(fontSize: context.screenSize.width*0.02,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildFilterStrip(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:8,horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
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
