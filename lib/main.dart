import 'dart:convert';

import 'package:flutter/material.dart';

import 'models.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Post> posts = [];

  Future<List<Post>> getPosts() async{
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    if(response.statusCode == 200){
      posts.clear();
      var data = jsonDecode(response.body.toString());
      for(Map i in data){
        posts.add(Post.fromJson(i));
      }
      return posts;
    }else{
      return posts;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter APIs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(future: getPosts(), builder: (context, snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              child: Text(posts[index].id.toString(), style: TextStyle(fontSize: 25)),
                              alignment: Alignment.topLeft,

                            ),
                            Align(
                              child: Text(posts[index].title.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                              alignment: Alignment.topLeft,
                            ),
                            SizedBox(height: 20,),
                            Align(
                              child: Text(posts[index].body.toString(), style: TextStyle(color: Colors.black, fontSize: 18),),
                              alignment: Alignment.topLeft,
                            ),

                          ],
                        ),
                      ),
                    );
                });
              }else{
                return Center(child: Text("loading...", style: TextStyle(fontSize: 20),));
              }
            }),
          )
        ],
      ),
    );
  }
}

