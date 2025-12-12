import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
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
      title: 'Firestore Exercice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Exercice Firestore'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Remplacez par votre vrai matricule
  final String matricule = '2161459';
  String info1 = '';
  String info2 = '';

  void _obtenir() async {
    final doc = await FirebaseFirestore.instance
        .collection('etudiants')
        .doc(matricule)
        .get();

    if (doc.exists) {
      setState(() {
        info1 = doc['nom'];
        info2 = doc['prenom'];
      });
    } else {
      setState(() {
        info1 = "Document non trouvé";
        info2 = "";
      });
    }
  }

  void _mettreAJour() async {
    await FirebaseFirestore.instance
        .collection('etudiants')
        .doc(matricule)
        .update({
      'complete': true,
    });

    setState(() {
      info1 = "Information mise à jour";
      info2 = "complete = true";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _obtenir,
                  child: const Text('Obtenir'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _mettreAJour,
                  child: const Text('Mettre à jour'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- BOÎTE 1 ---
            SizedBox(
              width: 280,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: info1),
              ),
            ),

            const SizedBox(height: 24),

            // --- BOÎTE 2 ---
            SizedBox(
              width: 280,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Prenom',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: info2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
