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

  // Champ Texte
  final TextEditingController nombreCtrl = TextEditingController();


  // Appel le Web Service
  Future<void> _envoyerNombre() async {
    final valeur = nombreCtrl.text.trim();
    // Si le champ est vide
    if (valeur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nombre.")),
      );
      return;
    }

    // URL remplacé {nombre} par le champ texte
    final url = Uri.parse(
      "http://10.0.2.3:8888/Examen2020/$valeur",
    );
    try {
      // Requête HTTP GET
      final response = await http.get(url);

      //  Si Succes (200)
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        return;
      }

      // ------------------------------
      // Si Erreurs clients (400, 404)
      // ------------------------------
      if (response.statusCode == 400 || response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        return;
      }
      // autres erreurs serveur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur serveur (${response.statusCode})")),
      );
    }
    // Si une erreur de communication avec le serveur
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de contacter le serveur."),
        ),
      );
    }
  }
  //Mon interface
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
 //Qu’est-ce qu’un cookie ?
//
// Un cookie est fichier dont le site web ou l’application que nous visitons enregistre les donnees de l’utilisateur. Il sert principalement à mémoriser ou bien reconnaître si l’utilisateur est nouveau ou non.
// Dans notre cours, on a vu les cookies dans notre tp2 et tp3 surtout lors de la connexion. Par exemple, quand on fait un signin ou un signup, le serveur garde les informations de l’utilisateur. Plus récemment,
// dans le TP3, le cookie est utilisé lors de l’authentification. Lorsqu'on se connecte a notre application, le serveur crée un cookie qui permet de vérifier l’identité de l’utilisateur.
