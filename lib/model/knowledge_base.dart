List<Map<String,dynamic>> chains= [
  {"name": "Poplar Trees", "id": "Poplar_Trees", "stages": 11,"masterpiece":1},
  {"name": "Wild Flowers", "id": "Wild_Flowers", "stages": 18,"masterpiece":2},
  {"name": "Grasses", "id": "Grasses", "stages": 9,"masterpiece":3},
  {"name": "Mole Hills", "id": "Mole_Hills", "stages": 10,"masterpiece":4},
  {"name": "Oak Trees", "id": "Oak_Trees", "stages": 10,"masterpiece":5},
  {"name": "Ponds", "id": "Ponds", "stages": 9,"masterpiece":6},
  {"name": "Tulips", "id": "Tulips", "stages": 10,"masterpiece":7},
  {"name": "Fruit Trees", "id": "Fruit_Trees", "stages": 11,"masterpiece":8},
  {"name": "Vines", "id": "Vines", "stages": 10,"masterpiece":9},
  {"name": "Vegetable Patches", "id": "Vegetable_Patches", "stages": 6,"masterpiece":10},
  {"name": "Mushrooms", "id": "Mushrooms", "stages": 11,"masterpiece":11},
  {"name": "Apiaries", "id": "Apiaries", "stages": 13,"masterpiece":12},
  {"name": "Zen Gardens", "id": "Zen_Gardens", "stages": 10,"masterpiece":13},
  {"name": "Rocks", "id": "Rocks", "stages": 8,"masterpiece":14},
  {"name": "Roman Ruins", "id": "Roman_Ruins", "stages": 9,"masterpiece":15},
  {"name": "Topiaries", "id": "Topiaries", "stages": 8,"masterpiece":16},
  // {"name": "Garden Gnomes", "id": "Garden_Gnomes", "stages": 13,"masterpiece":17},
  {"name": "Gardening Tools", "id": "Gardening_Tools", "stages": 20,"masterpiece":18},
  {"name": "Yard Games", "id": "Yard_Games", "stages": 12,"masterpiece":19},
  {"name": "Berry Bushes", "id": "Berry_Bushes", "stages": 13,"masterpiece":20},
  {"name": "Ornamental Vases", "id": "Ornamental_Vases", "stages": 11,"masterpiece":21},
  {"name": "Exotic Flora", "id": "Exotic_Flora", "stages": 11,"masterpiece":22},

  {"name": "Coins", "id": "Coins", "stages": 10},
  {"name": "Coin Storage", "id": "Coin_Storage", "stages": 10},
  {"name": "Wood Storage", "id": "Wood_Storage", "stages": 10},
  {"name": "Timber", "id": "Timber", "stages": 10},
  {"name": "Nectar", "id": "Nectar", "stages": 9},
  {"name": "Treasure Chests", "id": "Treasure_Chests", "stages": 7},
  {"name": "Wildlife Homes", "id": "Wildlife_Homes", "stages": 8},
  {"name": "Fountains", "id": "Fountains", "stages": 5},
  {"name": "Rosebushes", "id": "Rosebushes", "stages": 10},
  {"name": "Amber Wishing Stars", "id": "Amber_Wishing_Stars", "stages": 6},
  {"name": "Honey", "id": "Honey", "stages": 4},
  {"name": "Mossy Timber", "id": "Mossy_Timber", "stages": 5},
  {"name": "Fruits", "id": "Fruits", "stages": 7},
  {"name": "Vegetables", "id": "Vegetables", "stages": 4},
  {"name": "Berries", "id": "Berries", "stages": 9},
  {"name": "Garden Statues", "id": "Garden_Statues", "stages": 5},
  {"name": "Water Wheels", "id": "Water_Wheels", "stages": 2},
  {"name": "Secret Wells", "id": "Secret_Wells", "stages": 2},
  {"name": "Faberge Egg", "id": "Faberge_Egg", "stages": 2},
  {"name": "Antique Trunks", "id": "Antique_Trunks", "stages": 4},
  {"name": "Aqua Trunks", "id": "Aqua_Trunks", "stages": 2},
  {"name": "Dutch Trunks", "id": "Dutch_Trunks", "stages": 2},
  {"name": "Floral Trunks", "id": "Floral_Trunks", "stages": 2},
  {"name": "Tradesman's Trunks", "id": "Tradesman's_Trunks", "stages": 2},
  {"name": "Timber Trunk", "id": "Timber_Trunk", "stages": 2},
  {"name": "Precious Gems", "id": "Precious_Gems", "stages": 3},
  {"name": "Aviaries", "id": "Aviaries", "stages": 4},
  // {"name": "Baskets & Hampers", "id": "Baskets_and_Hampers", "stages": 4},
  {"name": "Red Baskets and Hampers", "id": "Red_Baskets_and_Hampers", "stages": 4},
  {"name": "Blue Baskets and Hampers", "id": "Blue_Baskets_and_Hampers", "stages": 4},
  {"name": "Green Baskets and Hampers", "id": "Green_Baskets_and_Hampers", "stages": 4},
  {"name": "Brown Baskets and Hampers", "id": "Brown_Baskets_and_Hampers", "stages": 4},
  {"name": "Rope", "id": "Rope", "stages": 5},
  {"name": "Ore Veins", "id": "Ore_Veins", "stages": 2},
  {"name": "Aspirational Decor", "id": "Aspirational_Decor", "stages": 15},
  {"name": "Heart-Shaped Balloons", "id": "Heart-Shaped_Balloons", "stages": 2},
  {"name": "Recycled Boosters", "id": "Recycled_Boosters", "stages": 4},
  {"name": "Uncle Elwood's Experiment", "id": "Uncle_Elwood's_Experiment", "stages": 4},
  {"name": "Time Skip", "id": "Time_Skip", "stages": 4},
  {"name": "Garden Guardians", "id": "Garden_Guardians", "stages": 9,"masterpiece":23 },
  // {"name": "Wildlife", "id": "Wildlife", "stages": 8},
];

List<String> getAvailableAlphabets() {
  return chains
  // 1. Extract the first character of each name
      .map((chain) => chain['name'].toString().trim()[0].toUpperCase())
  // 2. Convert to a Set to remove duplicates
      .toSet()
  // 3. Convert back to a list and sort alphabetically
      .toList()
    ..sort();
}

List<String> wildlifeList = [
  "Ameraucana Chicken",
  "Bald Eagle",
  "Barn Owl",
  "Bumblebee",
  "Chaffinch",
  "Cicada",
  "Cockatiel",
  "Crowned Hairstreak",
  "Dove",
  "Dracula Parrot",
  "Eastern Bluebird",
  "Falcon",
  "Feather-horned Beetle",
  "Flame Bowerbird",
  "Flamingo",
  "Flying Lemur",
  "Flying Squirrel",
  "Gliding Lizard",
  "Green Darner",
  "Heron",
  "Hog-Nosed Bat",
  "Homing Pigeon",
  "Honey Bee",
  "Hoopoe",
  "Hummingbird",
  "Northern Cardinal",
  "Kingfisher",
  "Ladybug",
  "Long Eared Owl",
  "Lovebird",
  "Luna Moth",
  "Magpie",
  "Mandarin Duck",
  "Mantis",
  "Monarch Butterfly",
  "Peacock",
  "Pelican",
  "Pheasant",
  "Puffin",
  "Rainbow Leaf Beetle",
  "Raven",
  "Robin",
  "Rosy Maple",
  "Seagull",
  "Secretary Bird",
  "Snowy Owl",
  "Sugar Glider",
  "Swan",
  "Toucan",
  "White Bat",
  "Woodpecker",
];

