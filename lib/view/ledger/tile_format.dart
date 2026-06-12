import 'package:flutter/material.dart';

class TileFormat {
  // horizontal, x-axis.
  int rows;
  ///vertical, y-axis.
  int columns;
  TileFormat(this.rows,this.columns);

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {"rows": rows, "columns": columns,};

  factory TileFormat.fromJson(Map<String, dynamic> json) => TileFormat(
      int.parse(json["rows"]),  int.parse(json["columns"])
  );

}

void _gridSizeBox(BuildContext context,TileFormat format) {
  showAdaptiveDialog(context: context, builder:(context) =>  Dialog(
    child: Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("BOARD SIZE", style: TextStyle(fontSize: 9, color: Colors.black54, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // 2x2 Mini Grid Visualizer
          SizedBox(
            width: 32,
            height: 32,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                // Highlight slots based on dimensions passed
                bool isOccupied = (format.rows == 2 && format.columns == 2) ||
                    (format.rows == 1 && index == 0); // Customize logic as needed
                return Container(
                  decoration: BoxDecoration(
                    color: isOccupied ? const Color(0xFF2D6A4F) : Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text("${format.rows} × ${format.columns} ( ${format.rows*format.columns} Squares)", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    ) ,
  ));
}