class Receta {
  final int? idReceta;
  final String nombreReceta;
  final String descripcionReceta;
  final String fotoReceta;
  final String instrucctionesReceta;
  final List<String> ingredientesReceta;
  final int tiempoReceta;
  final String? categoriaReceta;
  final int estadoReceta;
  final int? idUsuario;

  Receta({
    this.idReceta,
    required this.nombreReceta,
    required this.descripcionReceta,
    required this.fotoReceta,
    required this.instrucctionesReceta,
    required this.ingredientesReceta,
    required this.tiempoReceta,
    required this.categoriaReceta,
    required this.estadoReceta,
    required this.idUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'idReceta': idReceta,
      'nombreReceta': nombreReceta,
      'descripcionReceta': descripcionReceta,
      'fotoReceta': fotoReceta,
      'instruccionesReceta': instrucctionesReceta,
      'ingredientesReceta': ingredientesReceta.join(','),
      'tiempoReceta': tiempoReceta,
      'categoriaReceta': categoriaReceta,
      'estadoReceta': estadoReceta,
      'idUsuario': idUsuario,
    };
  }

  factory Receta.fromMap(Map<String, dynamic> map) {
    return Receta(
      idReceta: map['idReceta'],
      nombreReceta: map['idReceta'],
      descripcionReceta: map['nombreReceta'],
      fotoReceta: map['fotoReceta'],
      instrucctionesReceta: map['instruccionesReceta'],
      ingredientesReceta: List<String>.from(map['ingredientesReceta']),
      tiempoReceta: map['tiempoReceta'],
      categoriaReceta: map['categoriaReceta'],
      estadoReceta: map['estadoReceta'],
      idUsuario: map['idUsuario'],
    );
  }
}

class Usuario {
  final int? idUsuario;
  final String nombreUsuario;
  final String apellidoUsuario;
  final String correoUsuario;
  final String contraseniaUsuario;
  final String fotoUsuario;
  final int estadoUsuario;

  Usuario({
    this.idUsuario,
    required this.nombreUsuario,
    required this.apellidoUsuario,
    required this.correoUsuario,
    required this.contraseniaUsuario,
    required this.fotoUsuario,
    required this.estadoUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombreUsuario': nombreUsuario,
      'apellidoUsuario': apellidoUsuario,
      'correoUsuario': correoUsuario,
      'contraseniaUsuario': contraseniaUsuario,
      'fotoUsuario': fotoUsuario,
      'estadoUsuario': estadoUsuario,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['idUsuario'],
      nombreUsuario: map['nombreUsuario'],
      apellidoUsuario: map['apellidoUsuario'],
      correoUsuario: map['correoUsuario'],
      contraseniaUsuario: map['contraseniaUsuario'],
      fotoUsuario: map['fotoUsuario'],
      estadoUsuario: map['estadoUsuario'],
    );
  }
}