Map<String,List<Map<String,dynamic>>> chainItems= {
  'Amber_Wishing_Stars': [
    {
      "name": "Singular Star",
       "stage": 1
    },
    {
      "name": "Polished Star",
      "stage": 2
    },
    {
      "name": "Glossy Star",
      "stage": 3
    },
    {
      "name": "Gleaming Star",
      "stage": 4
    },
    {
      "name": "Lustrous Star",
      "stage": 5
    },
    {
      "name": "Peerless Star",
      "stage": 6
    }
  ],
  'Antique_Trunks':[
    {
      "name": "Neat Antique Trunk",
      "stage": 1
    },
    {
      "name": "Fine Antique Trunk",
      "stage": 2
    },
    {
      "name": "Striking Antique Trunk",
      "stage": 3
    },
    {
      "name": "Delightful Antique Trunk",
      "stage": 4
    }
  ],
  'Apiaries':[
    {
      "name": "Honey Tree Seed",
      "stage": 0
    },
    {
      "name": "Honey Tree Sprout",
      "stage": 1
    },
    {
      "name": "Honey Tree Sapling",
      "stage": 2
    },
    {
      "name": "Growing Honey Tree",
      "stage": 3
    },
    {
      "name": "Young Honey Tree",
      "stage": 4
    },
    {
      "name": "Handsome Honey Tree",
      "stage": 5
    },
    {
      "name": "Lavender Apiary",
     "stage": 6
    },
    {
      "name": "Sunflower Apiary",
      "stage": 7
    },
    {
      "name": "Midsummer Apiary",
      "stage": 8
    },
    {
      "name": "Honeysuckle Apiary",
     "stage": 9
    },
    {
      "name": "Wisteria Apiary",
      "stage": 10
    },
    {
      "name": "Glorious Apiary",
      "stage": 11
    },
    {
      "name": "Magnificent Bee Statue",
      "stage": 12
    }
  ],
  'Aqua_Trunks':[
    {
      "name": "Polished Aqua Trunk",
      "stage": 1
    },
    {
      "name": "Gleaming Aqua Trunk",
      "stage": 2
    }
  ],
  'Aspirational_Decor':[
    {
      "name": "Gravel Path",
      "stage": 1
    },
    {
      "name": "Cobbled Path",
      "stage": 2
    },
    {
      "name": "Rustic Fence",
      "stage": 3
    },
    {
      "name": "Simple Night Lamp",
      "stage": 4
    },
    {
      "name": "Rustic Bench",
      "stage": 5
    },
    {
      "name": "Rustic Table",
      "stage": 6
    },
    {
      "name": "Ornate Fence",
      "stage": 7
    },
    {
      "name": "Ornate Bench",
      "stage": 8
    },
    {
      "name": "Ornate Table",
      "stage": 9
    },
    {
      "name": "Ornate Night Lamp",
      "stage": 10
    },
    {
      "name": "Rustic Arched Trellis",
      "stage": 11
    },
    {
      "name": "Ornate Arched Trellis",
      "stage": 12
    },
    {
      "name": "Ornate Gate",
      "stage": 13
    },
    {
      "name": "Rustic Pavilion",
      "stage": 14
    },
    {
      "name": "Ornate Pavilion",
      "stage": 15
    }
  ],
  'Aviaries':[
    {
      "name": "Wonderous Aviary",
      "stage": 1
    },
    {
      "name": "Stunning Aviary",
      "stage": 2
    },
    {
      "name": "Spectacular Aviary",
      "stage": 3
    },
    {
      "name": "Breathtaking Aviary",
      "stage": 4
    }
  ],
  'Baskets_and_Hampers':[
    {
      "name": "Dainty Basket",
      "stage": 1
    },

    // {
    //   "name": "Dainty Brown Basket",
    //   "stage": 1
    // },
    // {
    //   "name": "Dainty Green Basket",
    //   "stage": 1
    // },
    // {
    //   "name": "Dainty Red Basket",
    //   "stage": 1
    // },
    // {
    //   "name": "Dainty Blue Basket",
    //   "stage": 1
    // },
    {
      "name": "Charming Basket",
      "stage": 2
    },
    // {
    //   "name": "Charming Brown Basket",
    //   "stage": 2
    // },
    // {
    //   "name": "Charming Green Basket",
    //  "stage": 2
    // },
    // {
    //   "name": "Charming Red Basket",
    //   "stage": 2
    // },
    // {
    //   "name": "Charming Blue Basket",
    //   "stage": 2
    // },
    {
      "name": "Abundant Hamper",
      "stage": 3
    },
    // {
    //   "name": "Abundant Brown Hamper",
    //   "stage": 3
    // },
    // {
    //   "name": "Abundant Green Hamper",
    //    "stage": 3
    // },
    // {
    //   "name": "Abundant Red Hamper",
    //   "stage": 3
    // },
    // {
    //   "name": "Abundant Blue Hamper",
    //   "stage": 3
    // },
    {
      "name": "Voluptuous Hamper",
      "stage": 4
    },
    // {
    //   "name": "Voluptuous Brown Hamper",
    //   "stage": 4
    // },
    // {
    //   "name": "Voluptuous Green Hamper",
    //   "stage": 4
    // },
    // {
    //   "name": "Voluptuous Red Hamper",
    //   "stage": 4
    // },
    // {
    //   "name": "Voluptuous Blue Hamper",
    //   "stage": 4
    // }
  ],
  'Berries':[
    {"name": "Cranberry", "stage": 1},
    {"name": "Blackberry", "stage": 2},
    {"name": "Strawberry", "stage": 3},
    {"name": "Blueberry", "stage": 4},
    {"name": "Raspberry", "stage": 5},
    {"name": "Cloudberry", "stage": 6},
    {"name": "Gooseberry", "stage": 7},
    {"name": "White Currant", "stage": 8},
    {"name": "Physalis", "stage": 9}
  ],
  'Berry_Bushes':[
    {"name": "Sprouting Berry Bush", "stage": 1},
    {"name": "Growing Berry Bush", "stage": 2},
    {"name": "Maturing Berry Bush", "stage": 3},
    {"name": "Cranberry Bush", "stage": 4},
    {"name": "Blackberry Bush", "stage": 5},
    {"name": "Strawberry Bush", "stage": 6},
    {"name": "Blueberry Bush", "stage": 7},
    {"name": "Raspberry Bush", "stage": 8},
    {"name": "Cloudberry Bush", "stage": 9},
    {"name": "Gooseberry Bush", "stage": 10},
    {"name": "White Currant Bush", "stage": 11},
    {"name": "Physalis Bush", "stage": 12},
    {"name": "Fanciful Labyrinth", "stage": 13}
  ],
'Coins':[
  {"name": "Gold Coin", "stage": 1},
  {"name": "Solid Coins", "stage": 2},
  {"name": "Pile of Coins", "stage": 3},
  {"name": "Stash of Coins", "stage": 4},
  {"name": "Heap of Coins", "stage": 5},
  {"name": "Gold Bars", "stage": 6},
  {"name": "Mountain of Gold", "stage": 7},
  {"name": "Gold Collection", "stage": 8},
  {"name": "Temple of Gold", "stage": 9}
],
  'Coin_Storage':[
    {"name": "Coin Cache", "stage": 1},
    {"name": "Coin Hideout", "stage": 2},
    {"name": "Coin Stash", "stage": 3},
    {"name": "Coin Storehouse", "stage": 4},
    {"name": "Coin Repository", "stage": 5},
    {"name": "Coin Vault", "stage": 6},
    {"name": "Coin Treasury", "stage": 7},
    {"name": "Garden Bank", "stage": 8}
  ],
  'Dutch_Trunks':[
    {"name": "Elegant Dutch Trunk", "stage": 1},
    {"name": "Superb Dutch Trunk", "stage": 2}
  ],
  'Exotic_Flora':[
    {"name": "Curious Seeds", "stage": 0},
    {"name": "Flamingo Flower", "stage": 1},
    {"name": "Plumeria", "stage": 2},
    {"name": "Angel Wing Begonia", "stage": 3},
    {"name": "Pink Ginger", "stage": 4},
    {"name": "Bird of Paradise", "stage": 5},
    {"name": "Passion Flower", "stage": 6},
    {"name": "Protea", "stage": 7},
    {"name": "Pitcher Plant", "stage": 8},
    {"name": "Rafflesia", "stage": 9},
    {"name": "Titan Arum", "stage": 10},
    {"name": "Botanical Arbour", "stage": 11}
  ],
'Faberge_Egg':[
  {
    "name": "Faberge Egg Shard",
    "stage": 1
  },
  {
    "name": "Faberge Egg",
    "stage": 2
  }
],
  'Floral_Trunks':[
    {
      "name": "Delicate Floral Trunk",
      "stage": 1
    },
    {
      "name": "Stunning Floral Trunk",
      "stage": 2
    }
  ],
  'Fountains':[
    {"name": "Peaceful Fountain", "stage": 1},
    {"name": "Grand Fountain", "stage": 2},
    {"name": "Fish Sculpture Fountain", "stage": 3},
    {"name": "Mermaid Sculpture Fountain", "stage": 4},
    {"name": "Unidolphasus Sculpture Fountain", "stage": 5}
  ],
  'Fruit_Trees':[
    {"name": "Fruit Tree Seed", "stage": 0},
    {"name": "Fruit Tree Sprout", "stage": 1},
    {"name": "Seedling Fruit Tree", "stage": 2},
    {"name": "Budding Fruit Tree", "stage": 3},
    {"name": "Apple Tree", "stage": 4},
    {"name": "Lemon Tree", "stage": 5},
    {"name": "Cherry Tree", "stage": 6},
    {"name": "Banana Tree", "stage": 7},
    {"name": "Mango Tree", "stage": 8},
    {"name": "Dragonfruit Tree", "stage": 9},
    {"name": "Durian Tree", "stage": 10},
    {"name": "Mysterious Mangrove", "stage": 11}
  ],
  'Fruits':[
    {"name": "Apple", "stage": 1},
    {"name": "Lemon", "stage": 2},
    {"name": "Cherry", "stage": 3},
    {"name": "Banana", "stage": 4},
    {"name": "Mango", "stage": 5},
    {"name": "Dragonfruit", "stage": 6},
    {"name": "Durian", "stage": 7}
  ],
  'Garden_Gnomes':[
    {"name": "Garden Gnome", "stage": 1},
    {"name": "Brisk Gnome", "stage": 2},
    {"name": "Gardening Gnome", "stage": 3},
    {"name": "Foraging Gnome", "stage": 4},
    {"name": "Relaxing Gnome", "stage": 5},
    {"name": "Fisher Gnome", "stage": 6},
    {"name": "Surprised Gnome", "stage": 7},
    {"name": "Adventurous Gnome", "stage": 8},
    {"name": "Startled Gnome", "stage": 9},
    {"name": "Befriending Fellows", "stage": 10},
    {"name": "Kindred Spirits", "stage": 11},
    {"name": "Retired Adventurers", "stage": 12},
    {"name": "Ancient Friends", "stage": 13}
  ],
  'Garden_Statues':[
    {"name": "Sundial Statue", "stage": 1},
    {"name": "Dove Statue", "stage": 2},
    {"name": "Pooch Statue", "stage": 3},
    {"name": "Lion Statue", "stage": 4},
    {"name": "Pegasus Statue", "stage": 5}
  ],
  'Gardening_Tools':[
    {"name": "Gardening Glove", "stage": 1},
    {"name": "Hand Rake", "stage": 2},
    {"name": "Trowel", "stage": 3},
    {"name": "Shears", "stage": 4},
    {"name": "Leaf Rake", "stage": 5},
    {"name": "Shovel", "stage": 6},
    {"name": "Wheelbarrow", "stage": 7},
    {"name": "Hand Saw", "stage": 8},
    {"name": "Power Drill", "stage": 9},
    {"name": "Toolbox", "stage": 10},
    {"name": "Miter Saw", "stage": 11},
    {"name": "Scroll Bender", "stage": 12},
    {"name": "Welder", "stage": 13},
    {"name": "Rolling Mill", "stage": 14},
    {"name": "Forge", "stage": 15},
    {"name": "Lathe", "stage": 16},
    {"name": "Table Saw", "stage": 17},
    {"name": "Ironworker", "stage": 18},
    {"name": "Toolshed", "stage": 19},
    {"name": "Mastercraft Workshop", "stage": 20}
  ],
  'Grasses':[
    {"name": "Mossy Pebbles", "stage": 1},
    {"name": "Grassy Tuft", "stage": 2},
    {"name": "Grass Patch", "stage": 3},
    {"name": "Blooming Grass", "stage": 4},
    {"name": "Wild Grasses", "stage": 5},
    {"name": "Magnificent Grasses", "stage": 6},
    {"name": "Great Grasses", "stage": 7},
    {"name": "Grassy Spectacle", "stage": 8},
    {"name": "Mediterranean Patio", "stage": 9}
  ],
  'Heart-Shaped_Balloons':[
    {"name": "Life Balloon", "stage": 1},
    {"name": "Balloon Cluster", "stage": 2}
  ],
  'Honey':[
    {"name": "Honeycomb", "stage": 1},
    {"name": "Honey Jar", "stage": 2},
    {"name": "Honey Cache", "stage": 3},
    {"name": "Honey Stand", "stage": 4}
  ],
  'Mole_Hills':[
    {"name": "Compost", "stage": 0},
    {"name": "Upturned Soil", "stage": 1},
    {"name": "Small Mound", "stage": 2},
    {"name": "Mole Den", "stage": 3},
    {"name": "Mole Cove", "stage": 4},
    {"name": "Mole Creek", "stage": 5},
    {"name": "Mole Cavern", "stage": 6},
    {"name": "Mole Lagoon", "stage": 7},
    {"name": "Mole Bayou", "stage": 8},
    {"name": "Mole Sanctuary", "stage": 9},
    {"name": "Mole Hamlet", "stage": 10}
  ],
  'Mossy_Timber':[
    {"name": "Mossy Branch", "stage": 1},
    {"name": "Mossy Log", "stage": 2},
    {"name": "Mossy Trunk", "stage": 3},
    {"name": "Mossy Chunks", "stage": 4},
    {"name": "Mossy Lumber", "stage": 5}
  ],
  'Mushrooms':[
    {"name": "Button Mushroom", "stage": 0},
    {"name": "Shiitake", "stage": 1},
    {"name": "Porcini", "stage": 2},
    {"name": "Yellow Oyster", "stage": 3},
    {"name": "Morel", "stage": 4},
    {"name": "Pink Domecap", "stage": 5},
    {"name": "Wood Blewit", "stage": 6},
    {"name": "Fly Agaric", "stage": 7},
    {"name": "Chanterelles", "stage": 8},
    {"name": "Mushroom Cluster", "stage": 9},
    {"name": "Mushroom Glade", "stage": 10},
    {"name": "Mushroom Tree House", "stage": 11}
  ],
  'Nectar':[
    {"name": "Yellow Nectar", "stage": 0},
    {"name": "Blue Nectar", "stage": 1},
    {"name": "Red Nectar", "stage": 2},
    {"name": "Amber Nectar", "stage": 3},
    {"name": "Orange Nectar", "stage": 4},
    {"name": "Refined Azure Nectar", "stage": 5},
    {"name": "Refined Blue Nectar", "stage": 6},
    {"name": "Refined Orange Nectar", "stage": 7},
    {"name": "Rainbow Nectar", "stage": 8},
    {"name": "Flawless Nectar", "stage": 9}
  ],
  'Oak_Trees':[
    {"name": "Acorn", "stage": 0},
    {"name": "Oak Sapling", "stage": 1},
    {"name": "Growing Oak", "stage": 2},
    {"name": "Young Oak", "stage": 3},
    {"name": "Handsome Oak", "stage": 4},
    {"name": "Sturdy Oak", "stage": 5},
    {"name": "Strong Oak", "stage": 6},
    {"name": "Great Oak", "stage": 7},
    {"name": "Elder Oak", "stage": 8},
    {"name": "Ancient Oak", "stage": 9},
    {"name": "Whomping Oak", "stage": 10}
  ],
  'Ore_Veins':[
    {"name": "Mysterious Vein", "stage": 1},
    {"name": "Gorgeous Vein", "stage": 2}
  ],
  'Ornamental_Vases':[
    {"name": "Earthenware Vase", "stage": 1},
    {"name": "Terracotta Vase", "stage": 2},
    {"name": "Artisan Vase", "stage": 3},
    {"name": "Tuscan Vase", "stage": 4},
    {"name": "Imari Vase", "stage": 5},
    {"name": "Delft Vase", "stage": 6},
    {"name": "Parisian Vase", "stage": 7},
    {"name": "Murano Vase", "stage": 8},
    {"name": "Faberge Vase", "stage": 9},
    {"name": "Renaissance Vase", "stage": 10},
    {"name": "Artisanal Ceramic Oven", "stage": 11}
  ],
  'Ponds':[
    {"name": "Puddle", "stage": 1},
    {"name": "Quagmire", "stage": 2},
    {"name": "Water Hole", "stage": 3},
    {"name": "Shimmering Pond", "stage": 4},
    {"name": "Lively Pond", "stage": 5},
    {"name": "Flowing Pond", "stage": 6},
    {"name": "Blooming Pond", "stage": 7},
    {"name": "Delightful Pond", "stage": 8},
    {"name": "Ancient Aqueduct", "stage": 9}
  ],
  'Poplar_Trees':[
    {"name": "Poplar Tree Leaf", "stage": 0},
    {"name": "Sprouting Poplar", "stage": 1},
    {"name": "Growing Poplar", "stage": 2},
    {"name": "Young Poplar", "stage": 3},
    {"name": "Adult Poplar", "stage": 4},
    {"name": "Mature Poplar", "stage": 5},
    {"name": "Distinguished Poplar", "stage": 6},
    {"name": "Majestic Poplar", "stage": 7},
    {"name": "Old World Poplar", "stage": 8},
    {"name": "Poplar Ruins", "stage": 9},
    {"name": "Poplar Columnade", "stage": 10},
    {"name": "Appian Way", "stage": 11}
  ],
  'Precious_Gems':[
    {"name": "Glimmering Gem", "stage": 1},
    {"name": "Immaculate Gem", "stage": 2},
    {"name": "Flawless Gem", "stage": 3}
  ],
  'Recycled_Boosters':[
    {"name": "Booster Scraps", "stage": 1},
    {"name": "Booster Shards", "stage": 2},
    {"name": "Booster Box", "stage": 3},
    {"name": "Booster Crate", "stage": 4}
  ],
  'Rocks':[
    {"name": "Strange Slab", "stage": 1},
    {"name": "Unusual Boulder", "stage": 2},
    {"name": "Peculiar Mass", "stage": 3},
    {"name": "Curious Formation", "stage": 4},
    {"name": "Celtic Hand", "stage": 5},
    {"name": "Primal Obelisk", "stage": 6},
    {"name": "Druid Structure", "stage": 7},
    {"name": "Ancient Stone Circle", "stage": 8}
  ],
  'Roman_Ruins':[
    {"name": "Historic Fragments", "stage": 1},
    {"name": "Unearthed Stonework", "stage": 2},
    {"name": "Preserved Columns", "stage": 3},
    {"name": "Restored Columns", "stage": 4},
    {"name": "Theatrical Columns", "stage": 5},
    {"name": "Forum Balustrade", "stage": 6},
    {"name": "Aqueduct Support", "stage": 7},
    {"name": "Grand Portal", "stage": 8},
    {"name": "Nymphaeum", "stage": 9}
  ],
  'Rope':[
    {"name": "Scrap of Bark", "stage": 1},
    {"name": "Bark Rope", "stage": 2},
    {"name": "Rope Coil", "stage": 3},
    {"name": "Scaffolding", "stage": 4},
    {"name": "Bamboo Nursery", "stage": 5}
  ],
  'Rosebushes':[
    {"name": "Dainty Roses", "stage": 1},
    {"name": "Rose Thicket", "stage": 2},
    {"name": "Rose Hedge", "stage": 3},
    {"name": "Rose Sculpture", "stage": 4},
    {"name": "Rose Trellis", "stage": 5},
    {"name": "Rose Veranda", "stage": 6}
  ],
  'Secret_Wells':[
    {"name": "Hidden Spring", "stage": 1},
    {"name": "Secluded Reservoir", "stage": 2}
  ],
  'Timber':[
    {"name": "Timber Log", "stage": 1},
    {"name": "Timber Cuts", "stage": 2},
    {"name": "Timber Pile", "stage": 3},
    {"name": "Bundle of Timber", "stage": 4},
    {"name": "Lengths of Timber", "stage": 5},
    {"name": "Stack of Timber", "stage": 6},
    {"name": "Sturdy Timber Pile", "stage": 7},
    {"name": "Plentiful Timber Pile", "stage": 8},
    {"name": "Industrial Log Pile", "stage": 9}
  ],
  'Timber_Trunk':[
    {"name": "Handsome Timber Trunk", "stage": 1},
    {"name": "Exquisite Timber Trunk", "stage": 2}
  ],
  'Topiaries':[
    {"name": "Duckling Topiary", "stage": 1},
    {"name": "Bunny Topiary", "stage": 2},
    {"name": "Squirrel Topiary", "stage": 3},
    {"name": "Fox Topiary", "stage": 4},
    {"name": "Deer Topiary", "stage": 5},
    {"name": "Panda Topiary", "stage": 6},
    {"name": "Elephant Topiary", "stage": 7},
    {"name": "Royal Peacock Topiary", "stage": 8}
  ],
  "Tradesman's_Trunks":[
    {"name": "Sturdy Tradesman's Trunk", "stage": 1},
    {"name": "Solid Tradesman's Trunk", "stage": 2}
  ],
  'Treasure_Chests':[
    {"name": "Small Chest", "stage": 1},
    {"name": "Comely Chest", "stage": 2},
    {"name": "Elegant Chest", "stage": 3},
    {"name": "Handsome Chest", "stage": 4},
    {"name": "Charming Chest", "stage": 5},
    {"name": "Delightful Chest", "stage": 6},
    {"name": "Bountiful Chest", "stage": 7}
  ],
  'Tulips':[
    {"name": "Tulip Bulb", "stage": 0},
    {"name": "Yellow Tulip", "stage": 1},
    {"name": "Orange Tulips", "stage": 2},
    {"name": "Red Tulips", "stage": 3},
    {"name": "White Tulips", "stage": 4},
    {"name": "Tulip Bouquet", "stage": 5},
    {"name": "Punnet of Tulips", "stage": 6},
    {"name": "Barrel of Tulips", "stage": 7},
    {"name": "Barrow of Tulips", "stage": 8},
    {"name": "Wreath of Tulips", "stage": 9},
    {"name": "Dutch Windmill", "stage": 10}
  ],
  "Uncle_Elwood's_Experiment":[
    {"name": "Peculiar Potion", "stage": 1},
    {"name": "Mysterious Infusion", "stage": 2},
    {"name": "Strange Brew", "stage": 3},
    {"name": "Potent Concoction", "stage": 4}
  ],
  "Time_Skip":[
    {"name": "Small Time Skip", "stage": 1},
    {"name": "Medium Time Skip", "stage": 2},
    {"name": "Big Time Skip", "stage": 3},
    {"name": "Cuckoo Time Skip", "stage": 4},
  ],
  'Vegetable_Patches':[
    {"name": "Vegetable Nursery", "stage": 1},
    {"name": "Radish Patch", "stage": 2},
    {"name": "Carrot Patch", "stage": 3},
    {"name": "Eggplant Patch", "stage": 4},
    {"name": "Chili Patch", "stage": 5},
    {"name": "Prizewinning Pumpkin Patch", "stage": 6}
  ],
  'Vegetables':[
    {"name": "Radish", "stage": 1},
    {"name": "Carrot", "stage": 2},
    {"name": "Eggplant", "stage": 3},
    {"name": "Chili", "stage": 4}
  ],
  'Vines':[
    {"name": "Seedling Vine", "stage": 0},
    {"name": "Sprouting Vine", "stage": 1},
    {"name": "Growing Vine", "stage": 2},
    {"name": "Vine Trellis", "stage": 3},
    {"name": "Vine Portico", "stage": 4},
    {"name": "Vine Overhang", "stage": 5},
    {"name": "Vine Lattice", "stage": 6},
    {"name": "Vine Arbor", "stage": 7},
    {"name": "Vine Gazebo", "stage": 8},
    {"name": "Vine Summerhouse", "stage": 9},
    {"name": "Provincial Vineyard", "stage": 10}
  ],
  'Water_Wheels':[
    {"name": "Rustic Wheel", "stage": 1},
    {"name": "Quaint Mill", "stage": 2}
  ],
  'Wild_Flowers':[
    {"name": "Wild Flower Seed", "stage": 0},
    {"name": "Sprout", "stage": 1},
    {"name": "Dandelion", "stage": 2},
    {"name": "Buttercup", "stage": 3},
    {"name": "Daisy", "stage": 4},
    {"name": "Forget-Me-Not", "stage": 5},
    {"name": "Poppy", "stage": 6},
    {"name": "Hosta", "stage": 7},
    {"name": "Foxglove", "stage": 8},
    {"name": "Azalea", "stage": 9},
    {"name": "Peony", "stage": 10},
    {"name": "Hardy Hibiscus", "stage": 11},
    {"name": "Rhododendron", "stage": 12},
    {"name": "Hydrangea", "stage": 13},
    {"name": "Lustrous Flower Bed", "stage": 14},
    {"name": "Stunning Flower Bed", "stage": 15},
    {"name": "Exquisite Flower Bed", "stage": 16},
    {"name": "Magnificent Flower Bed", "stage": 17},
    {"name": "Glass House", "stage": 18}
  ],
  'Wildlife_Homes':[
    {"name": "Fine Bird House", "stage": 1},
    {"name": "Elegant Bird House", "stage": 2},
    {"name": "Exquisite Bird House", "stage": 3},
    {"name": "Delightful Home", "stage": 4},
    {"name": "Marvelous Home", "stage": 5},
    {"name": "Lavish Home", "stage": 6},
    {"name": "Magnificent Home", "stage": 7},
    {"name": "Divine Sanctuary", "stage": 8}
  ],
  'Wood_Storage':[
    {"name": "Wood Shelter", "stage": 1},
    {"name": "Wood Stash", "stage": 2},
    {"name": "Wood Shack", "stage": 3},
    {"name": "Wood Lean-to", "stage": 4},
    {"name": "Wood Shed", "stage": 5},
    {"name": "Wood Hut", "stage": 6},
    {"name": "Wood Cabin", "stage": 7},
    {"name": "Timber Cottage", "stage": 8}
  ],
  'Yard_Games':[
    {"name": "Soccer Ball", "stage": 1},
    {"name": "Connect Four", "stage": 2},
    {"name": "Croquet", "stage": 3},
    {"name": "Ring Toss", "stage": 4},
    {"name": "Chess", "stage": 5},
    {"name": "Lawn Match Cards", "stage": 6},
    {"name": "Darts", "stage": 7},
    {"name": "Tetherball", "stage": 8},
    {"name": "Giant Jenga", "stage": 9},
    {"name": "Bowling", "stage": 10},
    {"name": "Cornhole", "stage": 11},
    {"name": "Treehouse", "stage": 12}
  ],
  'Zen_Gardens':[
    {"name": "Zen Stones", "stage": 0},
    {"name": "Soothing Garden", "stage": 1},
    {"name": "Gentle Garden", "stage": 2},
    {"name": "Restful Garden", "stage": 3},
    {"name": "Sedate Garden", "stage": 4},
    {"name": "Peaceful Garden", "stage": 5},
    {"name": "Stoic Garden", "stage": 6},
    {"name": "Tranquil Garden", "stage": 7},
    {"name": "Quiescent Garden", "stage": 8},
    {"name": "Serene Garden", "stage": 9},
    {"name": "Enlightened Sanctuary", "stage": 10},
  ],
  'Garden_Guardians':[
    {"name": "Egg Relic", "stage": 1},
    {"name": "Bluebird Idol", "stage": 2},
    {"name": "Hummingbird Icon", "stage": 3},
    {"name": "Bat Relic", "stage": 4},
    {"name": "Butterfly Statue", "stage": 5},
    {"name": "Squirrel Giant", "stage": 6},
    {"name": "Bee Guard", "stage": 7},
    {"name": "Woodpecker Ward", "stage": 8},
    {"name": "Ladybug Guardian", "stage": 9}
  ],
};

