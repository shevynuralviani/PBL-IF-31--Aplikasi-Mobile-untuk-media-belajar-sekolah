import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<VideoItem> videos = [];
  Set<int> favorites = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  // Fungsi untuk mengambil data video dari API
  Future<void> _fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(
        'https://lightblue-moose-868535.hostingersite.com/api/video_api.php',
      ));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          videos = data.map((item) => VideoItem.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print("Gagal memuat video: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error saat mengambil video: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Pelajaran'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Menampilkan loading hingga data siap
          : ListView.builder(
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
                            initialVideoId: YoutubePlayer.convertUrlToId(
                                videos[index].url)!,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        ),
                      ),
                      // Menampilkan thumbnail jika ada
                      videos[index].thumbnail.isNotEmpty
                          ? Image.network(videos[index].thumbnail)
                          : Container(), // Tidak menampilkan apa-apa jika thumbnail kosong
                      ListTile(
                        title: Text(videos[index].title),
                        subtitle: Text(videos[index].description),
                        trailing: IconButton(
                          icon: Icon(
                            favorites.contains(index)
                                ? Icons.star
                                : Icons.star_border,
                            color: favorites.contains(index)
                                ? const Color(0xFF7BBB07)
                                : Colors.grey,
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
  final String description;
  final String thumbnail;

  VideoItem(
      {required this.title,
      required this.url,
      required this.description,
      required this.thumbnail});

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      title: json['title'],
      url: json['video_url'],
      description: json['description'],
      thumbnail: json['thumbnail'] ??
          '', // Jika thumbnail kosong, gunakan string kosong
    );
  }
}
