# fizzy_api

A simple and powerful API wrapper for Flutter using Dio. Easily perform GET, POST, PUT, PATCH, DELETE requests with built-in error handling, response models, custom loader support, and file uploads — all without manually handling responses everywhere.

---

## 🚀 Features

✅ Simple API calling with Dio  
✅ Built-in response and error handling  
✅ Custom loader support  
✅ `onRequest` customization (add headers, modify request)  
✅ File/image upload support  
✅ Consistent API response without writing repeated code  
✅ Works with all HTTP methods (GET, POST, PUT, PATCH, DELETE)  

---

## 📦 Installation

Add `fizzy_api` to your `pubspec.yaml`:


```yaml

import 'package:fizzyApi/fizzyApi.dart';

dependencies:
  fizzy_api: ^1.0.0


## 📚 API Methods

**✅ GET Request**
The fizzyApi.getApi method simplifies making a GET request. It supports optional loader display and returns a strongly typed ApiResponse. You can handle the response using a callback like onResponse.

fizzyApi.getApi(
  'url',
  context: context,
  showLoader: true,
  onResponse: (res) => ApiResponse.success(res.data),
);

**✅ POST Request**
The fizzyApi.postApi method makes it easy to send a POST request with request body data. It also supports an optional loader and uses a unified ApiResponse structure for handling results.

fizzyApi.postApi(
  'url',
  data: {'email': 'test@example.com', 'password': '123456'},
  context: context,
  showLoader: true,
  onResponse: (res) => ApiResponse.success(res.data),
);

