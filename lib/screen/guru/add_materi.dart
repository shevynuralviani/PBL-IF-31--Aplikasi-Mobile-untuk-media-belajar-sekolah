import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MateriContentPage extends StatelessWidget {
  const MateriContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Materi',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Aksi untuk tombol Unggah
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Unggah',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: const NoteBody(),
    );
  }
}

class NoteBody extends StatefulWidget {
  const NoteBody({super.key});

  @override
  State<NoteBody> createState() => _NoteBodyState();
}

class _NoteBodyState extends State<NoteBody> {
  final TextEditingController _textController = TextEditingController();
  TextAlign _textAlign = TextAlign.left;
  bool _isBold = false;
  bool _isUnderline = false;
  bool _isItalic = false;
  bool _isUndoActive = false;
  List<String> _imagePaths = [];

  void _changeTextAlign(TextAlign align) {
    setState(() {
      _textAlign = align;
    });
  }

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderline = !_isUnderline;
    });
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
  }

  void _clearText() {
    setState(() {
      _textController.clear();
      _isUndoActive = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (String imagePath in _imagePaths) ...[
                    Image.file(File(imagePath)),
                    const SizedBox(height: 8),
                  ],
                  TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: _textAlign,
                    style: TextStyle(
                      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle:
                          _isItalic ? FontStyle.italic : FontStyle.normal,
                      decoration: _isUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ketuk di sini untuk menulis',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      setState(() {
                        _isUndoActive = text.isNotEmpty;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.lightGreen, width: 1.5),
            ),
          ),
          child: BottomBar(
            onAlignSelected: _changeTextAlign,
            onBoldToggle: _toggleBold,
            onUnderlineToggle: _toggleUnderline,
            onItalicToggle: _toggleItalic,
            onImagePick: _pickImage,
            onUndo: _clearText,
            isUndoActive: _isUndoActive,
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final Function(TextAlign) onAlignSelected;
  final VoidCallback onBoldToggle;
  final VoidCallback onUnderlineToggle;
  final VoidCallback onItalicToggle;
  final VoidCallback onImagePick;
  final VoidCallback onUndo;
  final bool isUndoActive;

  const BottomBar({
    super.key,
    required this.onAlignSelected,
    required this.onBoldToggle,
    required this.onUnderlineToggle,
    required this.onItalicToggle,
    required this.onImagePick,
    required this.onUndo,
    required this.isUndoActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PopupMenuButton(
            icon: const Icon(Icons.format_align_left, color: Colors.lightGreen),
            offset: const Offset(0, -180),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: Colors.green, width: 1.5),
            ),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'bold') {
                onBoldToggle();
              } else if (value == 'underline') {
                onUnderlineToggle();
              } else if (value == 'italic') {
                onItalicToggle();
              } else if (value == 'align_left') {
                onAlignSelected(TextAlign.left);
              } else if (value == 'align_center') {
                onAlignSelected(TextAlign.center);
              } else if (value == 'align_right') {
                onAlignSelected(TextAlign.right);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bold',
                child: ListTile(
                  leading: Icon(Icons.format_bold, color: Colors.black),
                  title: Text('Bold'),
                ),
              ),
              const PopupMenuItem(
                value: 'underline',
                child: ListTile(
                  leading: Icon(Icons.format_underline, color: Colors.black),
                  title: Text('Underline'),
                ),
              ),
              const PopupMenuItem(
                value: 'italic',
                child: ListTile(
                  leading: Icon(Icons.format_italic, color: Colors.black),
                  title: Text('Italic'),
                ),
              ),
              const PopupMenuItem(
                value: 'align_left',
                child: ListTile(
                  leading: Icon(Icons.format_align_left, color: Colors.black),
                  title: Text('Align Left'),
                ),
              ),
              const PopupMenuItem(
                value: 'align_center',
                child: ListTile(
                  leading: Icon(Icons.format_align_center, color: Colors.black),
                  title: Text('Align Center'),
                ),
              ),
              const PopupMenuItem(
                value: 'align_right',
                child: ListTile(
                  leading: Icon(Icons.format_align_right, color: Colors.black),
                  title: Text('Align Right'),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: isUndoActive ? onUndo : null,
            icon: Icon(Icons.undo,
                color: isUndoActive ? Colors.lightGreen : Colors.grey),
          ),
          IconButton(
            onPressed: onImagePick,
            icon: const Icon(Icons.image, color: Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}
