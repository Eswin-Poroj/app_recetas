import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recetario_practica_1/models/modelo.dart';

class RecetaBasesDeDatos {
  static Future<Database> initializadeDB() async {
    String path = join(await getDatabasesPath(), 'recetario');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Usuario(idUsuario INTEGER NOT NULL CONSTRAINT PK_Usuario PRIMARY KEY AUTOINCREMENT, nombreUsuario TEXT, apellidoUsuario TEXT, correoUsuario TEXT, contraseniaUsuario TEXT, fotoUsuario TEXT, estadoUsuario INTEGER);');
        await db.execute(
            'CREATE TABLE Receta(idReceta INTEGER NOT NULL CONSTRAINT PK_Receta PRIMARY KEY AUTOINCREMENT, nombreReceta TEXT,  descripcionReceta TEXT, fotoReceta TEXT, instruccionesReceta TEXT, ingredientesReceta TEXT, tiempoReceta INTEGER, categoriaReceta TEXT, estadoReceta INTEGER, idUsuario INTEGER, CONSTRAINT Relationship5 FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario));');

        await db
            .execute('CREATE INDEX IX_Relationship5 ON Receta (idUsuario);');
      },
      version: 1,
    );
  }

  /*METODOS DE LA TABLA USUARIO*/

  /*Insertar Usuario*/
  static Future<int> insertUsuario(Usuario user) async {
    final Database db = await initializadeDB();
    return await db.insert(
      'Usuario',
      user.toMap(),
    );
  }

  /*Actualizar Usuario*/
  static Future<int> updateUsuario(Usuario user) async {
    final Database db = await initializadeDB();
    return await db.update(
      'Usuario',
      user.toMap(),
      where: "idUsuario = ?",
      whereArgs: [user.idUsuario],
    );
  }

  /* Autenticar Usuario*/
  static Future<bool> autenticadeUser(String username, String password) async {
    final Database db = await initializadeDB();

    final List<Map<String, dynamic>> resultado = await db.query(
      'Usuario',
      where: "correoUsuario = ? AND contraseniaUsuario = ?",
      whereArgs: [username, password],
    );

    return resultado.isNotEmpty;
  }

  /* Verificar Existencia de Usuario al Registrar uno Nuevo */
  static Future<int?> verificarUsuario(String username, String password) async {
    final Database db = await initializadeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'Usuario',
      columns: ['idUsuario'],
      where: "correoUsuario = ? AND contraseniaUsuario = ?",
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first['idUsuario'] as int?;
    } else {
      return null;
    }
  }

  /* Obtener datos del Usuario con ID */

  static Future<Usuario?> readUser(int id) async {
    final Database db = await initializadeDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'Usuario',
      where: "idUsuario = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /* Eliminar Usuario (Cambiar de Estado) */
  static Future<int> deleteUser(Usuario user) async {
    final Database db = await initializadeDB();
    return await db.update(
      'Usuario',
      user.toMap(),
    );
  }

  /* Metodos de la tabla Receta */

  /* Insertar Receta */
  static Future<int> insertReceta(Receta receta) async {
    final Database db = await initializadeDB();
    return await db.insert(
      'Receta',
      receta.toMap(),
    );
  }

  /* Actualizar Receta */
  static Future<int> updateReceta(Receta receta) async {
    final Database db = await initializadeDB();
    return await db.update(
      'Receta',
      receta.toMap(),
      where: "idReceta = ?",
      whereArgs: [receta.idReceta],
    );
  }

  /* Leer Receta de Usuario en Especifico*/
  static Future<List<Receta>> readRecetaUser(int idUser) async {
    final Database db = await initializadeDB();
    final resultado = await db.query(
      'Receta',
      where: "estadoReceta = 1 AND idUsuario = ?",
      whereArgs: [idUser],
    );

    return resultado.map((json) => Receta.fromMap(json)).toList();
  }

  /* Leer Datos de Receta */
  static Future<Receta?> readReceta(int idReceta) async {
    final Database db = await initializadeDB();
    final resultado = await db.query(
      'Receta',
      columns: [
        'idReceta',
        'nombreReceta',
        'descripcionReceta',
        'fotoReceta',
        'instruccionesReceta',
        'ingredientesReceta',
        'tiempoReceta',
        'categoriaReceta',
      ],
      where: "idReceta = ?",
      whereArgs: [idReceta],
    );

    if (resultado.isNotEmpty) {
      return Receta.fromMap(resultado.first);
    } else {
      return null;
    }
  }

  /* Eliminar Receta (Cambiar de Estado) */

  static Future<int> deleteReceta(Receta receta) async {
    final Database db = await initializadeDB();
    return await db.update(
      "Receta",
      receta.toMap(),
      where: "idReceta  = ?",
      whereArgs: [receta.idReceta],
    );
  }

  /*Cerramos la Base de DAtos*/
  Future closeReceta() async {
    final Database db = await initializadeDB();
    db.close();
  }
}
