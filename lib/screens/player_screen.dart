

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song_duration.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/widget/play_controllers.dart';
import 'package:music_player/widget/songs_list.dart';
import 'package:music_player/widget/volum_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';


class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
                            final music = MusicProvider.instance;
    return
     Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage( 'assets/images/bg.png',),opacity: .3,fit: BoxFit.fill)),
      child:
       Scaffold(extendBodyBehindAppBar: true,
        backgroundColor:  Colors.transparent,
        appBar: AppBar(elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: ListenableBuilder(
                        listenable: MusicProvider.instance,
                        builder: (context, pro) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                            CircleAvatar(radius: 100,
                              child: ClipRRect(borderRadius: BorderRadius.circular(100),
                                child:music.currentSong==null?const Icon(Icons.music_note,size: 100,): QueryArtworkWidget(artworkWidth: 180,artworkHeight: 180,
                                  id:music.currentSong!.id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.music_note,size: 100,),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                              left: 0,
                              top: 80,
                              child: Icon(
                                CupertinoIcons.volume_off,
                                color: Colors.grey[500],
                              )),
                          Positioned(
                              right: 0,
                              top: 80,
                              child: Icon(
                                CupertinoIcons.volume_up,
                                color: Colors.grey[500],
                              )),
                          const VolumSlider()
                        ],
                      ),
                    ),
               const SizedBox(height: 30,),
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          MusicProvider.instance.currentSong?.title??'No Name',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                            
                          
                 if(music.player.currentIndex!=null)    PlayControllers(),
                    DurationSlider(music: music),
                            const SizedBox(height: 20,),
                     Expanded(child: ClipRRect(
        borderRadius: BorderRadius.circular(10),

        child: const Songs()))
                  
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

class DurationSlider extends StatelessWidget {
  const DurationSlider({
    super.key,
    required this.music,
  });

  final MusicProvider music;
String timeFormate(Duration duration){
String twoDigits(int n) => n.toString().padLeft(2, "0");
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SongDuration>(
      stream: music.getSongDuration(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Slider(
                      thumbColor: const Color(0xFF753A88),activeColor:   const Color(0xFFCC2B5E),
                      inactiveColor:
                          const Color.fromARGB(255, 79, 79, 80),
                      value: snapshot.data?.position.inSeconds.toDouble()??0,
                      max: snapshot.data?.length?.inSeconds.toDouble()??500
                          ,
                      onChanged: (value) {music.player.seek(Duration(seconds: value.toInt()));}),
                        Text('${timeFormate(snapshot.data?.position??Duration.zero)} / ${timeFormate( snapshot.data?.length??Duration.zero)}'),
          ],
        );
      }
    );
  }
}