List<Map> wildlifeStages= [
    {"name": "Eggs", "stage": 0},
    {"name": "Stage 1", "stage": 1},
    {"name": "Stage 2", "stage": 2},
    {"name": "Stage 3", "stage": 3},
    {"name": "Stage 4", "stage": 4},
    {"name": "Magnificent Eggs", "stage": 45},
    {"name": "Stage 5", "stage": 5},
    {"name": "Stage 6", "stage": 6},
    {"name": "Stage 7", "stage": 7},
    {"name": "Stage 8", "stage": 8},
  ];

List<Map> resources=[
  {"id": "resource:gem","name": "Gems", "stages": 3,'sources':[]},
  {"id": "resource:coin","name": "Coins", "stages": 9,'sources':[]},
  {"id": "resource:life","name": "Lives", "stages": 2,'sources':[]},
  {"id": "resource:puzzle-coin","name": "Puzzle Coins", "stages": 1,'sources':['puzzles']},
  {"id": "resource:token","name": "Tokens", "stages": 1,'sources':['weekly-board','offers']},
];
List<Map> sources=[
  {"id": "source:shop","name": "Shop"},
  {"id": "source:web-store","name": "Web Store" },
  {"id": "source:puzzle","name": "Puzzles"},
  {"id": "source:token-shop","name": "Token Shop"},
  {"id": "source:token-shop","name": "Daily Bonus"},
  {"id": "source:daily-package","name": "Daily Garden Package"},
  {"id": "source:richard-trade","name": "Richard's Trade"},
];

