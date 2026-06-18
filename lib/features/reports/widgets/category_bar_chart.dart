import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/chart_data.dart';

class CategoryBarChart extends StatelessWidget {
  final List<ChartData> data;

  const CategoryBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [BarChartRodData(toY: entry.value.value)],
            );
          }).toList(),
        ),
      ),
    );
  }
}
