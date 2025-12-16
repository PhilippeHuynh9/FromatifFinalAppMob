import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ------------------------------
// APPLICATION PRINCIPALE
// ------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'formatif HTTP Soustraction',
      theme: ThemeData(useMaterial3: true),
      home: const ExoHttpPage(),
    );
  }
}

// ------------------------------
// PAGE EXO HTTP
// ------------------------------
class ExoHttpPage extends StatefulWidget {
  const ExoHttpPage({super.key});

  @override
  State<ExoHttpPage> createState() => _ExoHttpPageState();
}

class _ExoHttpPageState extends State<ExoHttpPage> {

  // ------------------------------
  // ÉTAPE 1 : CHAMPS DE SAISIE
  // ------------------------------
  final TextEditingController valeurACtrl = TextEditingController();
  final TextEditingController valeurBCtrl = TextEditingController();

  // ------------------------------
  // ÉTAPE 2 : FONCTION POUR APPELER L'API
  // ------------------------------
  //Remplacer {a} et {b} par le contenu des champs de saisie
  Future<void> _calculer() async {
    final a = valeurACtrl.text.trim();
    final b = valeurBCtrl.text.trim();

    // Vérification si les champs sont remplis
    if (a.isEmpty || b.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer deux valeurs.")),
      );
      return;
    }

    // Construction de l'URL dynamique
    final url = Uri.parse(
      "https://examen-final-a24.azurewebsites.net/Exam2024/Soustraction/$a/$b",
    );

    try {
      // ------------------------------
      // ÉTAPE 3 : REQUÊTE HTTP GET
      // ------------------------------
      //À l’appui sur le bouton « Calculer » : Envoyer une requête HTTP GET
      final response = await http.get(url);

      // ------------------------------
      // ÉTAPE 4 : SUCCÈS (code 200)
      // ------------------------------
      //Si la requête réussit (code 200) : Décoder la réponse JSON
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Décoder le JSON
        final resultat = data['resultat'];      // Extraire le résultat

        //Afficher le résultat dans un SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Résultat : $resultat")),
        );
        return;
      }

      // ------------------------------
      // ÉTAPE 5 : ERREUR SERVEUR (code 400+)
      // ------------------------------
      //Si le serveur retourne une erreur (code 400)
      final data = json.decode(response.body);
      final messageErreur = data['message'] ?? "Erreur serveur inconnue";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(messageErreur)),
      );
    }

    // ------------------------------
    // ÉTAPE 6 : ERREUR DE COMMUNICATION
    // ------------------------------
    //Si l’application ne parvient pas à communiquer avec le serveur : Afficher un message clair et en français dans un SnackBar
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de communiquer avec le serveur."),
        ),
      );
    }
  }

  // ------------------------------
  // INTERFACE UTILISATEUR
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Soustraction API")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Champ Valeur A
            SizedBox(
              width: 280,
              child: TextField(
                controller: valeurACtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Valeur A",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Champ Valeur B
            SizedBox(
              width: 280,
              child: TextField(
                controller: valeurBCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Valeur B",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bouton Calculer
            ElevatedButton(
              onPressed: _calculer,
              child: const Text("Calculer"),
            ),
          ],
        ),
      ),
    );
  }
}
