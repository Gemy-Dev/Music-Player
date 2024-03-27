import 'package:flutter/material.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/screens/songs_screen_list.dart';
import 'package:music_player/utils/song_list.dart';

import 'screens/player_screen.dart';

void main()async {

  runApp(const MusicPlayer());
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      themeMode: ThemeMode.dark,
   
      theme: ThemeData.dark(
        
       
        useMaterial3: false,
      ),
      home: const PlayerScreen(),
    );
  }
}

