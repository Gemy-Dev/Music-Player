import 'package:flutter/material.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/screens/player_screen.dart';
import 'package:music_player/utils/song_list.dart';

class SongsListScreen extends StatelessWidget {
  const SongsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body: ListView.builder(itemCount: songs.length,
      itemBuilder: (_,index)=>ListTile(onTap: ()async {
    await  MusicProvider.instance.setSong(songs[index].url);
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const PlayerScreen()));
    },
      title: Text(songs[index].title),)),);
  }
}