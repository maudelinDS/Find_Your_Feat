import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song_model.dart';

class TestTEs extends StatefulWidget {
  const TestTEs({Key? key}) : super(key: key);

  @override
  _TestTEsState createState() => _TestTEsState();
}

class _TestTEsState extends State<TestTEs> {
  late AudioPlayer audioPlayer;
  int currentSongIndex = 0;
  int like = 0;
  int dislike = 0;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioPlayer.setFilePath(Song.songs[currentSongIndex].url);
  }

  void playSong(int index) async {
    await audioPlayer.stop();
    setState(() {
      currentSongIndex = index;
    });
    await audioPlayer.setFilePath(Song.songs[index].url);

    await audioPlayer.play();
  }

  void playNextSong() {
    int nextIndex = (currentSongIndex + 1) % Song.songs.length;
    playSong(nextIndex);
  }

  void playPreviousSong() {
    int previousIndex = (currentSongIndex - 1) % Song.songs.length;
    if (previousIndex < 0) {
      previousIndex = Song.songs.length - 1;
    }
    playSong(previousIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade800,
        elevation: 0,
        title: const Text('Find Your Feat'),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                Song.songs[currentSongIndex].coverUrl,
                fit: BoxFit.fitWidth,
                height: 100,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              Song.songs[currentSongIndex].title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              Song.songs[currentSongIndex].description,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: playPreviousSong,
                  icon: const Icon(
                    Icons.skip_previous,
                  ),
                ),
                IconButton(
                  onPressed: () => playSong(currentSongIndex),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () => audioPlayer.pause(),
                  icon: const Icon(Icons.pause),
                ),
                IconButton(
                  onPressed: playNextSong,
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
