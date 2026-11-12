import 'package:flutter/material.dart';
import '../models/fill_up.dart';

class FillUpDialog extends StatefulWidget {
  const FillUpDialog({super.key});

  @override
  State<FillUpDialog> createState() => _FillUpDialogState();
}

class _FillUpDialogState extends State<FillUpDialog> {
  final _formKey = GlobalKey<FormState>();
  final _price = TextEditingController();
  final _odometer = TextEditingController();
  final _liters = TextEditingController();
  String _fuel = 'Gasolina';
  DateTime _date = DateTime.now();

  double? _parse(String? value) =>
      double.tryParse((value ?? '').trim().replaceAll(',', '.'));

  String? _positive(String? value, String label) {
    final number = _parse(value);
    if (number == null || number <= 0) return 'Informe $label maior que zero.';
    return null;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    setState(() => _date = DateTime(date.year, date.month, date.day, _date.hour, _date.minute));
    if (!mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_date));
    if (time != null && mounted) {
      setState(() => _date = DateTime(_date.year, _date.month, _date.day, time.hour, time.minute));
    }
  }

  @override
  void dispose() {
    _price.dispose();
    _odometer.dispose();
    _liters.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Novo abastecimento'),
        content: SizedBox(
          width: 380,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _fuel,
                    decoration: const InputDecoration(labelText: 'Combustível'),
                    items: const ['Etanol', 'Gasolina', 'Diesel']
                        .map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel)))
                        .toList(),
                    onChanged: (value) => setState(() => _fuel = value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _price,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Preço por litro (R\$)'),
                    validator: (value) => _positive(value, 'um preço'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _odometer,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quilometragem (km)'),
                    validator: (value) {
                      final number = _parse(value);
                      return number == null || number < 0 ? 'Informe uma quilometragem válida.' : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _liters,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Litros abastecidos'),
                    validator: (value) => _positive(value, 'uma quantidade'),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text('Data e horário'),
                    subtitle: Text(_formatDate(_date)),
                    trailing: const Icon(Icons.edit_outlined, size: 18),
                    onTap: _pickDate,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              Navigator.pop(
                context,
                FillUp(
                  fuel: _fuel,
                  price: _parse(_price.text)!,
                  odometer: _parse(_odometer.text)!,
                  liters: _parse(_liters.text)!,
                  date: _date,
                ),
              );
            },
            child: const Text('Salvar abastecimento'),
          ),
        ],
      );

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
