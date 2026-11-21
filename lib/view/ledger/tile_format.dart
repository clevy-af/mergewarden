import 'package:flutter/material.dart';
import 'package:mergewarden/utils/colors.dart';

///rows: horizontal, x-axis. columns: vertical, y-axis.
class TileFormat {
  /// horizontal, x-axis.
  int rows;
  ///vertical, y-axis.
  int columns;

  ///rows: horizontal, x-axis. columns: vertical, y-axis.
  TileFormat(this.rows,this.columns);

  @override
  String toString() => toJson().toString();
  String toText() => '$rows x $columns';

  Map<String, dynamic> toJson() => {"rows": rows, "columns": columns,};

  factory TileFormat.fromJson(Map<String, dynamic> json) => TileFormat(
      int.parse(json["rows"]),  int.parse(json["columns"])
  );

}

void gridSizeBox(BuildContext context,TileFormat format) {
  showAdaptiveDialog(context: context,
      barrierDismissible: true,
      builder:(context) {
        int squares = format.rows*format.columns;
        return Dialog(
    child: Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cFillBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 8,),

              const Text("ITEM ON BOARD", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),

              CloseButton(),
            ],
          ),
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
          Text("${format.rows} × ${format.columns} ( $squares Square${squares==1?'':'s'} )", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    ) ,
  );
      });
}