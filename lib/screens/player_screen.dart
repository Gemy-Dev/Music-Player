import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/widget/play_controllers.dart';
import 'package:music_player/widget/volum_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math' as math;

import 'circle_slider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final music = MusicProvider.instance;
  double songPos = 0;
  @override
  void initState() {

    MusicProvider.instance.setSongStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 27, 41),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ListenableBuilder(
                      listenable: music,
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
                        const CircleAvatar(
                          radius: 90,backgroundImage: AssetImage('assets/images/maher.jpeg'),
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
                  const Spacer(),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        music.currentSong.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child:  StreamBuilder<Duration>(
                        stream: music.player.positionStream,
                        builder: (context, snapshot) {
                          return Slider(
                                    thumbColor: const Color(0xFF753A88),activeColor:   const Color(0xFFCC2B5E),
                                    inactiveColor:
                                        const Color.fromARGB(255, 79, 79, 80),
                                    value: snapshot.data?.inSeconds.toDouble()??0,
                                    max: 5000
                                        ,
                                    onChanged: (value) {});
                        }
                      ))
                          ,
                          Text('$songPos / ${music.player.duration?.inMinutes.toDouble()}'),
                   PlayControllers()
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
