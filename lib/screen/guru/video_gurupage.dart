import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  void _deleteVideo(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin menghapus video ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _videos.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );
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
        title: Text('Daftar Video'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: _videos.isEmpty
                ? Center(child: Text("Belum ada video"))
                : ListView.builder(
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.video_library),
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
                            PopupMenuItem(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'Hapus',
                              child: Text('Hapus'),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                        onTap: () => _playVideo(_videos[index].id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
  final String? initialUrl;
  final String? initialTitle;

  AddVideoPage({required this.onAdd, this.initialUrl, this.initialTitle});

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

  void _saveVideo() {
    final url = _urlController.text.trim();
    final videoId = YoutubePlayer.convertUrlToId(url);
    final title = _titleController.text.trim();

    if (videoId != null && title.isNotEmpty) {
      widget.onAdd(Video(id: videoId, title: title));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan URL YouTube dan judul yang valid.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah/Edit Video'),
        backgroundColor: const Color.fromARGB(255, 235, 229, 228),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Masukkan URL YouTube',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Masukkan Judul Video',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: _saveVideo,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(231, 27, 237, 34), // Warna hijau
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'Unggah',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
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
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Putar Video'),
        backgroundColor: Colors.red,
      ),
      body: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