Map<String,Map> chainsExtensive={
  "Apiaries":{
    "title": "Apiaries",
    "subtitle": "A progressive production chain providing Honeycomb, Honey Jars, and Woodpecker or Honey Bee eggs.",
    "totalStages": 12,
    "masterpiece": 12,
    "items": [
      {
        "id":"Stage_0_-_Honey_Tree_Seed",
        "name": "Honey Tree Seed",
        "stage": 0,
        "sellValue": 0,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": 120,
        "growsInto": "Honey Tree Sprout",
        "description": "A sweet, golden seed that randomly spits from high-level ponds.",
        "descriptors": ["goodToHave"],
        "helpfulTips": ["Let it sit on an open tile; it will automatically sprout after 2 minutes."],
        "notes": ["Can be found spawning naturally from Stage 5+ Ponds."],
        "sourced": [
          {
            "options": ["Pond Stage 5", "Pond Stage 6"],
            "type": "secondary"
          }
        ],
        "mergingRewards": ["Honey Tree Sprout"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": true,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Honey Tree Sprout",
        "stage": 1,
        "sellValue": 1,
        "gemPrice": 4,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A fragile young sprout sticky with early sap.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Merge 5 sprouts together instead of 3 to save space and gain extra saplings."],
        "notes": ["Cannot be harvested yet."],
        "sourced": [
          {
            "options": ["Honey Tree Seed"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Honey Tree Sapling"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Honey Tree Sapling",
        "stage": 2,
        "sellValue": 2,
        "gemPrice": 8,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Growing taller and starting to attract passing garden insects.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Keep adjacent tiles clear so wildlife can easily work around it."],
        "notes": ["Purely an intermediate merge step item."],
        "sourced": [
          {
            "options": ["Honey Tree Sprout"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Growing Honey Tree"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Growing Honey Tree",
        "stage": 3,
        "sellValue": 4,
        "gemPrice": 15,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The first harvestable step of the Apiary line. Sticky honeycomb is forming.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Wildlife can now manually harvest this tree for raw honeycombs."],
        "notes": ["Yields 1 honeycomb per manual tap item update."],
        "sourced": [
          {
            "options": ["Honey Tree Sapling"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Young Honey Tree"],
        "spawnedItems": [],
        "tapRewards": ["Honeycomb"],
        "harvestRewards": ["Honeycomb"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Young Honey Tree",
        "stage": 4,
        "sellValue": 8,
        "gemPrice": 30,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Oozing a delicate nectar aroma through the surrounding garden plots.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Can be occasionally given out as dynamic event task milestones."],
        "notes": ["Spawns a Dainty Blue Basket upon initial generation or merge execution."],
        "sourced": [
          {
            "options": ["Growing Honey Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Handsome Honey Tree"],
        "spawnedItems": ["Dainty Blue Basket"],
        "tapRewards": ["Honeycomb"],
        "harvestRewards": ["Honeycomb"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Handsome Honey Tree",
        "stage": 5,
        "sellValue": 15,
        "gemPrice": 65,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A lush, vibrant honey-producing tree ready to shelter wild apiaries.",
        "descriptors": ["mustHave", "goodToHave"],
        "helpfulTips": ["Playing in game weekend events regularly guarantees a Stage 5 tree reward directly."],
        "notes": ["This is the fastest checkpoint stage to skip early seed processing."],
        "sourced": [
          {
            "options": ["Young Honey Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Lavender Apiary"],
        "spawnedItems": [],
        "tapRewards": ["Honeycomb"],
        "harvestRewards": ["Honeycomb"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Lavender Apiary",
        "stage": 6,
        "sellValue": 30,
        "gemPrice": 120,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 2,
        "tapLimit": 2,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Bees have begun constructing elaborate networks within these lavender boards.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Tapping now returns multiple raw Honeycombs directly."],
        "notes": ["The structure changes layout aesthetic to a managed wooden apiary shelf."],
        "sourced": [
          {
            "options": ["Handsome Honey Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Sunflower Apiary"],
        "spawnedItems": [],
        "tapRewards": ["Honeycomb"],
        "harvestRewards": ["Honeycomb"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Sunflower Apiary",
        "stage": 7,
        "sellValue": 65,
        "gemPrice": 250,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The harvest level transitions from simple honeycombs to processing whole Honey Jars.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Harvesting takes slightly longer, but yields refined Honey Jar objects."],
        "notes": ["Essential source for items required in complex trade requests."],
        "sourced": [
          {
            "options": ["Lavender Apiary"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Midsummer Apiary"],
        "spawnedItems": [],
        "tapRewards": ["Honey Jar"],
        "harvestRewards": ["Honey Jar"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Midsummer Apiary",
        "stage": 8,
        "sellValue": 125,
        "gemPrice": 480,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Buzzing loudly with high summer hive activity.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Keep wildlife stamina points ready; this level is heavily targetable for honey trades."],
        "notes": ["Often targeted by Richard's exchange post requests."],
        "sourced": [
          {
            "options": ["Sunflower Apiary"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Honeysuckle Apiary"],
        "spawnedItems": [],
        "tapRewards": ["Honey Jar"],
        "harvestRewards": ["Honey Jar"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Honeysuckle Apiary",
        "stage": 9,
        "sellValue": 250,
        "gemPrice": 900,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Sweet nectar scent dominates the layout map.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Clearing 5-merges at this stage minimizes structural congestion."],
        "notes": ["Takes up a standard 1x1 plot but visually overflows."],
        "sourced": [
          {
            "options": ["Midsummer Apiary"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Wisteria Apiary"],
        "spawnedItems": [],
        "tapRewards": ["Honey Jar"],
        "harvestRewards": ["Honey Jar"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Wisteria Apiary",
        "stage": 10,
        "sellValue": 500,
        "gemPrice": 1800,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 2,
        "tapLimit": 2,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "An magnificent layout draped in purple flowering wisteria vines.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Guarantees 2 direct Honey Jars upon a cycle tap trigger reset."],
        "notes": ["Pre-final stage before reaching the final masterpiece preparation threshold."],
        "sourced": [
          {
            "options": ["Honeysuckle Apiary"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Glorious Apiary"],
        "spawnedItems": [],
        "tapRewards": ["Honey Jar"],
        "harvestRewards": ["Honey Jar"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Glorious Apiary",
        "stage": 11,
        "sellValue": 1000,
        "gemPrice": 3500,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The peak merge tier structure before constructing the ultimate monument.",
        "descriptors": ["mustHave", "goodToHave"],
        "helpfulTips": ["Taps yield rare high-level Honey Caches instead of individual jars."],
        "notes": ["Harvesting loops still give regular Honey Jars efficiently."],
        "sourced": [
          {
            "options": ["Wisteria Apiary"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Magnificent Bee Statue"],
        "spawnedItems": [],
        "tapRewards": ["Honey Cache"],
        "harvestRewards": ["Honey Jar"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Magnificent Bee Statue",
        "stage": 12,
        "sellValue": 1500,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 10,
        "tapLimit": 10,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Beauty is in the eye of the beholder. The ultimate celebration of hive-mind creation.",
        "descriptors": ["decoration", "goodToHave"],
        "helpfulTips": ["Tap immediately upon creation to extract a flood of unique wildlife eggs and nests."],
        "notes": ["This is the definitive Masterpiece for this merge line. It can no longer be merged."],
        "sourced": [
          {
            "options": ["Glorious Apiary"],
            "type": "primary"
          }
        ],
        "mergingRewards": [],
        "spawnedItems": [],
        "tapRewards": ["Honey Bee Eggs", "Honey Bee Nests", "Charming Blue Basket"],
        "harvestRewards": ["Honey Cache"],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": true,
        "format": "2x2"
      }
    ]
  },
  "Fruits":{
    "title": "Fruits",
    "subtitle": "Harvested items meant for generation of currency structures and high-value chests.",
    "totalStages": 7,
    "masterpiece": null,
    "items": [
      {
        "name": "Apple",
        "stage": 1,
        "sellValue": 1,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A crisp red apple obtained from lower tier fruit trees.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Merge in groups of 5 to maximize coin outputs efficiently."],
        "notes": ["Can be fed to wildlife creatures or merged."],
        "sourced": [
          {
            "options": ["Fruit Tree Stage 4"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins", "Treasure Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Lemon",
        "stage": 2,
        "sellValue": 2,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A sour yellow citrus fruit.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Keep for puzzle-board dynamic needs or high coin trades."],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Apple"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Cherry",
        "stage": 3,
        "sellValue": 4,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A deep red cherry pair.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Lemon"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Banana",
        "stage": 4,
        "sellValue": 8,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A ripe yellow banana bunch.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Cherry"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Mango",
        "stage": 5,
        "sellValue": 12,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A juicy and sweet tropical mango.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Banana"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins", "Treasure Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Dragonfruit",
        "stage": 6,
        "sellValue": 16,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "An exotic vibrant dragonfruit.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Mango"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["High Tier Coins", "Handsome Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Durian",
        "stage": 7,
        "sellValue": 25,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The highest tier of harvestable sweet fruit in the regular garden map.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Selling directly gives 25 coins, but merging is much more optimal."],
        "notes": ["Stinky but exceptionally valuable."],
        "sourced": [
          {
            "options": ["Dragonfruit"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["High Tier Coins", "Handsome Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      }
    ]
  },

  "Fruit_Trees":{
    "title": "Fruits",
    "subtitle": "Harvested items meant for generation of currency structures and high-value chests.",
    "totalStages": 7,
    "masterpiece": null,
    "items": [
      {
        "name": "Apple",
        "stage": 1,
        "sellValue": 1,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A crisp red apple obtained from lower tier fruit trees.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Merge in groups of 5 to maximize coin outputs efficiently."],
        "notes": ["Can be fed to wildlife creatures or merged."],
        "sourced": [
          {
            "options": ["Fruit Tree Stage 4"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins", "Treasure Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Lemon",
        "stage": 2,
        "sellValue": 2,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A sour yellow citrus fruit.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Keep for puzzle-board dynamic needs or high coin trades."],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Apple"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Cherry",
        "stage": 3,
        "sellValue": 4,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A deep red cherry pair.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Lemon"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Banana",
        "stage": 4,
        "sellValue": 8,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A ripe yellow banana bunch.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Cherry"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Mango",
        "stage": 5,
        "sellValue": 12,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A juicy and sweet tropical mango.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Banana"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Coins", "Treasure Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Dragonfruit",
        "stage": 6,
        "sellValue": 16,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "An exotic vibrant dragonfruit.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Mango"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["High Tier Coins", "Handsome Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Durian",
        "stage": 7,
        "sellValue": 25,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The highest tier of harvestable sweet fruit in the regular garden map.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Selling directly gives 25 coins, but merging is much more optimal."],
        "notes": ["Stinky but exceptionally valuable."],
        "sourced": [
          {
            "options": ["Dragonfruit"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["High Tier Coins", "Handsome Chests"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": true,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      }
    ]
  },

  "Oak_Trees":{
    "title": "Oak Trees",
    "subtitle": "A primary source of Wood materials and Acorns, supporting structural garden progression.",
    "totalStages": 11,
    "masterpiece": 11,
    "items": [
      {
        "name": "Acorn",
        "stage": 0,
        "sellValue": 0,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": 120,
        "growsInto": "Oak Tree Sprout",
        "description": "A small nut that drops from mature Oak Trees or can be harvested from high-tier Grasses.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Leave it clear on the board; it will automatically turn into a Sprout after 2 minutes."],
        "notes": ["Can be purchased via Wood Trunks in the shop."],
        "sourced": [
          {
            "options": ["Oak Tree Stage 4", "Lush Grass"],
            "type": "secondary"
          }
        ],
        "mergingRewards": ["Oak Tree Sprout"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": true,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Oak Tree Sprout",
        "stage": 1,
        "sellValue": 1,
        "gemPrice": 4,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A tiny, fragile oak seedling pushing through the dirt.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Acorn"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Oak Tree Sapling"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Oak Tree Sapling",
        "stage": 2,
        "sellValue": 2,
        "gemPrice": 8,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A slender young oak sapling starting to harden its bark.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Oak Tree Sprout"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Small Oak Tree"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Small Oak Tree",
        "stage": 3,
        "sellValue": 4,
        "gemPrice": 15,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A young tree that passively drops Acorns on neighboring tiles over time.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Keep adjacent tiles open to gather free Acorns automatically."],
        "notes": ["Spawns Acorns periodically."],
        "sourced": [
          {
            "options": ["Oak Tree Sapling"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Oak Tree",
        "stage": 4,
        "sellValue": 8,
        "gemPrice": 30,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The first harvestable tier in the chain. Provides sturdy timber wood.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Wildlife can now manually harvest this tree for Timber Logs."],
        "notes": ["Also drops Acorns passively."],
        "sourced": [
          {
            "options": ["Small Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Large Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Timber Log"],
        "harvestRewards": ["Timber Log"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Large Oak Tree",
        "stage": 5,
        "sellValue": 15,
        "gemPrice": 65,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A larger, sturdy oak structure with thick canopy foliage.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Great Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Timber Log"],
        "harvestRewards": ["Timber Log"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Great Oak Tree",
        "stage": 6,
        "sellValue": 30,
        "gemPrice": 120,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Yields Wood Billets instead of simple logs upon harvesting.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Speeds up your Wood/Timber storage building requirements drastically."],
        "notes": ["Harvest returns higher tier wood resource assets."],
        "sourced": [
          {
            "options": ["Large Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Grand Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Wood Billet"],
        "harvestRewards": ["Wood Billet"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Grand Oak Tree",
        "stage": 7,
        "sellValue": 65,
        "gemPrice": 250,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "An ancient, impressive tree that anchors garden plots.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Great Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Majestic Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Wood Billet"],
        "harvestRewards": ["Wood Billet"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Majestic Oak Tree",
        "stage": 8,
        "sellValue": 125,
        "gemPrice": 480,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A massive timber giant that occasionally yields premium bird nests.",
        "descriptors": ["mustHave", "goodToHave"],
        "helpfulTips": ["Keep this stage for ongoing wood grinding cycles."],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Grand Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Ancient Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Wood Billet"],
        "harvestRewards": ["Wood Billet"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Ancient Oak Tree",
        "stage": 9,
        "sellValue": 250,
        "gemPrice": 900,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Twisted branches covered in moss, overflowing with age.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Majestic Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Elder Oak Tree"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Wood Billet"],
        "harvestRewards": ["Wood Billet"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Elder Oak Tree",
        "stage": 10,
        "sellValue": 500,
        "gemPrice": 1800,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The final standard pre-masterpiece step. Yields high density logs.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Prepare to merge 3 or 5 of these to unlock the ultimate timber structure."],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Ancient Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Yggdrasil Prototype"],
        "spawnedItems": ["Acorn"],
        "tapRewards": ["Strong Wood Bundle"],
        "harvestRewards": ["Wood Billet"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Yggdrasil Prototype",
        "stage": 11,
        "sellValue": 2500,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 10,
        "tapLimit": 10,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "The Tree of Life Masterpiece. Radiates pure ecosystem energy.",
        "descriptors": ["decoration", "goodToHave"],
        "helpfulTips": ["Tapping immediately triggers an explosion of Woodpecker Eggs."],
        "notes": ["Definitive Masterpiece for the Oak Tree line. Cannot be harvested further."],
        "sourced": [
          {
            "options": ["Elder Oak Tree"],
            "type": "primary"
          }
        ],
        "mergingRewards": [],
        "spawnedItems": [],
        "tapRewards": ["Woodpecker Eggs", "Woodpecker Nests", "Strong Wood Bundle"],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": true,
        "format": "2x2"
      }
    ]
  },

  "Grasses":{
    "title": "Grasses",
    "subtitle": "A lush vegetation chain providing abundant Grass Tufts, Moss, and a steady supply of Acorns.",
    "totalStages": 8,
    "masterpiece": 8,
    "items": [
      {
        "name": "Grass Tuft",
        "stage": 1,
        "sellValue": 1,
        "gemPrice": 3,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A small tuft of wild garden grass. Spawns naturally near water sources or from high-tier ponds.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["Can be harvested early on for seeds, but merging is more efficient."],
        "notes": ["Spawns from Stage 4+ Ponds over time."],
        "sourced": [
          {
            "options": ["Pond Stage 4", "Pond Stage 5"],
            "type": "secondary"
          }
        ],
        "mergingRewards": ["Scattered Grass"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Scattered Grass",
        "stage": 2,
        "sellValue": 2,
        "gemPrice": 6,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A few loose patches of green grass growing together.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Grass Tuft"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Patch of Grass"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Patch of Grass",
        "stage": 3,
        "sellValue": 4,
        "gemPrice": 12,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": null,
        "tapLimit": null,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "A solid patch of lawn starting to fill out nicely.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Scattered Grass"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Tufted Grass"],
        "spawnedItems": [],
        "tapRewards": [],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Tufted Grass",
        "stage": 4,
        "sellValue": 8,
        "gemPrice": 25,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Thick, fibrous grass stalks that creatures find highly attractive.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["The first tier that can be manually harvested for raw resources."],
        "notes": ["Wildlife can harvest this for Moss or Acorns."],
        "sourced": [
          {
            "options": ["Patch of Grass"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Tall Grass"],
        "spawnedItems": [],
        "tapRewards": ["Moss"],
        "harvestRewards": ["Moss", "Acorn"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Tall Grass",
        "stage": 5,
        "sellValue": 15,
        "gemPrice": 50,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Overgrown reeds swaying gently in the garden breeze.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Tufted Grass"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Lush Grass"],
        "spawnedItems": [],
        "tapRewards": ["Moss"],
        "harvestRewards": ["Moss", "Acorn"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Lush Grass",
        "stage": 6,
        "sellValue": 30,
        "gemPrice": 110,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Rich, healthy sod fields bursting with hidden insect life.",
        "descriptors": ["mustHave", "goodToHave"],
        "helpfulTips": ["Excellent midpoint stage for grinding Acorns if you need to grow your Oak Tree chain."],
        "notes": ["Has a significantly higher drop rate for Acorns when harvested."],
        "sourced": [
          {
            "options": ["Tall Grass"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Abundant Grass"],
        "spawnedItems": [],
        "tapRewards": ["Fresh Moss"],
        "harvestRewards": ["Fresh Moss", "Acorn"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Abundant Grass",
        "stage": 7,
        "sellValue": 65,
        "gemPrice": 240,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 1,
        "tapLimit": 1,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "Dense, vibrant green meadow turf before reaching final perfection.",
        "descriptors": ["mustHave"],
        "helpfulTips": ["unknown"],
        "notes": ["unknown"],
        "sourced": [
          {
            "options": ["Lush Grass"],
            "type": "primary"
          }
        ],
        "mergingRewards": ["Majestic Lawn"],
        "spawnedItems": [],
        "tapRewards": ["Fresh Moss"],
        "harvestRewards": ["Fresh Moss", "Acorn"],
        "daisyQuests": [],
        "richardTrade": true,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": false,
        "format": "1x1"
      },
      {
        "name": "Majestic Lawn",
        "stage": 8,
        "sellValue": 1250,
        "gemPrice": 0,
        "capacity": null,
        "spawnCount": null,
        "harvestLimit": null,
        "tapCount": 10,
        "tapLimit": 10,
        "resourceValue": null,
        "upgradeValue": null,
        "growingTime": null,
        "growsInto": null,
        "description": "An immaculately manicured royal botanical carpet. The pinnacle of groundcover creation.",
        "descriptors": ["decoration", "goodToHave"],
        "helpfulTips": ["Tapping immediately drops a flood of high-tier premium item chests and wildlife assets."],
        "notes": ["This is the definitive Masterpiece for the Grasses line. Cannot be merged or harvested."],
        "sourced": [
          {
            "options": ["Abundant Grass"],
            "type": "primary"
          }
        ],
        "mergingRewards": [],
        "spawnedItems": [],
        "tapRewards": ["Grasshopper Eggs", "Grasshopper Nests", "Handsome Chest"],
        "harvestRewards": [],
        "daisyQuests": [],
        "richardTrade": false,
        "vanishOnTap": false,
        "vanishOnHarvest": false,
        "vanishAfterSpawn": false,
        "dailyChecklist": true,
        "format": "2x2"
      }
    ],
  },
};


