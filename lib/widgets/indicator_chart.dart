import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IndicatorChart extends StatelessWidget {
  const IndicatorChart({
    required this.title,
    required this.unit,
    required this.values,
    super.key,
  });

  final String title;
  final String unit;
  final List<double> values;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(unit,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .62), fontSize: 12)),
            const SizedBox(height: 16),
            SizedBox(
              height: 148,
              child: values.isEmpty
                  ? Center(
                      child: Text('Aguardando o próximo abastecimento',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .62))))
                  : LineChart(_chartData(
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: .12),
                    )),
            ),
          ],
        ),
      );

  LineChartData _chartData(Color chartColor, Color gridColor) => LineChartData(
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: gridColor, strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 24)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: chartColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: chartColor.withValues(alpha: .14)),
            spots: values
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
          ),
        ],
      );
}
