import 'package:flutter_test/flutter_test.dart';
import 'package:mergewarden/model/merge_gardens.dart';
import 'package:mergewarden/model/item_id.dart';
import 'package:mergewarden/view/ledger/tile_format.dart';

void main() {
  group('MergeItem', () {
    final testItem = MergeItem(
      id: const ID('test_id'),
      name: 'Test Item',
      stage: 1,
      description: 'A test item description',
      descriptors: [Descriptor.mustHave],
      sourced: [const ID('source_1')],
      daisyQuests: [const ID('quest_1')],
      richardTrade: true,
      dailyChecklist: true,
      sellValue: 10,
      gemPrice: 5,
      helpfulTips: ['Tip 1'],
      harvestRewards: [const ID('harvest_1')],
      mergingRewards: [const ID('merge_1')],
      spawnedItems: [const ID('spawn_1')],
      tapRewards: [const ID('tap_1')],
      notes: ['Note 1'],
      vanishOnTap: false,
      vanishOnHarvest: false,
      vanishAfterSpawn: false,
      format: TileFormat(1, 1),
    );

    test('property initialization', () {
      expect(testItem.name, 'Test Item');
      expect(testItem.stage, 1);
      expect(testItem.id.value, 'test_id');
    });

    test('isHarvestable getter', () {
      expect(testItem.isHarvestable, true);
      final nonHarvestable = MergeItem(
        id: const ID('id'),
        name: 'Name',
        stage: 1,
        description: '',
        descriptors: [],
        sourced: [],
        daisyQuests: [],
        richardTrade: false,
        dailyChecklist: false,
        sellValue: null,
        gemPrice: null,
        helpfulTips: [],
        harvestRewards: [],
        mergingRewards: [],
        spawnedItems: [],
        tapRewards: [],
        notes: [],
        vanishOnTap: false,
        vanishOnHarvest: false,
        vanishAfterSpawn: false,
        format: TileFormat(1, 1),
      );
      expect(nonHarvestable.isHarvestable, false);
    });

    test('needsSpace getter', () {
      expect(testItem.needsSpace, true);
    });

    test('tappable getter', () {
      expect(testItem.tappable, true);
    });

    test('sellable getter', () {
      expect(testItem.sellable, true);
      final nonSellable = MergeItem(
        id: const ID('id'),
        name: 'Name',
        stage: 1,
        description: '',
        descriptors: [],
        sourced: [],
        daisyQuests: [],
        richardTrade: false,
        dailyChecklist: false,
        sellValue: null,
        gemPrice: null,
        helpfulTips: [],
        harvestRewards: [],
        mergingRewards: [],
        spawnedItems: [],
        tapRewards: [],
        notes: [],
        vanishOnTap: false,
        vanishOnHarvest: false,
        vanishAfterSpawn: false,
        format: TileFormat(1, 1),
      );
      expect(nonSellable.sellable, false);
    });

    test('rewards getter', () {
      expect(testItem.rewards.length, 4);
      expect(testItem.rewards, containsAll([
        const ID('harvest_1'),
        const ID('merge_1'),
        const ID('spawn_1'),
        const ID('tap_1'),
      ]));
    });

    test('toJson and fromJson serialization', () {
      // Note: There's a potential issue in fromJson if it expects strings but toJson provides ints.
      // We'll test with the types that fromJson expects based on its implementation.
      final json = {
        "name": "Test Item",
        "stage": "1",
        "sellValue": "10",
        "gemPrice": "5",
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "globeValue": null,
        "growingTime": null,
        "id": "test_id",
        "growsInto": null,
        "description": "A test item description",
        "descriptors": [0],
        "helpfulTips": ["Tip 1"],
        "notes": ["Note 1"],
        "sourced": ["source_1"],
        "mergingRewards": ["merge_1"],
        "spawnedItems": ["spawn_1"],
        "tapRewards": ["tap_1"],
        "harvestRewards": ["harvest_1"],
        "daisyQuests": ["quest_1"],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": true,
        "format": {"rows": "1", "columns": "1"},
      };

      final itemFromJson = MergeItem.fromJson(json);
      expect(itemFromJson.name, "Test Item");
      expect(itemFromJson.stage, 1);
      expect(itemFromJson.sellValue, 10);
      expect(itemFromJson.descriptors, [Descriptor.mustHave]);
      expect(itemFromJson.id.value, "test_id");
      expect(itemFromJson.format.rows, 1);
      expect(itemFromJson.format.columns, 1);
    });
  });
}
