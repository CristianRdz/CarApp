class CarModel {
  final String? id;
  final String mark;
  final String model;
  final double autonomy;
  final double topSpeed;

  CarModel({
    this.id,
    required this.mark,
    required this.model,
    required this.autonomy,
    required this.topSpeed,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      mark: json['mark'],
      model: json['model'],
      autonomy: json['autonomy'].toDouble(),
      topSpeed: json['topSpeed'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mark': mark,
      'model': model,
      'autonomy': autonomy,
      'topSpeed': topSpeed,
    };
  }
}