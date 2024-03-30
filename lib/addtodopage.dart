import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            decoration: InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: descriptioncontroller,
            decoration: InputDecoration(hintText: "Description"),
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: submitData,
              child: Text("Submit")),
        ],
      ),
    );
  }

  Future<void> submitData() async {
   // get the data from form server
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
   // submit data to the server
    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type':'application/json'},
    );
   // show success or fail message based on status
    if(response.statusCode == 201){
      titlecontroller.text= '';
      descriptioncontroller.text = '';
      showSuccessMessage('Creation Success');
    }else{

      showFailedMessage('Creation Failed');
    }


  }
  // print(response.statusCode);
  // print(response.body);
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
        content: Text(message , style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailedMessage(String message) {
    final snackBar = SnackBar(
        content: Text(message , style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
