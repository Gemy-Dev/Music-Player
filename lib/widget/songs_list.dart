import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/provider/music_state_manger.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key, required this.music}) : super(key: key);
  final MusicStateManager music;
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  // Main method.
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    widget.music.getAllSongs();
    // (Optinal) Set logging level. By default will be set to 'WARN'.
    //
    // Log will appear on:
    //  * XCode: Debug Console
    //  * VsCode: Debug Console
    //  * Android Studio: Debug and Logcat Console
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white.withOpacity(.1),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                // Default values:
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  // Display error, if any.
                  if (item.hasError) {
                    return Text(item.error.toString());
                  }

                  // Waiting content.
                  else if (item.data == null) {
                    return const CircularProgressIndicator();
                  }

                  // 'Library' is empty.
                  else if (item.data!.isEmpty)
                    return const Text("Nothing found!");

                  // You can use [item.data!] direct or you can create a:
                  // List<SongModel> songs = item.data!;

                  return const SongsList();
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}

class SongsList extends StatefulWidget {
  const SongsList({
    super.key,
  });

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final music = MusicStateManager();
  @override
  void initState() {
    music.getAllSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white.withOpacity(.1),
      body: ListenableBuilder(
        listenable: music,
        builder: (context, _) => music.songs.isEmpty
            ? const Center(
                child: Icon(
                  CupertinoIcons.nosign,
                  size: 35,
                ),
              )
            : ListView.builder(controller:music.scrollController ,
                itemCount: music.songs.length,
                itemBuilder: (context, index) {
                  final item = music.songs[index];
                  return Container(
                    decoration: music.getCurrentSong() != music.songs[index]
                        ? null
                        : BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(5.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      tileColor: const Color.fromARGB(255, 6, 7, 14),
                      onTap: () async => await music.setSong(index),
                      title: Text(item.title),
                      subtitle: Text(item.artist ?? "No Artist"),
                      trailing: const Icon(Icons.play_arrow),
                      // This Widget will query/load image.
                      // You can use/create your own widget/method using [queryArtwork].
                      leading: CircleAvatar(
                        radius: 25,
                        child: QueryArtworkWidget(
                          id: item.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.music_note,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
