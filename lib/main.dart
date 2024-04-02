import 'package:flutter/material.dart';


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

