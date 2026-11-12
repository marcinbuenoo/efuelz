import 'package:flutter/material.dart';
import '../models/fill_up.dart';
import '../models/vehicle.dart';
import '../services/local_store.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'fill_up_dialog.dart';
import 'history_screen.dart';
import 'vehicle_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.isDark, required this.onToggleTheme, super.key});

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _store = LocalStore();
  Vehicle? _vehicle;
  List<FillUp> _fills = [];
  bool _loading = true;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final saved = await _store.load();
      _vehicle = saved.$1;
      _fills = saved.$2;
    } catch (_) {
      // The empty state remains usable if local storage cannot be read.
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() => _store.save(_vehicle, _fills);

  Future<void> _addVehicle() async {
    final vehicle = await showDialog<Vehicle>(
      context: context,
      builder: (_) => const VehicleDialog(),
    );
    if (vehicle == null) return;
    setState(() {
      _vehicle = vehicle;
      _fills = [];
      _tab = 0;
    });
    await _save();
  }

  Future<void> _addFillUp() async {
    final fill = await showDialog<FillUp>(
      context: context,
      builder: (_) => const FillUpDialog(),
    );
    if (fill == null) return;
    setState(() {
      _fills = [..._fills, fill]..sort((a, b) => a.date.compareTo(b.date));
    });
    await _save();
  }

  Future<void> _deleteVehicle() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_outline, color: Theme.of(dialogContext).colorScheme.primary),
        title: const Text('Excluir veículo?'),
        content: const Text(
            'O veículo e todo o histórico de abastecimentos serão removidos.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Manter')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() {
      _vehicle = null;
      _fills = [];
      _tab = 0;
    });
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: AppTheme.purple, borderRadius: BorderRadius.circular(11)),
              child: const Icon(Icons.route_outlined,
                  size: 19, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('e-FUELZ',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.isDark ? 'Ativar tema claro' : 'Ativar tema escuro',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
          if (_vehicle != null)
            IconButton(
              tooltip: 'Excluir veículo',
              onPressed: _deleteVehicle,
              icon: const Icon(Icons.delete_outline),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _vehicle == null
          ? _EmptyVehicle(onAddVehicle: _addVehicle)
          : IndexedStack(
              index: _tab,
              children: [
                DashboardScreen(
                  vehicle: _vehicle!,
                  fills: _fills,
                  onShowHistory: () => setState(() => _tab = 1),
                ),
                HistoryScreen(fills: _fills),
              ],
            ),
      bottomNavigationBar: _vehicle == null
          ? null
          : NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (index) => setState(() => _tab = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.space_dashboard_outlined),
                  selectedIcon: Icon(Icons.space_dashboard),
                  label: 'Resumo',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Histórico',
                ),
              ],
            ),
      floatingActionButton: _vehicle == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _addFillUp,
              icon: const Icon(Icons.add),
              label: const Text('Abastecer'),
            ),
    );
  }
}

class _EmptyVehicle extends StatelessWidget {
  const _EmptyVehicle({required this.onAddVehicle});

  final VoidCallback onAddVehicle;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(34)),
                child: Icon(Icons.directions_car_filled_outlined,
                    size: 52, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 26),
              const Text('Sua jornada começa aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(
                'Cadastre seu veículo e acompanhe consumo e gastos em cada quilômetro.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .68), height: 1.45),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAddVehicle,
                icon: const Icon(Icons.add),
                label: const Text('Cadastrar veículo'),
              ),
            ],
          ),
        ),
      );
}
