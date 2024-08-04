class AutoModel {
  final int id;
  final String nombre;
  final String fabricante;
  final String autonomia;
  final int velocidadMaxima;

  AutoModel({
    required this.id,
    required this.nombre,
    required this.fabricante,
    required this.autonomia,
    required this.velocidadMaxima,
  });

  factory AutoModel.fromJson(List<dynamic> json) {
    return AutoModel(
      id: json[0] as int,
      nombre: json[1] as String,
      fabricante: json[2] as String,
      autonomia: json[3] as String,
      velocidadMaxima: json[4] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fabricante': fabricante,
      'autonomia': autonomia,
      'velocidadMaxima': velocidadMaxima,
    };
  }
}
