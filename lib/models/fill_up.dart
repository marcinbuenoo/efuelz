class FillUp {
  const FillUp({
    required this.fuel,
    required this.price,
    required this.odometer,
    required this.liters,
    required this.date,
  });

  final String fuel;
  final double price;
  final double odometer;
  final double liters;
  final DateTime date;

  double get total => price * liters;

  Map<String, dynamic> toJson() => {
        'fuel': fuel,
        'price': price,
        'odometer': odometer,
        'liters': liters,
        'date': date.toIso8601String(),
      };

  factory FillUp.fromJson(Map<String, dynamic> json) => FillUp(
        fuel: json['fuel'] as String,
        price: (json['price'] as num).toDouble(),
        odometer: (json['odometer'] as num).toDouble(),
        liters: (json['liters'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}
