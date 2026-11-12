import 'package:flutter/material.dart';
import '../models/fill_up.dart';

class FillUpTile extends StatelessWidget {
  const FillUpTile({
    required this.fillUp,
    required this.isFirst,
    required this.distance,
    super.key,
  });

  final FillUp fillUp;
  final bool isFirst;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    final efficiency = distance != null && distance! > 0
        ? distance! / fillUp.liters
        : null;
    final costPerKm = distance != null && distance! > 0
        ? fillUp.total / distance!
        : null;
    final date = fillUp.date;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(Icons.local_gas_station,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fillUp.fuel,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(
                        '${_two(date.day)}/${_two(date.month)}/${date.year}  •  ${fillUp.odometer.toStringAsFixed(0)} km',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .68), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text('R\$ ${fillUp.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${fillUp.liters.toStringAsFixed(2)} L  ×  R\$ ${fillUp.price.toStringAsFixed(2)}/L',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .68), fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  efficiency == null
                      ? (isFirst ? 'Referência inicial' : 'Sem distância')
                      : '${efficiency.toStringAsFixed(2)} km/L  •  R\$ ${costPerKm!.toStringAsFixed(2)}/km',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
