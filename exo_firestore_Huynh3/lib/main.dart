import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {

  // Initialise Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examen Firestore',
      theme: ThemeData(useMaterial3: true),
      home: const ExamenFirestorePage(),
    );
  }
}

class ExamenFirestorePage extends StatefulWidget {
  const ExamenFirestorePage({super.key});

  @override
  State<ExamenFirestorePage> createState() => _ExamenFirestorePageState();
}
class _ExamenFirestorePageState extends State<ExamenFirestorePage> {
  // Champ texte pour le contenu
  final TextEditingController contenuCtrl = TextEditingController();


  // Ajouter Firestore
  Future<void> _ajouterDocument() async {
    final contenu = contenuCtrl.text.trim();

    if (contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un contenu.")),
      );
      return;

    }

    try {
      // Route pour Firestore
      // Examen > Final2025 > Eleve > ID auto
      await FirebaseFirestore.instance
          .collection("Examen")
          .doc("Final2025")
          .collection("Eleve")
          //.doc()
          .add({

        // Mes donnees
        "contenu": contenu,                 // String
        "numeroDePoste": 42,            // int
        "SurUneTablehaute": true,    // bool
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Votre document a été ajouté avec succès.")),
      );

      contenuCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Une erreur est survenue lors de l’enregistrement."),
        ),
      );
    }
  }


  // Mon interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Examen Question 1 Firestore")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Le bouton envoyer
          ElevatedButton(
              onPressed: _ajouterDocument,
              child: const Text("Envoyer"),
            ),


            const SizedBox(height: 15),
            // TextField pour mon texte a envoyer
            SizedBox(
              width: 250,
              child: TextField(
                controller: contenuCtrl,
                decoration: const InputDecoration(
                  labelText: "Votre contenu",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
