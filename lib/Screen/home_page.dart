import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_using_api_flutter/Screen/add_todo_page.dart';
import 'package:todo_app_using_api_flutter/Screen/edit_todo_page.dart';
import 'package:http/http.dart'as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  List items = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title:const Text("Todo"),
      ),

      body: Visibility(
        //if loading is true it show child widget else it will show replacement widget
        visible: isLoading,
        replacement: RefreshIndicator(
          //on refresh (scroll down) it will call fun
          onRefresh: fetchData,
          child: ListView.separated(
            separatorBuilder: (context, index)=>const Divider(), //this is add divider after every item
            itemCount: items.length,
            itemBuilder: (context, index){

             final item = items[index] as Map;
             final id = item['_id'] as String;

            return ListTile(
              leading: CircleAvatar(child: Text("${index+1}"),),
              title: Text(item['title']),
              subtitle: Text(item['description']),

              trailing: PopupMenuButton(

                onSelected:(val){
                  if(val == 'edit'){
                    navigateToEditPage(item);
                  }
                  else if(val == 'delete'){
                    deleteById(id, index);
                  }
                },

                itemBuilder: (context){
                  return[

                   const PopupMenuItem(
                      value: "edit",
                      child: Text("edit"),
                    ),

                    const PopupMenuItem(
                      value: "delete",
                      child: Text("delete"),
                    ),

                  ];
                },
              ),
            );
          }),
        ),
        child:const Center(child: CircularProgressIndicator(),),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final route = MaterialPageRoute(builder: (context)=>const AddTodoPage());
          Navigator.push(context, route);
        },
        child:const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchData() async{
    const url = "https://api.nstack.in/v1/todos?page=1";
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    //200 is success code
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final result = json['items'] as List;

      setState(() {
        items = result;
        isLoading = false;
      });

    }
    else{
      showError("Some error occurred");
    }

  }

  Future<void> deleteById(String id, int index)async {

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200){
      setState(() {
        items.removeAt(index);
      });

    }
    else{
      showError("failed to delete");
    }
  }

  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg) , backgroundColor: Colors.red.shade300),
    );
  }

  void navigateToEditPage(Map item){
    final route = MaterialPageRoute(builder: (context)=> EditTodoPage(item: item));
    Navigator.push(context, route);
  }

}
