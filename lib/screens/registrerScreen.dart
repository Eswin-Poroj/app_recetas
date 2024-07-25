import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recetario_practica_1/database/db.dart';
import 'package:recetario_practica_1/models/modelo.dart';
import 'package:recetario_practica_1/screens/loginScreen.dart';
import 'package:recetario_practica_1/screens/recetasScreen.dart';

class Registrerscreen extends StatefulWidget {
  const Registrerscreen({super.key});

  @override
  State<Registrerscreen> createState() => _RegistrerscreenState();
}

class _RegistrerscreenState extends State<Registrerscreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswoordController =
      TextEditingController();
  File? _image;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void _registrarUsuario() async {
    try {
      String nombre = _nombreController.text;
      String apellido = _apellidoController.text;
      String correo = _correoController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswoordController.text;
      File? imagen = _image;

      bool usuarioExistente =
          await RecetaBasesDeDatos.autenticadeUser(correo, password);

      if (nombre.isEmpty ||
          apellido.isEmpty ||
          correo.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty ||
          imagen == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, rellena todos los campos'),
          ),
        );
      } else if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('La contraseña debe ser mayor a 8 digitos')));
      } else if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Las contraseñas no coinciden')));
      } else if (usuarioExistente) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'El usuario ya se encuetra registrado. Busca otro usuario o correo')));
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final imageName = '${DateTime.now().microsecondsSinceEpoch}.png';
        final localImage = await imagen.copy('$path/$imageName');

        Usuario user = Usuario(
          nombreUsuario: nombre,
          apellidoUsuario: apellido,
          correoUsuario: correo,
          contraseniaUsuario: password,
          fotoUsuario: localImage.path,
          estadoUsuario: 1,
        );

        await RecetaBasesDeDatos.insertUsuario(user);
        int? idUsuarioRegistrado =
            await RecetaBasesDeDatos.verificarUsuario(correo, password) as int;
        await Future.delayed(
          const Duration(
            seconds: 3,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario Registrado Exitosamente')));

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Recetasscreen(id: idUsuarioRegistrado)));
      }
    } catch (e) {
      print('Error en: $e');
    }
  }

  Future<void> _pickImage({required bool metodoCaptura}) async {
    try {
      final picker = ImagePicker();
      final pickerFile = await picker.pickImage(
          source: metodoCaptura ? ImageSource.camera : ImageSource.gallery);

      if (pickerFile != null) {
        setState(() {
          _image = File(pickerFile.path);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 50,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'TastyRecipes',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Ingrese su Nombre',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                'Ingrese su Apellido',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                'Ingrese su Usuario o Correo',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _correoController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                'Ingrese su Contraseña',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                      icon: Icon(_obscureText1
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
                obscureText: _obscureText1,
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                'Confirme su Contraseña',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _confirmPasswoordController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText2 = !_obscureText1;
                      });
                    },
                    icon: Icon(_obscureText2
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
              ),
              const Text(
                'Ingrese su Fotode Perfil',
                style: TextStyle(
                  fontSize: 20.0,
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
              _image == null
                  ? const Center(
                      child: Text('Sin Foto De Perfil'),
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        width: 280.0,
                        height: 280.0,
                        child: Image.file(
                          _image!,
                        ),
                      ),
                    ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('¿Ya tienes una cuenta?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginscreen(),
                          ),
                        );
                      },
                      child: const Text('Iniciar Sesión'))
                ],
              ),
              SizedBox(height: 15.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _registrarUsuario();
                  },
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.black),
                    side: const WidgetStatePropertyAll(
                      BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
