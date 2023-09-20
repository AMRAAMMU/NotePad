import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'first.dart';
import 'fourth.dart';




class Note_pad extends StatefulWidget {
  final String title;
  final String subtitle;
  final String body;

  Note_pad({
    Key?key,
    required this.title,
    required this.subtitle,
    required this.body
  }) : super(key: key);


  @override
  State<Note_pad> createState() => _Note_padState();

}

class _Note_padState extends State<Note_pad> {
  String input = '';
  late List<Map<String, String>> todoData = [];
  String searchText = '';
  TextEditingController titletxt = TextEditingController();
  getData() async {
    List<Map<String, String>> dataMap = [];
    CollectionReference cr = FirebaseFirestore.instance.collection('Notepad');
    QuerySnapshot querySnapshot = await cr.get();
    var num = querySnapshot.docs.length;
    for (var i = 0; i < num; i++) {
      final title = querySnapshot.docs[i].reference.id;
      final subtitle = querySnapshot.docs[i].get('subtitle') ?? '';
      final body = querySnapshot.docs[i].get('body') ?? '';

      dataMap.add({
        'title': title,
        'subtitle': subtitle,
        'body': body,
      });
    }
    return dataMap;
  }
  sendData(String title)async{
    await FirebaseFirestore.instance.collection('Notepad').doc(title).set({
      'title':title,
      'subtitle': widget.subtitle,
      'body': widget.body,
    });
  }
  void deleteNoteFromFirestore(int index) async {
    CollectionReference cr = FirebaseFirestore.instance.collection('Notepad');
    await cr.doc(todoData[index]['title']).delete();
    setState(() {
      todoData.removeAt(index);
    });
  }

  @override
  void initState(){
    super.initState();
    getData().then((dataMap){
      setState(() {
        todoData = List<Map<String, String>>.from(dataMap);
      });
    });
  }
  void searchNotes(String query) {
    setState(() {
      searchText = query.toLowerCase();
    });
  }
  List<Map<String, String>> getFilteredNotes() {
    if (searchText.isEmpty) {
      return todoData;
    }
    return todoData.where((note) =>
    note['title']!.toLowerCase().contains(searchText) ||
        note['subtitle']!.toLowerCase().contains(searchText) ||
        note['body']!.toLowerCase().contains(searchText))
        .toList();
  }
  int _selectedIndex = 0;
  void _onItemTapped(Index){
    setState(() {
      _selectedIndex = Index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.black
                ),
                child:Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.fill,
                          image: AssetImage('assets/img4.png')
                      )
                  ),
                )
            ),
            ListTile(
              title: const Text('Notes'),
              selected: _selectedIndex == 0,
              selectedTileColor: Colors.white24,
              onTap: (){
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Backup'),
              selected: _selectedIndex == 0,
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Account'),
              selected: _selectedIndex == 0,
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              selected: _selectedIndex == 0,
              onTap: (){
                Navigator.pop(context);
              },
            ),
            TextButton(onPressed: () async{
              await FirebaseAuth.instance.signOut();
            },
                child: Text('LOGOUT'))
          ],
        ),

      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: true,
        title: Text('NOTE_APP',
            style: GoogleFonts.poppins(textStyle:TextStyle(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 4,
            ),)
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)
              ),
              gradient: LinearGradient(
                  colors: [Colors.indigo,Colors.black],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              )
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: Colors.indigo,
                      title: Text("SEARCH"),
                      content: TextField(
                        decoration: InputDecoration(hintText: "Search..."),
                        onChanged: (value) {
                          searchNotes(value);
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Search'),
                        ),
                      ]
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.add,
              color: Colors.indigo,
              size: 35
          ),
          onPressed: (){
            showDialog(context: context,
                builder: (BuildContext)
                {
                  return AlertDialog(
                    backgroundColor: Colors.indigo.shade400,
                    title: Text("ADD TITLE"),
                    content: TextField(
                      controller: titletxt,
                      decoration: InputDecoration(
                          hintText: "Title"
                      ),
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if(titletxt.text.isEmpty){
                            sendData(titletxt.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(5),
                                    content: Text('Requir a title')
                                )
                            );
                            return;
                          }
                          sendData(titletxt.text);
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=> First_Page(
                                title: titletxt.text,
                                subtitle: ' ',
                                body: ' ',
                                savedNotes: [],
                              )
                              )
                          );
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                }
            );
          }
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
            itemCount: getFilteredNotes().length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(getFilteredNotes()[index]['title']!),
                  onDismissed: (direction) {
                    deleteNoteFromFirestore(index);
                  },
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubtitlePage(title: getFilteredNotes()[index]['title']!,
                              subtitles: [],),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.indigo,
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: ListTile(
                          title: Text(getFilteredNotes()[index]['title']!,
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          subtitle: Text(
                            getFilteredNotes()[index]['subtitle']!,
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return Container(
                                      child: AlertDialog(
                                        backgroundColor: Colors.indigo,
                                        title: Text('Do You Wand To Delete'),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                            deleteNoteFromFirestore(index);
                                          },
                                              child: Text('Delete')
                                          ),
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                              child: Text('Cancel')
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(Icons.delete_forever_rounded,
                                color: Colors.red),
                          ),
                        ),
                      )
                  )
              );
            }
        ),
      ),
    );

  }
}