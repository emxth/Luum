import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/yearly_report_model.dart';

class MonthlyTrendChart extends StatelessWidget {
  final List<YearlyReportModel> data;

  const MonthlyTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data.map((e) {
                return FlSpot(e.month.toDouble(), e.income);
              }).toList(),
            ),
            LineChartBarData(
              spots: data.map((e) {
                return FlSpot(e.month.toDouble(), e.expense);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
