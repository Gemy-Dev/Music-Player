import 'package:flutter/material.dart';

import '../provider/music_state_manger.dart';

class DurationSlider extends StatelessWidget {
  const DurationSlider({
    super.key,

  });


  String timeFormate(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
      final music=MusicStateManager();
    return StreamBuilder(
        stream: music.durationStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Slider(
                  thumbColor: const Color(0xFF753A88),
                  activeColor: const Color(0xFFCC2B5E),
                  inactiveColor: const Color.fromARGB(255, 79, 79, 80),
                  value: snapshot.data?.position.inSeconds.toDouble() ?? 0,
                  max: snapshot.data?.length?.inSeconds.toDouble() ?? 500,
                  onChanged: (value) async {
                    await music.jumpTo(Duration(seconds
                    : value.toInt()));
                  }),
              Text(
                  '${timeFormate(snapshot.data?.position ?? Duration.zero)} / ${timeFormate(snapshot.data?.length ?? Duration.zero)}'),
            ],
          );
        });
  }
}
