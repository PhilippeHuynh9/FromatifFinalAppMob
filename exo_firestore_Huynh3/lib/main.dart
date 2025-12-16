// ------------------------------
// IMPORTATIONS
// ------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

// ------------------------------
// FONCTION PRINCIPALE
// Initialise Firebase
// ------------------------------
Future<void> main() async {
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
      title: 'Examen Firestore Produits',
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
// ------------------------------
class _MyHomePageState extends State<MyHomePage> {

  // ------------------------------
  // ÉTAPE 1 : RÉCUPÉRER LA SAISIE UTILISATEUR
  // ------------------------------
  final TextEditingController produitController = TextEditingController();

  // ------------------------------
  // VARIABLES D'AFFICHAGE
  // ------------------------------
  String prix = '';
  String etat = '';
  String message = '';

  // ------------------------------
  // ÉTAPE 2 : RECHERCHER LE PRODUIT
  // Utilise where() car l'ID est inconnu
  // ------------------------------
  QueryDocumentSnapshot? produitTrouve;
//À l’appui sur « Rechercher » : Rechercher dans la collection produits
  void _rechercher() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('produits')                 // Collection
          .where('nom', isEqualTo: produitController.text) // Condition
          .get();                                 // Lecture
//Si trouvé : afficher le prix
      if (query.docs.isNotEmpty) {
        produitTrouve = query.docs.first;
//afficher l’état (Disponible ou Indisponible)
        setState(() {
          prix = produitTrouve!['prix'].toString();
          etat = produitTrouve!['disponible']
              ? 'Disponible'
              : 'Indisponible';
          message = '';
        });

        //Sinon : afficher « Produit introuvable »
      } else {
        setState(() {
          prix = '';
          etat = '';
          message = 'Produit introuvable';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Erreur lors de la recherche';
      });
    }
  }

  // ------------------------------
  // ÉTAPE 3 : METTRE À JOUR LE PRODUIT
  // ------------------------------
//À l’appui sur « Marquer disponible » : Mettre le champ disponible à true
  void _marquerDisponible() async {

    if (produitTrouve == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('produits')          // Collection
          .doc(produitTrouve!.id)          // ID du document trouvé
          .update({'disponible': true});   // Mettre à jour le document trouvé

      setState(() {
        etat = 'Disponible';
        message = 'Produit mis à jour';
      });
    } catch (e) {
      setState(() {
        message = 'Erreur lors de la mise à jour';
      });
    }
  }

  // ------------------------------
  // ÉTAPE 4 : CONSTRUIRE L'INTERFACE
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examen Firestore – Produits'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ------------------------------
            // CHAMP DE SAISIE DU NOM DU PRODUIT
            // ------------------------------
            //Un TextField pour entrer le nom du produit
            SizedBox(
              width: 280,
              child: TextField(
                controller: produitController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit',
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
                //Un bouton « Rechercher »
                ElevatedButton(
                  onPressed: _rechercher,
                  child: const Text('Rechercher'),
                ),
                const SizedBox(width: 20),
                //Un bouton « Marquer disponible »
                ElevatedButton(
                  onPressed: _marquerDisponible,
                  child: const Text('Marquer disponible'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ------------------------------
            // AFFICHAGE DES DONNÉES
            // ------------------------------
            //Deux Text pour afficher le prix et l’état
            Text('Prix : $prix \$'),
            const SizedBox(height: 8),
            Text('État : $etat'),

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
// Pourquoi utiliser where() au lieu de doc() dans ce cas ?: On utilise where() parce que l’ID du document n’est pas connu.
// La recherche se fait à partir d’un champ du document (ex. nom) et non de son identifiant.
// La méthode doc() ne peut être utilisée que lorsque l’ID du document est connu à l’avance.