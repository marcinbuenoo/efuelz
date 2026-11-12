import 'package:flutter/material.dart';
import '../models/fill_up.dart';
import '../widgets/fill_up_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({required this.fills, super.key});

  final List<FillUp> fills;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        children: [
          Text('Abastecimentos',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 25,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('${fills.length} ${fills.length == 1 ? 'registro' : 'registros'}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .68))),
          const SizedBox(height: 18),
          if (fills.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: Theme.of(context).colorScheme.primary, size: 34),
                  SizedBox(height: 12),
                  Text('Ainda não há abastecimentos.',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Toque em “Abastecer” para registrar o primeiro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .68))),
                ],
              ),
            )
          else
            ...fills.reversed.map((fill) {
              final index = fills.indexOf(fill);
              final distance = index == 0
                  ? null
                  : fills[index].odometer - fills[index - 1].odometer;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FillUpTile(
                  fillUp: fill,
                  isFirst: index == 0,
                  distance: distance,
                ),
              );
            }),
        ],
      );
}
