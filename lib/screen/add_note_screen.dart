import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_sqflite/database/datebase.dart';
import 'package:todo_app_sqflite/models/note.dart';
import 'package:todo_app_sqflite/screen/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final Function?updateNotList;
  const AddNoteScreen({Key? key,this.note,this.updateNotList}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  String title = "";
  String _priority = "Low";
  String btnText = "Add Note";
  String titleText = "Add Note";
  final _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd yyyy');

  final List<String> _priorites = ['Low', 'Medium', 'High'];
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if(widget.note!=null){
      title=widget.note!.title!;
      _date=widget.note!.date!;
      _priority=widget.note!.priority!;
      setState(() {
        btnText='Update Note';
        titleText="Update Note";

      });
    }else{
      setState(() {
        btnText='Add Note';
        titleText="Add Note";

      });
    }

    _dateController.text=_dateFormatter.format(_date);

  }

  @override
  void dispose() {
   _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit(){
       if(_formKey.currentState!.validate()){
         _formKey.currentState!.save();
         print('$title , $_date, $_priority');

         Note note=Note(
           title: title,
           date: _date,
           priority: _priority,
         );

         if(widget.note==null){
           note.status=0;
           DatabaseHelper.instance.insertNote(note);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
         }else{
           note.id=widget.note!.id;
           note.status=widget.note!.status;
           DatabaseHelper.instance.updateNote(note);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
         }
          widget.updateNotList;
       }
  }

  _delete(){
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
    widget.updateNotList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()));
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    titleText,
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                              labelText: "Title",
                              labelStyle: const TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? "Please Enter a note title"
                                : null,
                            onSaved: (input)=>title=input!,
                            initialValue: title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            onTap: _handleDatePicker,
                            controller: _dateController,
                            readOnly: true,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                                labelText: "Date",
                                labelStyle: const TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: DropdownButtonFormField(
                              isDense: true,
                              icon: const Icon(Icons.arrow_drop_down_circle),
                              iconSize: 22.0,
                              iconEnabledColor: Theme.of(context).primaryColor,
                              items: _priorites.map((priority) {
                                return DropdownMenuItem(
                                    value: priority,
                                    child: Text(
                                      priority,
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black12),
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _priority = value.toString();
                                });
                              },
                              style: const TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                labelText: "Priority",
                                labelStyle: const TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              value: _priority,
                              validator: (input)=> _priority==null?"Please select a priority level":null,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ElevatedButton(
                      onPressed:_submit,
                      child: Text(
                        btnText,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),

                  widget.note !=null?Container(
                    margin:const EdgeInsets.symmetric(vertical: 20.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),

                    ),
                    child: ElevatedButton(
                      child: const Text("Delete Note",style: TextStyle(

                        fontSize: 20.0,
                        color: Colors.white,

                      ),
                      ),
                      onPressed:_delete,
                    ),
                  ):const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
