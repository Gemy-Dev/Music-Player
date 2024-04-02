import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/provider/music_state_manger.dart';

class PlayControllers extends StatelessWidget {
   const PlayControllers({super.key, 
   
  });

  @override
  Widget build(BuildContext context) {
      final music=MusicStateManager();
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 70,
          child:
              Container(decoration: BoxDecoration(color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          
                            IconButton(
                  onPressed: () async{
                  await  music.seekToPrevious();
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
                                  
                            await music.playOrPause();
                          },
                          icon: StreamBuilder<PlayerState>(
                            stream: music.isPlaying(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData&&!snapshot.data!.playing ){

                            
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
                  onPressed: ()async {await music.seekToNext();},
                  icon: const Icon(
                    CupertinoIcons.forward_end,
                    color: Colors.white,
                  )),
            
                          ]),
              ),
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
