import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'fifth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class SubtitlePage extends StatefulWidget {
  final String title;
  final List<String> subtitles;

  SubtitlePage({
    required this.title,
    required this.subtitles,
  });

  @override
  _SubtitlePageState createState() => _SubtitlePageState();
}

class _SubtitlePageState extends State<SubtitlePage> {
  final CollectionReference _NotepadCollection =
  FirebaseFirestore.instance.collection('subtitles');
  List<String> subtitles = [];
  TextEditingController _searchController = TextEditingController();
  List<String> _filteredSubtitles = [];

  @override
  void initState() {
    super.initState();
    _loadSubtitles(widget.title);
    _filteredSubtitles = List.from(subtitles);
  }

  Future<void> _loadSubtitles(String title) async {
    final subtitlesSnapshot = await FirebaseFirestore.instance
        .collection('titles')
        .doc(title)
        .collection('subtitles')
        .get();

    setState(() {
      subtitles = subtitlesSnapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('subtitleText')) {
          return data['subtitleText'].toString();
        } else {
          return '';
        }
      })
          .toList();
      _filteredSubtitles = List.from(subtitles);
    });
  }

  Future<void> _deleteSubtitle(String subtitle) async {
    if (subtitle.isNotEmpty) {
      await _NotepadCollection
          .where('subtitleText', isEqualTo: subtitle)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      await _loadSubtitles(widget.title);
    }
  }

  void _showSubtitleDetailPage(String subtitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubtitleDetailPage(
          subtitle: subtitle,
          body: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _filteredSubtitles = List.from(subtitles);
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: 250,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _filteredSubtitles = subtitles
                        .where((subtitle) =>
                        subtitle.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Subtitles',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredSubtitles.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_filteredSubtitles[index]),
            onDismissed: (direction) {
              _deleteSubtitle(_filteredSubtitles[index]);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                _showSubtitleDetailPage(_filteredSubtitles[index]);
              },
              child: Container(
                height: 60,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    _filteredSubtitles[index],
                    style: TextStyle(color: Colors.black),
                  ),
                  tileColor: Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _showAddSubtitleDialog(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.indigo,
          size: 35,
        ),
      ),
    );
  }

  Future<void> _showAddSubtitleDialog(BuildContext context) async {
    String subtitle = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo.shade400,
          title: Text('Add Subtitle'),
          content: TextField(
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              subtitle = value;
            },
            decoration: InputDecoration(hintText: 'Enter subtitle'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (subtitle.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('titles')
                      .doc(widget.title)
                      .collection('subtitles')
                      .add({
                    'subtitleText': subtitle,
                  });

                  await _loadSubtitles(widget.title);

                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
