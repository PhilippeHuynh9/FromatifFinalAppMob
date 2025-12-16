// ------------------------------
// IMPORTATIONS
// ------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

// ------------------------------
// FONCTION PRINCIPALE
// Initialise Firebase avant de lancer l'app
// ------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// ------------------------------
// WIDGET RACINE DE L'APPLICATION
// ------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

// ------------------------------
// PAGE PRINCIPALE (STATEFUL)
// ------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ------------------------------
// ÉTAT DE LA PAGE
// Contient les variables et la logique Firestore
// ------------------------------
class _MyHomePageState extends State<MyHomePage> {

  // ------------------------------
  // CONTRÔLEUR DU CHAMP COURRIEL
  // ------------------------------
  final TextEditingController emailController = TextEditingController();

  // ------------------------------
  // VARIABLES D'AFFICHAGE
  // ------------------------------
  String nom = '';
  String age = '';
  String message = '';

  // ------------------------------
  // FONCTION : CHARGER LES DONNÉES
  // Lit un document Firestore
  // ------------------------------
  //Lire le document users/{courriel}
  void _charger() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')          // Collection Firestore
          .doc(emailController.text)    // ID du document
          .get();                        // Lecture

//Si le document existe : afficher le nom et l’age
      if (doc.exists) {
        setState(() {
          nom = doc['nom'];
          age = doc['age'].toString();
          message = '';
        });

        //Sinon : afficher le message « Utilisateur introuvable »
      } else {
        setState(() {
          nom = '';
          age = '';
          message = 'Utilisateur introuvable';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Erreur lors du chargement';
      });
    }
  }

  // ------------------------------
  // FONCTION : METTRE À JOUR L'ÉTAT
  // Modifie le champ "actif"
  // ------------------------------
  //À l’appui sur le bouton « Activer » : Mettre le champ actif à true
  void _activer() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')          // Collection Firestore
          .doc(emailController.text)    // ID du document
          .update({'actif': true});     // Mise à jour

//Afficher un message de confirmation
      setState(() {
        message = 'Utilisateur activé';
      });
    } catch (e) {
      setState(() {
        message = 'Erreur lors de la mise à jour';
      });
    }
  }

  // ------------------------------
  // CONSTRUCTION DE L'INTERFACE
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),

      // ------------------------------
      // CONTENU PRINCIPAL
      // ------------------------------
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ------------------------------
            // CHAMP DE SAISIE DU COURRIEL Un TextField pour entrer un courriel
            // ------------------------------
            SizedBox(
              width: 280,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Courriel',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------
            // BOUTONS D'ACTION
            // ------------------------------
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Un bouton « Charger »
                ElevatedButton(
                  onPressed: _charger,
                  child: const Text('Charger'),
                ),
                const SizedBox(width: 20),
                //Un bouton « Activer »
                ElevatedButton(
                  onPressed: _activer,
                  child: const Text('Activer'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ------------------------------
            // AFFICHAGE DES DONNÉES
            // ------------------------------
            //Deux Text pour afficher le nom et l’âge
            Text('Nom : $nom'),
            const SizedBox(height: 8),
            Text('Âge : $age'),

            const SizedBox(height: 16),

            // ------------------------------
            // MESSAGE D'ERREUR / CONFIRMATION
            // ------------------------------
            Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
//Explique la différence entre set() et update() dans Firestore : set() permet de créer ou remplacer un document,
// tandis que update() modifie seulement des champs existants et échoue si le document n’existe pas.
