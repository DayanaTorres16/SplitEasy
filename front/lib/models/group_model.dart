class UsuarioMiembro {
  final int id;
  final String nombre;
  final String? email;

  UsuarioMiembro({required this.id, required this.nombre, this.email});

  factory UsuarioMiembro.fromJson(Map<String, dynamic> json) {
    return UsuarioMiembro(
      id: json['id'] ?? 0, 
      nombre: json['nombre'] ?? 'Sin nombre',
      email: json['email'],
    );
  }
}

class GrupoModel {
  final String id;
  final String nombre;
  final String? descripcion;
  final int iconoIndex;
  final List<UsuarioMiembro> miembros;

  GrupoModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.iconoIndex,
    required this.miembros,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(
      id: (json['id'] ?? "0").toString(),
      nombre: json['nombre'] ?? 'Sin nombre',
      descripcion: json['descripcion'] ?? '',
      iconoIndex: json['iconoIndex'] ?? 0,
      miembros: (json['miembros'] as List<dynamic>?)?.map((m) => UsuarioMiembro.fromJson(m as Map<String, dynamic>)).toList() ?? [],
    );
  }
}