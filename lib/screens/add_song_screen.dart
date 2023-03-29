import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/song_model.dart';

class AddSongForm extends StatefulWidget {
  @override
  _AddSongFormState createState() => _AddSongFormState();
}

class _AddSongFormState extends State<AddSongForm> {
  String? filePath;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ajouter une musique',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(Icons.music_note),
                label: Text('Choisir une musique'),
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addSong,
                child: Text('Ajouter la musique'),
              ),
            ],
          ),
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
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
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
