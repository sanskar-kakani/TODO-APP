import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_using_api_flutter/main.dart';
import 'package:http/http.dart' as http;

class EditTodoPage extends StatefulWidget {
  Map item;
  EditTodoPage({
    super.key,
    required this.item
  });

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {

  TextEditingController title_ctrl = TextEditingController(), description_ctrl = TextEditingController();
  String id = "";
  String? title_err = null, desc_err = null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    title_ctrl.text = item['title'];
    description_ctrl.text = item['description'];
    id = item['_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("edit todo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: title_ctrl,
                decoration: InputDecoration(
                  labelText: "title",
                  errorText: title_err
                ),
              ),

              const SizedBox(height: 20,),

              TextField(
                controller: description_ctrl,
                minLines: 2,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "description",
                  errorText: desc_err
                ),
              ),

              const SizedBox(height: 20,),

              SizedBox(width: double.infinity,
                  height: 30,
                  child: ElevatedButton(onPressed: () {
                    _updateData(id);
                  }, child: Text("Edit")))
            ],
          ),
        ),
      ),
    );
  }

  void _updateData(String id) async {
    final title = title_ctrl.text;
    final description = description_ctrl.text;

    setState(() {
      title_ctrl.text.isEmpty ? title_err = "field cannot be empty" : null;
      description_ctrl.text.isEmpty ? desc_err = "field cannot be empty":null;
    });

    if (title.isEmpty || description.isEmpty) return;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);

    //put is used to update
    final response = await http.put(
        uri,
        body: jsonEncode(body),
        //what type of data your are sending
        headers: { 'Content-Type': 'application/json',}
    );


    final route = MaterialPageRoute(builder: (context) => const MyApp());
    Navigator.pushReplacement(context, route);
  }
}
