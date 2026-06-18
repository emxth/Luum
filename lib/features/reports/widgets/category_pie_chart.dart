import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/chart_data.dart';

class CategoryPieChart extends StatelessWidget {
  final List<ChartData> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: data.map((item) {
            return PieChartSectionData(value: item.value, title: item.label);
          }).toList(),
        ),
      ),
    );
  }
}
