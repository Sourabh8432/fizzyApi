import 'package:fizzy_api/fizzy_api.dart';
import 'package:flutter/material.dart';

import 'api_response.dart';
import 'loader.dart'; // your ApiResponse file import
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  initializeFizzyApi(navigatorKey: navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const ApiDemoScreen(),
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
    print("SSK");
    final response = await fizzyApi.getApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      onResponse: (res) => ApiResponse.success(res.data),
      showLoader: true,
      loaderColor: Colors.red, context: context,
    );


    if (response.status == Status.success) {
      _updateOutput("GET: ${response.data['title']}");
    } else {
      _updateOutput("Error: ${response.message ?? response.status}");
    }
  }

  Future<void> getAllPosts() async {
    final response = await fizzyApi.getApi(
      'https://jsonplaceholder.typicode.com/posts',
      onResponse: (res) => ApiResponse.success(res.data),
      showLoader: true,
        loaderColor: Colors.blue, context: context
    );

    if (response.status == Status.success) {
      _updateOutput("Total posts fetched: ${response.data.length}");
    } else {
      _updateOutput("Error: ${response.message ?? response.status}");
    }
  }

  Future<void> createPost() async {
    final response = await fizzyApi.postApi(
      'https://jsonplaceholder.typicode.com/posts',
      body: {
        'title': 'New Title',
        'body': 'Post body content',
        'userId': 1,
      },
      customLoader: const ModernOrbitLoader(),
      onResponse: (res) => ApiResponse.success(res.data), context: context,
    );

    if (response.status == Status.success) {
      _updateOutput("POST Created: ID = ${response.data['id']}");
    } else {
      _updateOutput("Error: ${response.message ?? response.status}");
    }
  }

  Future<void> updatePostPut() async {
    final response = await fizzyApi.putApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      body: {
        'id': 1,
        'title': 'Updated Title PUT',
        'body': 'Updated content with PUT',
        'userId': 1,
      },
      showLoader: true,
        loaderColor: Colors.blue,
      onResponse: (res) => ApiResponse.success(res.data), context: context,
    );

    if (response.status == Status.success) {
      _updateOutput("PUT Updated: ${response.data['title']}");
    } else {
      _updateOutput("Error: ${response.message ?? response.status}");
    }
  }

  Future<void> updatePostPatch() async {
    final response = await fizzyApi.patchApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      body: {'title': 'Patched Title'},
      onResponse: (res) => ApiResponse.success(res.data),
      showLoader: true,
        loaderColor: Colors.blue, context: context,
    );

    if (response.status == Status.success) {
      _updateOutput("PATCH Updated: ${response.data['title']}");
    } else {
      _updateOutput("Error: ${response.message ?? response.status}");
    }
  }

  Future<void> deletePost() async {
    final response = await fizzyApi.deleteApi(
      'https://jsonplaceholder.typicode.com/posts/1',
      onResponse: (res) => ApiResponse.success("Deleted"),
      showLoader: true,
        loaderColor: Colors.blue, context: context,
    );

    if (response.status == Status.success) {
      _updateOutput("DELETE Success");
    } else {
      _updateOutput("Error: ${response.message ?? response.status}");
    }
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
