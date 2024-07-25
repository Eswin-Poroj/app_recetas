import 'package:flutter/material.dart';
import 'package:recetario_practica_1/database/db.dart';
import 'package:recetario_practica_1/screens/recetasScreen.dart';
import 'package:recetario_practica_1/screens/registrerScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _iniciarSesion() async {
    try {
      String correo = _correoController.text;
      String password = _passwordController.text;

      if (correo.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Rellene todos los campos por favor!'),
          ),
        );
      }

      final bool = await RecetaBasesDeDatos.autenticadeUser(correo, password);

      dynamic idUser =
          await RecetaBasesDeDatos.verificarUsuario(correo, password);

      if (bool) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recetasscreen(
              id: idUser,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o Contraseña Incorrecta. Intente de Nuevo!'),
          ),
        );
      }
    } catch (e) {
      print('Fallo en $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                height: 24.0,
              ),
              const Text(
                'Usuario o Correo',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _passwordController,
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
                height: 25.0,
              ),
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _correoController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
                obscureText: _obscureText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('¿No tienes una cuenta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Registrerscreen(),
                        ),
                      );
                    },
                    child: const Text('Registrate'),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _iniciarSesion();
                  },
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
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
