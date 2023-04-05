import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/screen/add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Widget _buildNote(int index){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: const Text("Not Title"),
            subtitle: const Text("April 04, 2023 -High"),
            trailing: Checkbox(
              onChanged: (value){
                print(value);
              },
              activeColor: Theme.of(context).primaryColor,
              value: true,
            ),
          ),
          const Divider(height: 5.0,color: Colors.orangeAccent,thickness: 2.0,)
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNoteScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          itemCount: 10,
          itemBuilder: (context, index) {
            if (index == 0) {
              return  Padding(
                padding:const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("My Notes",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      fontSize: 40
                    ),),
                    SizedBox(height: 10.0,),
                    Text("0 off 10",

                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orangeAccent,
                          fontSize: 20
                      ),),
                  ]
                ),
              );
            }
            return _buildNote(index);
          }),
    );
  }
}
