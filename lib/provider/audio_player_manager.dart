import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/subjects.dart';

class AudioPlayerManager {
  
  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player=>_player;
  late BehaviorSubject<Duration?> _durationSubject;

  AudioPlayerManager() {
    _durationSubject = BehaviorSubject<Duration?>();
    _player.durationStream.listen((value) {
      _durationSubject.add(value);
    });
  }

  Stream<Duration?> get durationStream => _durationSubject.stream;
  Stream<Duration?> get positionStream => _player.positionStream;

  Future<void> play() async {
  
    await _player.play();
  }
Future<void>setSong(SongModel song)async{
    await _player.setFilePath(File(song.data).path);
     await play();
}
  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seekToNext() async {
    await _player.seekToNext();
  }

  Future<void> seekToPrevious() async {
    await _player.seekToPrevious();
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }
  Future<void> jumpTo(Duration value) async {
    await _player.seek(value);
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _durationSubject.close();
  }
Future<void> addToList(List<SongModel> songs)async{
 final playlist = ConcatenatingAudioSource(
  // Start loading next item just before reaching it
  useLazyPreparation: true,
  // Customise the shuffle algorithm
  shuffleOrder: DefaultShuffleOrder(),
  // Specify the playlist items
  children: [
 ...songs.map((e) => AudioSource.asset(File(e.data).path)).toList()] 
);
    await player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);

    //await player.setAsset(currentSong.url);
}
 
}



