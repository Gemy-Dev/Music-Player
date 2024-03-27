import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/utils/song_list.dart';

class MusicProvider extends ChangeNotifier {
  MusicProvider._();
  static final instance = MusicProvider._();
  int currentIndex = 0;
  Duration songDuration = const Duration();
  get currentSong => songs[currentIndex];
  final player = AudioPlayer();





  Future<void> setSong(String songPath) async {
    if (player.playing) await player.stop();
    await player.setAsset(songPath);
    await player.play();
    player.durationStream.listen((value) {
      print(value);
      songDuration = value!;
    });
    notifyListeners();
  }

  Future<void> setSongStart() async {
    // Define the playlist
final playlist = ConcatenatingAudioSource(
  // Start loading next item just before reaching it
  useLazyPreparation: true,
  // Customise the shuffle algorithm
  shuffleOrder: DefaultShuffleOrder(),
  // Specify the playlist items
  children: [
 ...songs.map((e) => AudioSource.asset(e.url)).toList()] 
);
    await player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);

    //await player.setAsset(currentSong.url);

    notifyListeners();
  }

  Future<void> playOrStop() async {
    if (player.playing) {
      await player.stop();
    } else {
      await player.play();
    }
  }

  Future<void> puse() async {
    await player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await player.stop();
    notifyListeners();
  }

  Future<void> next() async {
    await player.seekToNext();
    // log(currentIndex.toString());
    if (currentIndex > songs.length - 2) return;
     currentIndex++;
    // await setSong(songs[currentIndex].url);
    // log(songs[currentIndex].url);

    notifyListeners();
  }

  Future<void> previous() async {
    await player.seekToPrevious();
    //log(currentIndex.toString());
    if (currentIndex <= 0) return;
    currentIndex--;
   // await setSong(songs[currentIndex].url);
   // log(songs[currentIndex].url);

    notifyListeners();
  }

  Future<void> setVolume(double volum) async {
    // Twice as fast
    await player.setVolume(volum);
    notifyListeners();
  }

  Future<void> setSpeed(double speed) async {
    await player.setSpeed(2.0);
  }
}
