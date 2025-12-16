import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NombreMysterePage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}


class NombreMysterePage extends StatefulWidget {
  const NombreMysterePage({super.key});

  @override
  State<NombreMysterePage> createState() => _NombreMysterePageState();
}


class _NombreMysterePageState extends State<NombreMysterePage> {

  // ------------------------------
  // ÉTAPE 1 : Champ de saisie
  // ------------------------------
  final TextEditingController nombreCtrl = TextEditingController();


  // ------------------------------
  // ÉTAPE 2 : Appel du Web Service
  // ------------------------------
  Future<void> _envoyerNombre() async {
    final valeur = nombreCtrl.text.trim();

    // Vérification si le champ est vide
    if (valeur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nombre.")),
      );
      return;
    }

    // ------------------------------
    // ÉTAPE 3 : URL dynamique
    // {nombre} remplacé par le champ texte
    // ------------------------------
    final url = Uri.parse(
      "http://10.0.2.3:8888/Examen2020/$valeur",
    );

    try {
      // ------------------------------
      // ÉTAPE 4 : Requête HTTP GET
      // ------------------------------
      final response = await http.get(url);

      // ------------------------------
      // ÉTAPE 5 : SUCCÈS (200)
      // ------------------------------
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        return;
      }

      // ------------------------------
      // ÉTAPE 6 : ERREURS (400 ou 404)
      // ------------------------------
      if (response.statusCode == 400 || response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        return;
      }

      // ------------------------------
      // AUTRES ERREURS
      // ------------------------------
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur serveur (${response.statusCode})")),
      );
    }

    // ------------------------------
    // ÉTAPE 7 : ERREUR DE COMMUNICATION
    // ------------------------------
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de contacter le serveur."),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nombre mystère")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Champ texte
            SizedBox(
              width: 250,
              child: TextField(
                controller: nombreCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Entrez un nombre",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bouton
            ElevatedButton(
              onPressed: _envoyerNombre,
              child: const Text("Envoyer"),
            ),
          ],
        ),
      ),
    );
  }
}

