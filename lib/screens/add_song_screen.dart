import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/song_model.dart';
import '../models/user_model.dart';

class AddSongForm extends StatefulWidget {
  @override
  _AddSongFormState createState() => _AddSongFormState();
}

class _AddSongFormState extends State<AddSongForm> {
  String? filePath;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String _id;

  String get id => _id;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'ogg'],
    );

    if (result != null) {
      setState(() async {
        final String? copiedFilePath =
            await _copyAudioFile(result.files.single.path!);
        filePath = copiedFilePath;
      });
    }
  }

  // copier la musique ajouter par l'utilisateur
  // le répertoire de stockage de l'application en utilisant la méthode getApplicationDocumentsDirectory()
  // a bibliothèque path pour extraire le nom du fichier audio à partir de son chemin source,
  //copier le fichier source vers le fichier de destination en utilisant la méthode copy() de la bibliothèque dart:io, et nous renvoyons le chemin de destination.
  Future<String?> _copyAudioFile(String sourceFilePath) async {
    final Directory? appDir = await getApplicationDocumentsDirectory();
    if (appDir == null) {
      return null;
    }
    final String fileName = path.basename(sourceFilePath);
    final String destFilePath = path.join(appDir.path, fileName);
    final File sourceFile = File(sourceFilePath);
    final File destFile = File(destFilePath);

    print(destFile);
    await sourceFile.copy(destFilePath);
    return destFile.path;
  }

  void _addSong() {
    if (filePath == null) {
      // Afficher un message d'erreur si aucun fichier audio n'a été sélectionné.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez sélectionner un fichier audio.'),
      ));
    } else if (titleController.text.isEmpty) {
      // Afficher un message d'erreur si aucun titre n'a été entré.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez entrer un titre pour la chanson.'),
      ));
    } else if (descriptionController.text.isEmpty) {
      // Afficher un message d'erreur si aucune description n'a été entrée.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez entrer une description pour la chanson.'),
      ));
    } else {
      // Créer une nouvelle instance de la classe Song avec les informations entrées par l'utilisateur.
      Song newSong = Song(
        id: id,
        title: titleController.text,
        description: descriptionController.text,
        url: filePath!,
        coverUrl: 'assets/images/default_cover.jpg',
        like: 0,
        dislike: 0,
        superlike: 0,
      );

      // Ajouter la nouvelle chanson à la liste des chansons.
      Song.songs.add(newSong);

      // Afficher un aperçu des informations de la chanson.
      showDialog(
        context: context,
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Aperçu',
              style: TextStyle(color: Colors.red),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Titre: ${titleController.text}',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Description: ${descriptionController.text}',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Fichier audio: $filePath',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Ajouter la chanson à la liste des chansons et fermer le formulaire.
                    Song.songs.add(
                      Song(
                        id: id,
                        title: titleController.text,
                        description: descriptionController.text,
                        url: filePath!,
                        coverUrl: 'assets/images/default-cover.jpg',
                        like: 0,
                        dislike: 0,
                        superlike: 0,
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Ajouter la musique'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final loggedInUsername = userModel.loggedInUsername;
    Uuid uuid = Uuid();
    String id = uuid.v4();
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          title: Text(
            'Ajouter une musique',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          titleTextStyle: TextStyle(color: Colors.black),
        ),
        body: Stack(
          children: [
            _BackgroundFilter(),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: Icon(Icons.music_note),
                      label: Text('Choisir une musique'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Titre',
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      initialValue: '$loggedInUsername',
                      enabled: false,
                      decoration: InputDecoration(
                          labelText: "Username : ",
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _addSong,
                      child: Text('Ajouter la musique'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple,
              Colors.deepPurple.shade600.withOpacity(0.0),
              Colors.deepPurple.shade100.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200.withOpacity(0.8),
              Colors.deepPurple.shade800.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }
}
