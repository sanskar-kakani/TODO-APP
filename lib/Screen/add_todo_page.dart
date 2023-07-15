import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app_using_api_flutter/main.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController title_ctrl = TextEditingController(), description_ctrl = TextEditingController();
  String? desc_err = null, title_err = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("add todo"),
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

              SizedBox(width: double.infinity, height: 30 ,  child: ElevatedButton(onPressed: _addData, child: Text("Add")))
            ],
          ),
        ),
      ),
    );
  }

  void _addData() async{
    final title = title_ctrl.text;
    final description = description_ctrl.text;

    setState(() {
      title_ctrl.text.isEmpty ? title_err = "field cannot be empty" : null;
      description_ctrl.text.isEmpty ? desc_err = "field cannot be empty":null;
    });

    if(title.isEmpty || description.isEmpty) return;

    final body = {
       "title" : title,
       "description" : description,
       "is_completed" : false
    };

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    // add data
    // boolean canot be sent directly
    //when you sending json request you have declare header type (it is not compulsory)
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      //what type of data your are sending
      headers:{ 'Content-Type' : 'application/json',}
    );


    final route = MaterialPageRoute(builder: (context)=> const MyApp());
    Navigator.pushReplacement(context, route);

  }

}

