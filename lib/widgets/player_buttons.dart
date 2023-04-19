import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song_model.dart';

class PlayerButtons extends StatefulWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  _PlayerButtonsState createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  late int _currentSongIndex;
  late Song _currentSong;

  @override
  void initState() {
    super.initState();
    _currentSongIndex = 0;
    _currentSong = Song.songs[_currentSongIndex];
  }

  Future<void> _playNext() async {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % Song.songs.length;
      _currentSong = Song.songs[_currentSongIndex];
    });
    await widget.audioPlayer.setUrl(_currentSong.url);
    await widget.audioPlayer.play();
  }

  Future<void> _playPrevious() async {
    setState(() {
      (_currentSongIndex - 1 + Song.songs.length) % Song.songs.length;
      _currentSong = Song.songs[_currentSongIndex];
    });
    await widget.audioPlayer.setUrl(_currentSong.url);
    await widget.audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 35,
          onPressed: _playPrevious,
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState!.processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 64.0,
                  height: 64.0,
                  margin: const EdgeInsets.all(10.0),
                  child: const CircularProgressIndicator(),
                );
              } else if (!widget.audioPlayer.playing) {
                return IconButton(
                  onPressed: () async {
                    await widget.audioPlayer
                        .setUrl(Song.songs[_currentSongIndex].url);
                    await widget.audioPlayer.play();
                  },
                  iconSize: 75,
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                  iconSize: 75.0,
                  onPressed: () {
                    widget.audioPlayer.pause();
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                  iconSize: 75.0,
                  onPressed: () => widget.audioPlayer.seek(
                    Duration.zero,
                    index: widget.audioPlayer.effectiveIndices!.first,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        IconButton(
          iconSize: 35,
          onPressed: _playNext,
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
