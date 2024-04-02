import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/provider/music_state_manger.dart';
import 'package:music_player/widget/play_controllers.dart';
import 'package:music_player/widget/songs_list.dart';
import 'package:music_player/widget/volum_slider.dart';

import '../widget/artist_image.dart';
import '../widget/duration_slider.dart';

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

    final music = MusicStateManager();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/bg.png',
              ),
              opacity: .3,
              fit: BoxFit.fill)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const ArtistImage(),
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
                            const VolumSlider(
                           
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListenableBuilder(listenable: music,
                        builder: (context,_) {
                          return Text(
                                music.getCurrentSong()?.title ?? 'No Name',
                               
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              );
                        }
                      ),
                          const SizedBox(height: 5,),
                      ListenableBuilder(listenable: music,
               builder: (context,_) {
             if(!music.firstPlay) {
               return    const PlayControllers(
                          
                          );
             }
                           return const SizedBox();
               }
             ),
                      const DurationSlider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: const SongsList()))
                    ],
                  )
                ,
          ),
        ),
      ),
    );
  }
}

