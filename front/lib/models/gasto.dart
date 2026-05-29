class Gasto {
  final int id;
  final double monto;
  final String categoria;
  final DateTime fechaGasto;
  final String descripcion;
  final String grupoId;

  Gasto({
    required this.id, required this.monto, required this.categoria,
    required this.fechaGasto, required this.descripcion, required this.grupoId,
  });

  // Esto convierte el JSON que viene de NestJS a un objeto Gasto
  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: json['id'],
      monto: double.parse(json['monto'].toString()),
      categoria: json['categoria'],
      fechaGasto: DateTime.parse(json['fecha_gasto']),
      descripcion: json['descripcion'],
      grupoId: json['grupo_id'],
    );
  }
}