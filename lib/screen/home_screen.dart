import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_sqflite/database/datebase.dart';
import 'package:todo_app_sqflite/models/note.dart';
import 'package:todo_app_sqflite/screen/add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;

  final DateFormat _dateFormat = DateFormat('MMM dd yyyy');

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  @override
  void initState() {
    _updateNoteList();
    super.initState();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              note.title!,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                decoration: note.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              "${_dateFormat.format(note.date!)} - ${note.priority}",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                decoration: note.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                note.status = value! ? 1 : 0;
                DatabaseHelper.instance.updateNote(note);
                _updateNoteList();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen(

                    )));
              },
              activeColor: Theme.of(context).primaryColor,
              value: note.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => AddNoteScreen(
                  updateNotList: _updateNoteList(),
                  note: note,
                ))),
          ),
          const Divider(
            height: 5.0,
            color: Colors.orangeAccent,
            thickness: 2.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNoteScreen(
                  updateNotList: _updateNoteList,

                )));
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {

            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
            }
            final int completedNoteCount=snapshot.data!.where((Note note)=>note.status==1).toList().length;
            return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                itemCount: int.parse(snapshot.data!.length.toString())+1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Notes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                  fontSize: 40),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "$completedNoteCount of ${snapshot.data.length}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orangeAccent,
                                  fontSize: 20),
                            ),
                          ]),
                    );
                  }
                  return _buildNote(snapshot.data![index -1]);
                });
          },
        ));
  }
}
