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
      home: const ExoErreursPage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ExoErreursPage extends StatefulWidget {
  const ExoErreursPage({super.key});

  @override
  State<ExoErreursPage> createState() => _ExoErreursPageState();
}

class _ExoErreursPageState extends State<ExoErreursPage> {
  final TextEditingController dividendeCtrl = TextEditingController();
  final TextEditingController diviseurCtrl = TextEditingController();

  Future<void> _diviser() async {
    final dividende = dividendeCtrl.text.trim();
    final diviseur = diviseurCtrl.text.trim();

    if (dividende.isEmpty || diviseur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer deux nombres.")),
      );
      return;
    }

    final url = Uri.parse(
      "https://examen-final-a24.azurewebsites.net/Exam2024/Division/$dividende/$diviseur",
    );

    try {
      final response = await http.get(url);

      // ----- Erreur côté serveur (ex: diviseur = 0) -----
      if (response.statusCode == 400) {
        final data = json.decode(response.body);
        final errorMsg = data["error"] ?? "Erreur inconnue";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $errorMsg")),
        );
        return;
      }

      // ----- Tout va bien (code 200) -----
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resultat = data["resultat"];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Résultat : $resultat")),
        );
        return;
      }

      // ----- Autre erreur -----
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur serveur (${response.statusCode}).")),
      );
    }

    // ----- Erreur de communication (pas de réseau, timeout, etc.) -----
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible de contacter le serveur : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Division API")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 280,
              child: TextField(
                controller: dividendeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Dividende",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280,
              child: TextField(
                controller: diviseurCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Diviseur",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _diviser,
              child: const Text("Diviser"),
            ),
          ],
        ),
      ),
    );
  }
}
