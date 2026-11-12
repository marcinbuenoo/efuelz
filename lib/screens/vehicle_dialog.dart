import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicle_catalog.dart';

class VehicleDialog extends StatefulWidget {
  const VehicleDialog({super.key});

  @override
  State<VehicleDialog> createState() => _VehicleDialogState();
}

class _VehicleDialogState extends State<VehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _year = TextEditingController();
  final _engine = TextEditingController();
  final _catalog = VehicleCatalog();
  List<Map<String, dynamic>> _brands = [];
  List<Map<String, dynamic>> _models = [];
  String? _brand;
  String? _model;
  bool _loadingBrands = true;
  bool _loadingModels = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await _catalog.brands();
      if (mounted) setState(() => _brands = brands);
    } catch (_) {
      if (mounted) setState(() => _apiError = 'Não foi possível carregar as marcas. Verifique sua conexão.');
    } finally {
      if (mounted) setState(() => _loadingBrands = false);
    }
  }

  Future<void> _selectBrand(String? value) async {
    setState(() {
      _brand = value;
      _model = null;
      _models = [];
      _apiError = null;
      _loadingModels = value != null;
    });
    if (value == null) return;
    final selected = _brands.firstWhere((item) => item['nome'] == value);
    try {
      final models = await _catalog.models(selected['valor'].toString());
      if (mounted) setState(() => _models = models);
    } catch (_) {
      if (mounted) setState(() => _apiError = 'Não foi possível carregar os modelos desta marca.');
    } finally {
      if (mounted) setState(() => _loadingModels = false);
    }
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Informe $label.' : null;

  @override
  void dispose() {
    _year.dispose();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Seu veículo'),
        content: SizedBox(
          width: 380,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('Conte um pouco sobre o carro que você usa.'),
                    ),
                  ),
                  if (_loadingBrands) const LinearProgressIndicator(),
                  DropdownButtonFormField<String>(
                    value: _brand,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Marca'),
                    items: _brands
                        .map((item) => DropdownMenuItem<String>(
                              value: item['nome'] as String,
                              child: Text(item['nome'] as String),
                            ))
                        .toList(),
                    validator: (value) => _required(value, 'a marca'),
                    onChanged: _loadingBrands ? null : _selectBrand,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _model,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Modelo',
                      suffixIcon: _loadingModels
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                    items: _models
                        .map((item) => DropdownMenuItem<String>(
                              value: item['modelo'] as String,
                              child: Text(item['modelo'] as String,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    validator: (value) => _required(value, 'o modelo'),
                    onChanged: _loadingModels ? null : (value) => setState(() => _model = value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _year,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Ano'),
                    validator: (value) => _required(value, 'o ano'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _engine,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cilindrada (cc)'),
                    validator: (value) => _required(value, 'a cilindrada'),
                  ),
                  if (_apiError != null) ...[
                    const SizedBox(height: 12),
                    Text(_apiError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate() || _brand == null || _model == null) return;
              Navigator.pop(
                context,
                Vehicle(brand: _brand!, model: _model!, year: _year.text.trim(), engine: _engine.text.trim()),
              );
            },
            child: const Text('Salvar veículo'),
          ),
        ],
      );
}
