# fizzy_api

A simple and powerful API wrapper for Flutter built on top of Dio.  
Easily perform GET, POST, PUT, PATCH, DELETE requests with built-in error handling, customizable loaders, response models, and file upload support — all while avoiding repetitive response handling throughout your app.

---

## 🚀 Features

- Simple and clean API calling with Dio  
- Built-in response and error handling  
- Custom loader integration  
- Request customization (headers, parameters, etc.)  
- File/image upload support  
- Unified API response format  
- Supports all major HTTP methods (GET, POST, PUT, PATCH, DELETE)  

---

## 📦 Installation

Add `fizzy_api` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  fizzy_api: ^1.0.0
```

Import in your Dart files:

```dart
import 'package:fizzy_api/fizzy_api.dart';
```

---

## 📚 Usage Examples

### GET Request

Make a GET request easily with optional loader display and typed response handling.

```dart
fizzyApi.getApi(
  'https://example.com/api/data',
  context: context,
  showLoader: true,
  onResponse: (res) => ApiResponse.success(res.data),
);
```

### POST Request

Send POST requests with data, loader support, and unified response handling.

```dart
fizzyApi.postApi(
  'https://example.com/api/login',
  data: {'email': 'test@example.com', 'password': '123456'},
  context: context,
  showLoader: true,
  onResponse: (res) => ApiResponse.success(res.data),
);
```

---

## 🖼️ Uploading Image or File

Easily upload files using multipart form data. Ideal for image or document uploads.

```dart
fizzyApi.postApi(
  'upload',
  data: {'name': 'test', 'image': File('path/to/image.png')},
  context: context,
  multipart: true,
  onResponse: (res) => ApiResponse.success(res.data),
);
```

## ✅ PUT Request

Update a complete resource using the PUT method. Perfect for replacing existing user data.

```dart
fizzyApi.putApi(
  'user/1',
  data: {'name': 'New Name'},
  context: context,
  onResponse: (res) => ApiResponse.success(res.data),
);
```

## ✅ PATCH Request

Modify part of a resource using the PATCH method. Great for status updates or partial changes.

```dart
fizzyApi.patchApi(
  'user/1',
  data: {'status': 'active'},
  context: context,
  onResponse: (res) => ApiResponse.success(res.data),
);
```

## ✅ DELETE Request

Delete a resource by ID or endpoint with a clean and simple call.

```dart
fizzyApi.deleteApi(
  'user/1',
  context: context,
  onResponse: (res) => ApiResponse.success(res.data),
);
```
