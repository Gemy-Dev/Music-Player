import 'package:flutter/material.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

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
final music= MusicProvider.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(extendBodyBehindAppBar: true,extendBody: true,
      backgroundColor: Colors.white.withOpacity(.1),
      body:
       Center(
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
                  else  if (item.data!.isEmpty) return const Text("Nothing found!");
      
                    // You can use [item.data!] direct or you can create a:
                    // List<SongModel> songs = item.data!;
                    return ListView.builder(
                      itemCount: item.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            tileColor: const Color.fromARGB(255, 6, 7, 14),
                            onTap: ()async =>await music.setSongFromFile(item.data![index]),
                            title: Text(item.data![index].title),
                            subtitle: Text(item.data![index].artist ?? "No Artist"),
                            trailing: const Icon(Icons.play_arrow),
                            // This Widget will query/load image.
                            // You can use/create your own widget/method using [queryArtwork].
                            leading: CircleAvatar(radius: 25,
                              child: QueryArtworkWidget(
                                controller: _audioQuery,
                                id: item.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.music_note,size: 25,),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
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