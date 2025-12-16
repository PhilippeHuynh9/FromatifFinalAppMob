import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // ------------------------------
  // ÉTAPE 1 : INITIALISATION FIREBASE
  // ------------------------------
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      title: 'Examen Firestore',
      theme: ThemeData(useMaterial3: true),
      home: const ExamenFirestorePage(),
    );
  }
}

// ------------------------------
// PAGE EXAMEN FIRESTORE
// ------------------------------
class ExamenFirestorePage extends StatefulWidget {
  const ExamenFirestorePage({super.key});

  @override
  State<ExamenFirestorePage> createState() => _ExamenFirestorePageState();
}

class _ExamenFirestorePageState extends State<ExamenFirestorePage> {

  // ------------------------------
  // ÉTAPE 2 : CHAMP TEXTE
  // ------------------------------
  final TextEditingController contenuCtrl = TextEditingController();

  // ------------------------------
  // ÉTAPE 3 : FONCTION D’AJOUT FIRESTORE
  // ------------------------------
  Future<void> _ajouterDocument() async {
    final contenu = contenuCtrl.text.trim();

    if (contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un contenu.")),
      );
      return;
    }

    try {
      // ------------------------------
      // ÉTAPE 4 : RÉFÉRENCE FIRESTORE PRÉCISE
      // Examen > Final2025 > Eleve > ID auto
      // ------------------------------
      await FirebaseFirestore.instance
          .collection("Examen")
          .doc("Final2025")
          .collection("Eleve")
          //.doc()
          .add({
        // ------------------------------
        // ÉTAPE 5 : DONNÉES DU DOCUMENT
        // ------------------------------
        "contenu": contenu,                 // String
        "numeroDePoste": 42,                // int (hardcodé)
        "SurUneTablehaute": true,           // bool (hardcodé)
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Document ajouté avec succès.")),
      );

      contenuCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de l'ajout du document."),
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
      appBar: AppBar(title: const Text("Examen Firestore")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ------------------------------
            // ÉTAPE 6 : DEUX BOUTONS AU CENTRE
            // ------------------------------
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _ajouterDocument,
                  child: const Text("Ajouter"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _ajouterDocument,
                  child: const Text("Envoyer"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------------------
            // ÉTAPE 7 : CHAMP TEXTE SOUS LES BOUTONS
            // ------------------------------
            SizedBox(
              width: 300,
              child: TextField(
                controller: contenuCtrl,
                decoration: const InputDecoration(
                  labelText: "Contenu à sauvegarder",
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
