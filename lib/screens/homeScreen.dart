import 'package:flutter/material.dart';
import 'package:recetario_practica_1/screens/loginScreen.dart';
import 'package:recetario_practica_1/screens/registrerScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Tasty Recipes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: Image.asset(
                'assets/imagenes/fondoComida.png',
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Nosotros Cuidamos tus Secretos de Cocina!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Bienvenido! con nuestra aplicación TastyRecipe podrás guardar tus recetas favoritas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 34),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loginscreen(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Registrerscreen()));
              },
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.black),
                side: const WidgetStatePropertyAll(
                  BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 110,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(4.0),
        width: double.infinity,
        color: Colors.black,
        child: const Text(
          'TextyRecipe 2024',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
