import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_sqflite/screen/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: GestureDetector(
        onTap: () {},
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
                  const Text(
                    "Add Note",
                    style: TextStyle(
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
                                    borderRadius: BorderRadius.circular(10.0))),
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
                      onPressed: (){},
                      child: Text(
                        btnText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
