

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/second.dart';

class First_Page extends StatefulWidget {
  final String title;
  final String subtitle;
  final String body;
  final List<Map<String, String>> savedNotes;

  const First_Page({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.savedNotes,
  }) : super(key: key);

  @override
  State<First_Page> createState() => _First_PageState();
}

class _First_PageState extends State<First_Page> {
  TextEditingController subtitle_controller = TextEditingController();
  TextEditingController body_controller = TextEditingController();

  List<Color> bg = [
    Colors.indigo.shade200,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent,
    Colors.black,
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.cyanAccent
  ];
  Color defbg = Colors.black;


  @override
  void initState() {
    super.initState();
    subtitle_controller.text = widget.subtitle;
    body_controller.text = widget.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defbg,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              _showColorPicker(context);
            },
            icon: Icon(Icons.edit_note_sharp, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Hero(
              tag: 'unique_tag_1',
              child: TextField(
                controller: subtitle_controller,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Subtitle",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 500,
              height: 500,
              child: Hero(
                tag: 'unique_tag_2',
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 20,
                  controller: body_controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Body",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: ()  async {
              if(subtitle_controller.text.isNotEmpty
                  &&body_controller.text.isNotEmpty) {
                save();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Note_pad(
                      title: widget.title,
                      subtitle: subtitle_controller.text,
                      body: body_controller.text,
                    ),
                  ),
                );
              }else{
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text('Subtitle and Body is required'),
                    content: Text('please provide'),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('OK'))
                    ],
                  );
                });
              }

            },
            child: Icon(
              Icons.save_alt_rounded,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  void save(){
    FirebaseFirestore.instance.collection('Notepad')
        .doc(widget.title).update(
        {'subtitle': subtitle_controller.text,
          'body': body_controller.text
        });
  }

  void _showColorPicker(BuildContext context) async {
    final selectedColor = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bg.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    defbg = bg[index];
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 210,
                  width: 150,
                  margin: EdgeInsets.all(20),
                  color: bg[index],
                ),
              );
            },
          ),
        );
      },
    );
    if (selectedColor != null) {
      setState(() {
        defbg = selectedColor;
      });
    }
  }
}