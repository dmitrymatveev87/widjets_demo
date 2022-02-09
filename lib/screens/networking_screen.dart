import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Post.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,

  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class NetworkingScreen extends StatefulWidget {
  const NetworkingScreen({Key? key}) : super(key: key);

  @override
  _NetworkingScreenState createState() => _NetworkingScreenState();
}

class _NetworkingScreenState extends State<NetworkingScreen> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 60,),
            const SizedBox(width:103),
            const SizedBox(height: 20,),
            FutureBuilder<Post>(
            future: futurePost,
            builder: (context, snapshot)
            {
              if (snapshot.hasData)
              {
                return Text(snapshot.data!.title);
              }
              else if (snapshot.hasError) {
                return Text('${snapshot.error}');
                }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
            const SizedBox(height: 60,),
            const SizedBox(width:103),
            const SizedBox(height: 20,),
            FutureBuilder<Post>(
              future: futurePost,
              builder: (context, snapshot)
              {
                if (snapshot.hasData)
                {
                  return Text(snapshot.data!.body);
                }
                else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
        ]
        ),
      ),
    );
  }
}
