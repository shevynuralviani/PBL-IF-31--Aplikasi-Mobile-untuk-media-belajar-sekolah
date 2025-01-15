import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Video {
  final String id;
  final String title;

  Video({required this.id, required this.title});
}

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  // Fetch video data from the API
  void _fetchVideos() async {
    final response = await http.get(Uri.parse(
        'https://lightblue-moose-868535.hostingersite.com/api/get_video_guru.php')); // Ganti dengan URL API Anda

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _videos.clear();
        _videos.addAll(data.map((videoData) {
          return Video(
            id: videoData['id'],
            title: videoData['title'],
          );
        }).toList());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat video')),
      );
    }
  }

  void _deleteVideo(int index) async {
    final videoId = _videos[index].id;

    final response = await http.post(
      Uri.parse(
          'https://lightblue-moose-868535.hostingersite.com/api/delete_video_guru.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': videoId}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          _videos.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus video')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus video')),
      );
    }
  }

  void _editVideo(int index) {
    final video = _videos[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVideoPage(
          onAdd: (updatedVideo) {
            setState(() {
              _videos[index] = updatedVideo;
            });
          },
          initialId: video.id,
          initialTitle: video.title,
          initialUrl: 'https://www.youtube.com/watch?v=${video.id}',
        ),
      ),
    );
  }

  void _playVideo(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoId: videoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Video'),
        backgroundColor: Colors.green,
      ),
      body: _videos.isEmpty
          ? const Center(child: Text("Belum ada video"))
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_videos[index].title),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Hapus') {
                        _deleteVideo(index);
                      } else if (value == 'Edit') {
                        _editVideo(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'Hapus',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                  onTap: () => _playVideo(_videos[index].id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddVideoPage(
              onAdd: (video) {
                setState(() {
                  _videos.add(video);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AddVideoPage extends StatefulWidget {
  final Function(Video) onAdd;
  final String? initialId;
  final String? initialUrl;
  final String? initialTitle;

  AddVideoPage(
      {required this.onAdd,
      this.initialId,
      this.initialUrl,
      this.initialTitle});

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
    }
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
  }

  void _saveVideo() async {
    final url = _urlController.text.trim();
    final videoId = YoutubePlayer.convertUrlToId(url);
    final title = _titleController.text.trim();

    if (videoId != null && title.isNotEmpty) {
      final response = await http.post(
        Uri.parse(
            'https://lightblue-moose-868535.hostingersite.com/api/${widget.initialId == null ? "post_video_guru.php" : "update_video_guru.php"}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': widget.initialId,
          'title': title,
          'video_url': url,
          'category': 'General',
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['message'] == 'Video updated successfully' ||
            result['message'] == 'Video added successfully') {
          widget.onAdd(Video(id: videoId, title: title));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan video')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan video')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Masukkan URL YouTube dan judul yang valid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah/Edit Video')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: 'Masukkan URL YouTube',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Masukkan Judul Video',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVideo,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String videoId;

  VideoPlayerPage({required this.videoId});

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Putar Video')),
      body: YoutubePlayer(controller: _youtubeController),
    );
  }
}
