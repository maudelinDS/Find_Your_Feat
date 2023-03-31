import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song_model.dart';

class FindYourFeatScreen extends StatefulWidget {
  const FindYourFeatScreen({Key? key}) : super(key: key);

  @override
  _FindYourFeatScreenState createState() => _FindYourFeatScreenState();
}

class _FindYourFeatScreenState extends State<FindYourFeatScreen> {
  Song song = Get.arguments ?? Song.songs[0];

  late AudioPlayer audioPlayer;
  int currentSongIndex = 0;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioPlayer.setFilePath(Song.songs[currentSongIndex].url);
  }

  void updateSongCount(bool isLiked) {
    setState(() {
      if (isLiked) {
        Song.songs[currentSongIndex].like++;
      } else {
        Song.songs[currentSongIndex].dislike++;
      }
    });
  }

  void updateSuperLikeSongCount() {
    setState(() {
      Song.songs[currentSongIndex].superlike++;
    });
  }

  void playSong(int index) async {
    await audioPlayer.stop();
    setState(() {
      currentSongIndex = index;
    });
    await audioPlayer.setFilePath(Song.songs[index].url);

    await audioPlayer.play();
  }

  void likeSong() {
    int nextIndex = (currentSongIndex + 1) % Song.songs.length;
    playSong(nextIndex);
    print("like");

    updateSongCount(true);
    print(Song.songs[currentSongIndex].title);

    print(Song.songs[currentSongIndex].like);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vous avez Like',
        ),
        backgroundColor: Colors.blue, // Ajout de la couleur d'arrière-plan
      ),
    );
  }

  void superLikeSong() {
    int nextIndex = (currentSongIndex + 1) % Song.songs.length;
    playSong(nextIndex);
    updateSuperLikeSongCount();
    print("Superlike");
    print(Song.songs[currentSongIndex].title);
    print(Song.songs[currentSongIndex].superlike);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vous avez superLike',
        ),
        backgroundColor: Colors.green, // Ajout de la couleur d'arrière-plan
      ),
    );
  }

  void dislikeSong() {
    int nextIndex = (currentSongIndex + 1) % Song.songs.length;
    playSong(nextIndex);
    updateSongCount(false);
    print("Dislike :");
    print(Song.songs[currentSongIndex].title);
    print(Song.songs[currentSongIndex].dislike);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vous avez Dislike',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Find Your Feat'),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              Song.songs[currentSongIndex].coverUrl,
              fit: BoxFit.cover,
            ),
          ),
          const _BackgroundFilter(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 500),
                  child: Container(
                    child: Text(
                      Song.songs[currentSongIndex].title,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  Song.songs[currentSongIndex].description,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 80),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: dislikeSong,
                              icon: const Icon(
                                Icons.thumb_down,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        Song.songs[currentSongIndex].dislike.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: superLikeSong,
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        Song.songs[currentSongIndex].superlike.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: likeSong,
                              icon: const Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Song.songs[currentSongIndex].like.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
