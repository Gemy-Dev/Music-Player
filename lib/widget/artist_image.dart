import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../provider/music_state_manger.dart';

class ArtistImage extends StatelessWidget {
  const ArtistImage({
    super.key,
   
  });

 

  @override
  Widget build(BuildContext context) {
    final music=MusicStateManager();
    return CircleAvatar(
      radius: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: ListenableBuilder(listenable: music,
              builder: (context,_) {
                return  music.getCurrentSong() == null
            ? const Icon(
                Icons.music_note,
                size: 100,
              )
            : QueryArtworkWidget(
                    artworkWidth: 180,
                    artworkHeight: 180,controller: music.audio,
                    id: music.getCurrentSong()!.id,
                    
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.music_note,
                        size: 100,
                      ),
                    ),
                  );
              }
            ),
      ),
    );
  }
}

