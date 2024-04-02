import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/song_duration.dart';
import 'package:music_player/provider/song_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

import 'audio_player_manager.dart';

class MusicStateManager extends ChangeNotifier {
  MusicStateManager._();
  static final _instance=MusicStateManager._();
  factory MusicStateManager(){
    return _instance;}
     final _audioPlayerManager = AudioPlayerManager();
 final   _songManager=SongManager();
OnAudioQuery get audio=>_songManager.audioQuery;


List<SongModel> get songs=>_songManager.songs;

 final _scrollController=ScrollController(initialScrollOffset: 50);
ScrollController get scrollController=>_scrollController;
 int _currentIndex = -1;


bool get firstPlay=>_currentIndex==-1;

 jumpOnSongList(){
    _scrollController.jumpTo(_currentIndex*80);
    notifyListeners();}

  SongModel? getCurrentSong( ) {
    if(songs.isEmpty|| _currentIndex==-1) return null;
    return 
  _songManager.currentSong(_currentIndex);

  }


Stream<PlayerState> isPlaying()=>_audioPlayerManager.player.playerStateStream;

  Stream<SongDuration?> get durationStream => Rx.combineLatest2(
      _audioPlayerManager.durationStream,
      _audioPlayerManager.positionStream,
      (len, pos) => SongDuration(position: pos ?? Duration.zero, length: len));
  Stream<ProcessingState> get status =>
      _audioPlayerManager.player.processingStateStream;


  bool  isPlay() => _audioPlayerManager.player.playing;

 Future<void>getAllSongs()async{
    await _songManager.checkAndRequestPermissions();
    
    notifyListeners();
  }

 
  Future<void> setSong([int index=0]) async {

  _currentIndex = index;
 jumpOnSongList();
      notifyListeners();
    final currentSong =getCurrentSong();
    if (currentSong != null) {
      await _audioPlayerManager.stop();
      await _audioPlayerManager.setSong(songs[_currentIndex]);
    }
  }

  Future<void> playOrPause() async {
 
    if (_audioPlayerManager.player.playing) {
  await _audioPlayerManager.pause();
    } else {
     
      await _audioPlayerManager.play();
    }

  }

  Future<void> stop() async {
    await _audioPlayerManager.stop();
  }

  Future<void> seekToNext() async {
    await _audioPlayerManager.seekToNext();
    if(_currentIndex<songs.length-1) {
      _currentIndex++;
       jumpOnSongList();

       setSong(_currentIndex);
    }
    notifyListeners();
  }

  Future<void> seekToPrevious() async {
    await _audioPlayerManager.seekToPrevious();
    if (_currentIndex > 0) {
      _currentIndex--;
       jumpOnSongList();

      setSong(_currentIndex);
    }
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayerManager.setVolume(volume);
   // notifyListeners();
  }
  Future<void> jumpTo(Duration volume) async {
    await _audioPlayerManager.jumpTo(volume);
   // notifyListeners();
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayerManager.setSpeed(speed);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    super.dispose();
  }

}
