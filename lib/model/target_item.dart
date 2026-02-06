class TargetItem {
  final String chain;
  final int stage;
  final int count;
  TargetItem({required this.chain,required this.count,required this.stage});

}

enum ChainStage{
  seed,stage1,stage2,stage3,stage4,stage5,stage6,stage7,
}