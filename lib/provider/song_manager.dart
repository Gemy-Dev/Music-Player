import 'package:on_audio_query/on_audio_query.dart';

class SongManager {
  List<SongModel> songs = [];
  final OnAudioQuery audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.

  Future<void> checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    bool hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if (hasPermission) {
      await _initSongs();
    }
  }

  Future<void> _initSongs() async {
    final songsResult = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs.addAll(songsResult);
  }

  SongModel currentSong(int index){
return songs[index];
  }
}
