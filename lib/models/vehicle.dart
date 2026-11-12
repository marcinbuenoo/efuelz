class Vehicle {
  const Vehicle({
    required this.brand,
    required this.model,
    required this.year,
    required this.engine,
  });

  final String brand;
  final String model;
  final String year;
  final String engine;

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model': model,
        'year': year,
        'engine': engine,
      };

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        brand: json['brand'] as String,
        model: json['model'] as String,
        year: json['year'] as String,
        engine: json['engine'] as String,
      );
}
