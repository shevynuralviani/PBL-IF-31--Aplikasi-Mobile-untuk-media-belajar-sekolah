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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _videos.isEmpty
            ? Center(child: Text("Belum ada video"))
            : ListView.builder(
                itemCount: _videos.length,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
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
                          const PopupMenuItem(
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
                    ),
                  );
                },
              ),
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
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _saveVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text(
                'Unggah',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
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
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Putar Video'),
        backgroundColor: Colors.green,
      ),
      body: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
