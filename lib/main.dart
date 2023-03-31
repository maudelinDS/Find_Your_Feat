import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/models/user_moder.dart';
import 'package:my_app/screens/add_song_screen.dart';
import 'package:my_app/screens/find_your_feat_screen.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/playlist_screen.dart';
import 'package:my_app/screens/song_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your Feat',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        GetPage(name: '/playlist', page: () => const PlaylistScreen()),
        GetPage(name: '/add_Song', page: () => AddSongForm()),
        GetPage(
          name: '/find_your_feat',
          page: () => const FindYourFeatScreen(),
        ),
      ],
    );
  }
}
