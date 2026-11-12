import 'package:flutter/material.dart';
import '../models/fill_up.dart';
import '../models/vehicle.dart';
import '../theme/app_theme.dart';
import '../widgets/fill_up_tile.dart';
import '../widgets/indicator_chart.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.vehicle,
    required this.fills,
    required this.onShowHistory,
    super.key,
  });

  final Vehicle vehicle;
  final List<FillUp> fills;
  final VoidCallback onShowHistory;

  double? _distance(int index) =>
      index == 0 ? null : fills[index].odometer - fills[index - 1].odometer;

  List<double> _values(bool consumption) {
    final values = <double>[];
    for (var i = 1; i < fills.length; i++) {
      final distance = _distance(i)!;
      if (distance <= 0 || fills[i].liters <= 0) continue;
      values.add(consumption ? distance / fills[i].liters : fills[i].total / distance);
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = fills.fold<double>(0, (total, fill) => total + fill.total);
    final consumptions = _values(true);
    final average = consumptions.isEmpty
        ? null
        : consumptions.reduce((a, b) => a + b) / consumptions.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppTheme.ink,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_car_filled_outlined,
                      color: Color(0xFFB7E2C8)),
                  const SizedBox(width: 8),
                  Text('${vehicle.year}  •  ${vehicle.engine} cc',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 22),
              Text('${vehicle.brand} ${vehicle.model}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Seu resumo de direção',
                  style: TextStyle(color: Colors.white60)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            MetricCard(
              title: 'Gasto total',
              value: 'R\$ ${totalSpent.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(width: 12),
            MetricCard(
              title: 'Consumo médio',
              value: average == null ? '—' : '${average.toStringAsFixed(1)} km/L',
              icon: Icons.speed_outlined,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Indicadores',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        IndicatorChart(
            title: 'Consumo por abastecimento', unit: 'km/L', values: _values(true)),
        const SizedBox(height: 12),
        IndicatorChart(
            title: 'Custo por distância', unit: 'R\$/km', values: _values(false)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Abastecimentos recentes',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            TextButton(onPressed: onShowHistory, child: const Text('Ver todos')),
          ],
        ),
        if (fills.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
            child: const Text(
              'Seu primeiro abastecimento será a referência para os indicadores de consumo.',
              textAlign: TextAlign.center,
            ),
          )
        else
          ...fills.reversed.take(3).map((fill) {
            final index = fills.indexOf(fill);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FillUpTile(
                fillUp: fill,
                isFirst: index == 0,
                distance: _distance(index),
              ),
            );
          }),
      ],
    );
  }
}
