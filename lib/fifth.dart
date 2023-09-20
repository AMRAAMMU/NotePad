import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubtitleDetailPage extends StatefulWidget {
  final String subtitle;

  SubtitleDetailPage({
    required this.subtitle, required String body,
  });

  @override
  _SubtitleDetailPageState createState() => _SubtitleDetailPageState();
}

class _SubtitleDetailPageState extends State<SubtitleDetailPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadSavedBody();
  }

  Future<void> _loadSavedBody() async {
    try {
      final documentSnapshot = await _firestore
          .collection('subtitles')
          .doc(widget.subtitle)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('body')) {
          final savedBody = data['body'] as String;
          _textEditingController.text = savedBody;
        } else {
          print('Body field is missing in the document.');
        }
      }
    } catch (e) {
      print('Error loading saved body: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(widget.subtitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 500,
          height: 500,
          child: Hero(
            tag: 'unique_tag_2',
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 45,
              controller: _textEditingController,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.blueGrey),
                hintText: "Body",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          final writtenText = _textEditingController.text;
          _saveBodyToFirestore(writtenText);
          Navigator.pop(context);
        },
        child: Icon(
          Icons.save_alt_rounded,
          color: Colors.indigo,
          size: 38,
        ),
      ),
    );
  }

  Future<void> _saveBodyToFirestore(String bodyText) async {
    try {
      await _firestore.collection('subtitles').doc(widget.subtitle).set({
        'body': bodyText,
      });
    } catch (e) {
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subtitle App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SubtitleDetailPage(
        subtitle: 'Subtitle Name', body: '',
      ),
    );
  }
}
