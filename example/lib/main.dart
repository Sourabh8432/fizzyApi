import 'package:fizzy_api/fizzy_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'loader.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() {
  initializeFizzyApi(navigatorKey: navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiDemoScreen(),
    );
  }
}

class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});
  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  String output = "Click a button to test an API";

  void _updateOutput(String message) {
    setState(() {
      output = message;
    });
  }


  Future<void> getPost() async {
    await fizzyApi.getApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      showLoader: true,
      loaderColor: Colors.red,
      context: context,
      onResponse: (res)  {
        if(res.statusCode == 200){
          if (kDebugMode) {
            print("Success");
            _updateOutput("GET: ${res.data['title']}");
          }
        }
      },
      onError: (e) {
        _updateOutput("Error: ${e.message}");

      },
    );

  }


  Future<void> getAllPosts() async {
    await fizzyApi.getApi(
      'https://jsonplaceholder.typicode.com/posts',
      showLoader: true,
        showDebug: true,
        loaderColor: Colors.blue, context: context,
      onResponse: (res)  {
        if(res.statusCode == 200){
          if (kDebugMode) {
            print("Success");
            _updateOutput("Total posts fetched: ${res.data.length}");
          }
        }
      },
    );



  }

  Future<void> createPost() async {
     await fizzyApi.postApi(
      'https://jsonplaceholder.typicode.com/posts',
      body: {
        'title': 'New Title',
        'body': 'Post body content',
        'userId': 1,
      },
      customLoader: const ModernOrbitLoader(),
      context: context,
      onResponse: (res)  {
        if(res.statusCode == 200){
          _updateOutput("POST Created: ID = ${res.data['id']}");
        }
      },
      onError: (e) {
        _updateOutput("Error: ${e.message}");
      },
    );


  }

  Future<void> updatePostPut() async {
    await fizzyApi.putApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      body: {
        'id': 1,
        'title': 'Updated Title PUT',
        'body': 'Updated content with PUT',
        'userId': 1,
      },
      showLoader: true,
        loaderColor: Colors.blue,
       context: context,
      onResponse: (res)  {
        if(res.statusCode == 200){
          _updateOutput("PUT Updated: ${res.data['title']}");
        }
      },
      onError: (e) {
        _updateOutput("Error: ${e.message }");
      },
    );


  }

  Future<void> updatePostPatch() async {
     await fizzyApi.patchApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      body: {'title': 'Patched Title'},
      showLoader: true,
        loaderColor: Colors.blue, context: context,
      onResponse: (res)  {
        if(res.statusCode == 200){
          _updateOutput("PATCH Updated: ${res.data['title']}");
        }
      },
      onError: (e) {
        _updateOutput("Error: ${e.message }");
      },
    );


  }

  Future<void> deletePost() async {
    await fizzyApi.deleteApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      showLoader: true,
        loaderColor: Colors.blue, context: context,
      onResponse: (res)  {
        if(res.statusCode == 200){
          _updateOutput("DELETE Success");
        }
      },
      onError: (e) {
        _updateOutput("Error: ${e.message}");
      },
    );


  }

  Widget buildButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Test App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(output, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            buildButton("GET Single Post", getPost),
            buildButton("GET All Posts", getAllPosts),
            buildButton("POST Create Post", createPost),
            buildButton("PUT Update Post", updatePostPut),
            buildButton("PATCH Update Title", updatePostPatch),
            buildButton("DELETE Post", deletePost),
          ],
        ),
      ),
    );
  }
}
