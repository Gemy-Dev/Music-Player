import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/widget/songs_list.dart';

class PlayControllers extends StatelessWidget {
   PlayControllers({
    super.key,
  });
final music= MusicProvider.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 70,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
                onPressed: () async{
                await  music.previous();
                },
                icon: const Icon(
                  CupertinoIcons.stop_circle,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () async{
                await  music.previous();
                },
                icon: const Icon(
                  CupertinoIcons.backward_end,
                  color: Colors.white,
                )),

            Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 248, 83, 135),
                          Color(0xFF753A88)
                        ])),
                child:  IconButton(
                        onPressed: ()async {
                                
                          await music.playOrStop();
                        },
                        icon: StreamBuilder<Object>(
                          stream: music.player.processingStateStream,
                          builder: (context, snapshot) {
                            
                            if(!music.player.playing||snapshot.data==ProcessingState.completed) {
                              return const Icon(
                              CupertinoIcons.play_fill,
                              color: Colors.white,
                              size: 30,
                            );
                            
                            } else {
                              return const Icon(
                              CupertinoIcons.pause_fill,
                              color: Colors.white,
                              size: 30,
                            );
                            }
                          }
                        ))
                  
                ),
            IconButton(
                onPressed: ()async {await music.next();},
                icon: const Icon(
                  CupertinoIcons.forward_end,
                  color: Colors.white,
                )),
            IconButton(color: Colors.red,
                onPressed: ()async {await music.next();},
                icon: const Text('1.0x'))
          ]),
        ),
        // SizedBox(
        //   width: 250,
        //   height: 50,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       IconButton(
        //           onPressed: () {showBottomSheet(context: context, builder: (_)=>const Songs());},
        //           icon: const Icon(CupertinoIcons.music_note_list)),
        //       IconButton(
        //           onPressed: () {},
        //           icon: const Icon(CupertinoIcons.arrow_2_circlepath)),
        //       IconButton(
        //           onPressed: () {}, icon: const Icon(Icons.shuffle_outlined)),
        //       IconButton(
        //           onPressed: () {},
        //           icon: const Icon(Icons.format_list_bulleted_add)),
        //     ],
        //   ),
        // )
      ],
    );
  }
}
