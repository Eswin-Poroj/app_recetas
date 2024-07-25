import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recetario_practica_1/database/db.dart';
import 'package:recetario_practica_1/models/modelo.dart';
import 'package:recetario_practica_1/screens/add_recipeScreen.dart';
import 'package:recetario_practica_1/screens/editRecipeScreen.dart';

class Recetasscreen extends StatefulWidget {
  final int id;
  const Recetasscreen({super.key, required this.id});

  @override
  State<Recetasscreen> createState() => _RecetasscreenState();
}

class _RecetasscreenState extends State<Recetasscreen> {
  final TextEditingController _buscador = TextEditingController();
  List<Receta> _receta = [];
  List<Receta> _recetaFiltrada = [];

  @override
  void initState() {
    super.initState();
    _obtenerRecetas();
  }

  void _buscarCategoria(String busqueda) {
    try {
      setState(() {
        if (busqueda.isEmpty) {
          _recetaFiltrada = _receta;
        } else {
          _recetaFiltrada = _receta.where((receta) {
            return receta.categoriaReceta!
                .toLowerCase()
                .contains(busqueda.toLowerCase());
          }).toList();
        }
      });
    } catch (e) {
      print('Error en $e');
    }
  }

  void _obtenerRecetas() async {
    try {
      final recetas = await RecetaBasesDeDatos.readRecetaUser(widget.id);
      setState(() {
        _receta = recetas;
        _recetaFiltrada = recetas;
      });
    } catch (e) {
      print("Errorr en $e");
    }
  }

  Image _convertirImagen(String img) {
    try {
      if (img.isNotEmpty) {
        return Image.file(
          File(img),
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
            'https://img.freepik.com/foto-gratis/ingredientes-hacer-bollos-o-pasteles-mermelada-peras-frescas-sobre-fondo-madera-vista-superior-copiar-espacio_127032-2842.jpg?t=st=1721886526~exp=1721890126~hmac=1daf5be15fc49a1f6fdba56c822c90d9345d77ff1305ba2642640915f9d5d70b&w=740');
      }
    } catch (e) {
      return Image.network(
          'https://img.freepik.com/foto-gratis/ingredientes-hacer-bollos-o-pasteles-mermelada-peras-frescas-sobre-fondo-madera-vista-superior-copiar-espacio_127032-2842.jpg?t=st=1721886526~exp=1721890126~hmac=1daf5be15fc49a1f6fdba56c822c90d9345d77ff1305ba2642640915f9d5d70b&w=740');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu),
            Text('Bienvedido ${widget.id}'),
          ],
        ),
      ),
      endDrawer: Drawer(child: Container()),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  controller: _buscador,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar recetas por Categorías...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (value) {
                    _buscarCategoria(value);
                  },
                ),
              ),
              _recetaFiltrada.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _recetaFiltrada.length,
                      itemBuilder: (context, index) {
                        final receta = _recetaFiltrada[index];
                        return Container(
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: Image.file(
                                      File(receta.fotoReceta),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      'Categoria: ${receta.categoriaReceta}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          bool? result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Editrecipescreen(
                                                      receta: receta),
                                            ),
                                          );
                                          if (result != null && result) {
                                            _obtenerRecetas();
                                          }
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipescreen(
                id: widget.id,
              ),
            ),
          );
          if (result != null && result) {
            _obtenerRecetas();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
