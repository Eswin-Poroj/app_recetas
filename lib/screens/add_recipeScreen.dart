// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recetario_practica_1/database/db.dart';
import 'package:recetario_practica_1/models/modelo.dart';

class AddRecipescreen extends StatefulWidget {
  final int id;
  const AddRecipescreen({super.key, required this.id});

  @override
  State<AddRecipescreen> createState() => _AddRecipescreenState();
}

class _AddRecipescreenState extends State<AddRecipescreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreRecetaController = TextEditingController();
  final TextEditingController _instruccionesController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  File? _imagenReceta;

  final List<String> items = [
    'Desayuno',
    'Almuerzo',
    'Cena',
    'Postre',
    'Bebidas',
    'Panes',
  ];
  String? categoriaSeleccionada;

  Future<void> _pickImage({required bool metodoCaptura}) async {
    try {
      final picker = ImagePicker();
      final pickerFile = await picker.pickImage(
          source: metodoCaptura ? ImageSource.camera : ImageSource.gallery);

      if (pickerFile != null) {
        setState(() {
          _imagenReceta = File(pickerFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al Seleccionar la Imagen'),
          ),
        );
      }
    } catch (e) {
      print('Fallo la captura de imagen en: $e');
    }
  }

  void _guardarReceta() async {
    try {
      String nombreReceta = _nombreRecetaController.text;
      String descripcionReceta = _descripcionController.text;
      String instruccionesReceta = _instruccionesController.text;
      String ingredientesReceta = _ingredientesController.text;
      String tiempoReceta = _tiempoController.text;
      File? imagen = _imagenReceta;

      if (nombreReceta.isEmpty ||
          descripcionReceta.isEmpty ||
          instruccionesReceta.isEmpty ||
          ingredientesReceta.isEmpty ||
          tiempoReceta.isEmpty ||
          imagen == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, llene todos los campos')));
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final imageName = '${DateTime.now().microsecondsSinceEpoch}.png';
        final localImage = await imagen.copy('$path/$imageName');
        final receta = Receta(
          nombreReceta: nombreReceta,
          descripcionReceta: descripcionReceta,
          fotoReceta: localImage.path,
          instrucctionesReceta: instruccionesReceta,
          ingredientesReceta: ingredientesReceta.split(','),
          tiempoReceta: int.parse(tiempoReceta),
          categoriaReceta: categoriaSeleccionada,
          estadoReceta: 1,
          idUsuario: widget.id,
        );
        await RecetaBasesDeDatos.insertReceta(receta);
        await Future.delayed(const Duration(seconds: 3));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receta Guardada Correctamente')));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Error en: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al Guardar Receta')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Agregar Receta',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              _guardarReceta();
            },
            child: const Icon(
              Icons.save,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _nombreRecetaController,
                    decoration: InputDecoration(
                      labelText: 'Ingrese el nombre',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripcion de la Recta',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: const Text('Seleccione la Categoría'),
                      items: items
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      value: categoriaSeleccionada,
                      onChanged: (String? value) {
                        setState(() {
                          categoriaSeleccionada = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _ingredientesController,
                    decoration: InputDecoration(
                      labelText: 'Ingredientes (Separados por coma)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _instruccionesController,
                    decoration: const InputDecoration(
                      labelText: 'Instrucciones de la Receta',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _tiempoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tiempo de la Preparacion (Minutos)',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _pickImage(metodoCaptura: true);
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      onPressed: () {
                        _pickImage(metodoCaptura: false);
                      },
                      icon: const Icon(
                        Icons.add_photo_alternate,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _imagenReceta == null
                    ? const Center(
                        child: Text('Ninguna Fotografía Seleccionada'),
                      )
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          width: 280.0,
                          height: 280.0,
                          child: Image.file(
                            _imagenReceta!,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
