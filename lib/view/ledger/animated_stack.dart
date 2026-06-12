import 'package:flutter/material.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/utils/colors.dart';
import 'package:mergewarden/view/home.dart';
import 'package:mergewarden/view/ledger/chain_meta_view.dart';
import 'package:mergewarden/view/ledger/ledger.dart';
import 'package:mergewarden/view/ledger/stage_meta_view.dart';


class MultiLayerStackContainer extends StatefulWidget {
  const MultiLayerStackContainer({super.key});

  @override
  State<MultiLayerStackContainer> createState() => _MultiLayerStackContainerState();
}

class _MultiLayerStackContainerState extends State<MultiLayerStackContainer> with TickerProviderStateMixin {
  // Animation Controllers for Slide Transition Layers
  late AnimationController _controllerB;
  late AnimationController _controllerC;

  // Selected State variables
  MergeChain? _selectedChain;
  MergeItem? _selectedItem;

  // Track deep view navigation status
  int _currentDepth = 0; // 0 = Screen A, 1 = Screen B, 2 = Screen C

  @override
  void initState() {
    super.initState();
    // Controllers configuration with smooth physics curve
    _controllerB = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controllerC = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controllerB.dispose();
    _controllerC.dispose();
    super.dispose();
  }

  // Navigation Logic Actions
  void _navigateToB(MergeChain chain) {
    setState(() {
      _selectedChain = chain;
      _currentDepth = 1;
    });
    _controllerB.forward();
  }

  void _navigateToC(MergeItem item) {
    setState(() {
      _selectedItem = item;
      _currentDepth = 2;
    });
    _controllerC.forward();
  }

  void _popToA() {
    if (_currentDepth == 2) {
      // Smoothly reverse C first, then reverse B after a short staggered delay
      _controllerC.reverse().then((_) {
        setState(() {
          _selectedItem = null;
        });
      });
      _controllerB.reverse().then((_) {
        setState(() {
          _selectedChain = null;
          _currentDepth = 0;
        });
      });
    } else if (_currentDepth == 1) {
      _controllerB.reverse().then((_) {
        setState(() {
          _selectedChain = null;
          _currentDepth = 0;
        });
      });
    }
  }

  void _popToB() {
    if (_currentDepth == 2) {
      _controllerC.reverse().then((_) {
        setState(() {
          _selectedItem = null;
          _currentDepth = 1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomBreadcrumbBar(),
        // Stack Area holding our 3 layered screens
        Expanded(
          child: Stack(
            children: [
              // LAYER A: Always visible as base
              LedgerGridView(
                onTapCard: (chain) => _navigateToB(chain),
              ),

              // LAYER B: Slides in on top of A
              AnimatedBuilder(
                animation: _controllerB,
                builder: (context, child) {
                  // Custom parallax effect: Subtle opacity overlay on bottom screen
                  double dx = 1.0 - _controllerB.value;
                  // When Screen C slides in, push Screen B slightly left (-0.15 * progress)
                  double parallaxShift = -0.15 * _controllerC.value;

                  return FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Transform.translate(
                      offset: Offset((dx + parallaxShift) * MediaQuery.of(context).size.width, 0.0),
                      child: Opacity(
                        opacity: (1.0 - (_controllerC.value * 0.3)).clamp(0.0, 1.0),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _selectedChain==null?SizedBox():ChainDetailView(
                    chainData: _selectedChain!,
                    onBack: _popToA,
                    onTapStage: (p0) => _navigateToC(_selectedChain!.items[p0]),
                ),
                // child: ScreenB(
                //   category: _selectedCategory,
                //   onSelectProject: _navigateToC,
                //   onBack: _popToA,
                // ),
              ),

              // LAYER C: Slides in on top of B
              AnimatedBuilder(
                animation: _controllerC,
                builder: (context, child) {
                  double dx = 1.0 - _controllerC.value;
                  return FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Transform.translate(
                      offset: Offset(dx * MediaQuery.of(context).size.width, 0.0),
                      child: child,
                    ),
                  );
                },

                child: _selectedItem==null?SizedBox():ItemDetailView(
                    itemData: _selectedItem!,
                  onBack: _popToB,
                    chainName: _selectedChain?.title ?? 'MG',
                ),

                // child: ScreenC(
                //   project: _selectedProject,
                //   categoryName: _selectedChain?['title'] ?? 'Category',
                //   onBack: _popToB,
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomBreadcrumbBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      // color: const Color(0xFF0F111A),
      child: Row(
        children: [
          // Dynamic Breadcrumb List Builder
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Root home indicator
                  _BreadcrumbItem(
                    label: "Ledger",
                    isActive: _currentDepth == 0,
                    onTap: _currentDepth==0?null:_popToA,
                  ),
                  if (_currentDepth >= 1) ...[
                    const Icon(Icons.chevron_right, size: 16, color: Color(0xFF4A4E69)),
                    _BreadcrumbItem(
                      label: _selectedChain?.title ?? '',
                      isActive: _currentDepth == 1,
                      onTap: _popToB,
                    ),
                  ],
                  if (_currentDepth >= 2) ...[
                    const Icon(Icons.chevron_right, size: 16, color: Color(0xFF4A4E69)),
                    _BreadcrumbItem(
                      label: _selectedItem?.name ?? '',
                      isActive: _currentDepth == 2,
                    ),
                  ],
                ],
              ),
            ),
          ),
          TextLogo(),
          // Action Control Badge
          // if (_currentDepth > 0)
          //   ElevatedButton.icon(
          //     onPressed: _currentDepth == 2 ? _popToB : _popToA,
          //     icon: const Icon(Icons.arrow_back_rounded, size: 14),
          //     label: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xFF1E2235),
          //       foregroundColor: Colors.white,
          //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //       elevation: 0,
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class _BreadcrumbItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _BreadcrumbItem({
    required this.label,
    required this.isActive,
     this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:  Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? cCard :onTap==null?Colors.black: Colors.white,
            fontWeight: isActive ||onTap==null? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
