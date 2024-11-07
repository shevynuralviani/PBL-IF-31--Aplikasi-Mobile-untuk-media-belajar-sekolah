import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<VideoItem> videos = [
    VideoItem(
      title: "Video 1",
      url: "https://youtu.be/UJltOSp7eZ8?si=LV8jbi9o3qhnbOj-",
    ),
    VideoItem(
      title: "Video 2",
      url: "https://youtu.be/pRLzqHAWTcs?si=7fexIUqbPg2U9Niy",
    ),
    VideoItem(
      title: "Video 3",
      url: "https://youtu.be/ouDcvX4fgHw?si=hvNxwAFvkMNpAX5l",
    ),
    VideoItem(
      title: "Video 4",
      url: "https://youtu.be/MAt-PF5-E74?si=f0HaJEVyU2_w6-xJ",
    ),
  ];

  Set<int> favorites = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Pelajaran'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(videos[index].url)!,
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                  ),
                ),
                ListTile(
                  title: Text(videos[index].title),
                  trailing: IconButton(
                    icon: Icon(
                      favorites.contains(index) ? Icons.star : Icons.star_border,
                      color: favorites.contains(index) ? const Color(0xFF7BBB07) : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favorites.contains(index)) {
                          favorites.remove(index);
                        } else {
                          favorites.add(index);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoItem {
  final String title;
  final String url;

  VideoItem({required this.title, required this.url});
}
