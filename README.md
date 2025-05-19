
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

## Usage

### Method Signature Parameters

```dart
/// Parameters:
/// 
/// - [url] (required): The endpoint to call.
///
/// - [context] (required): Used to show a loader or other UI feedback. Must be provided when [showLoader] is true.
///
/// - [body]: The request payload to send (for POST, PUT, PATCH).
///
/// - [multipart]: Set to `true` if the request includes file uploads (multipart/form-data). Defaults to `false`.
///
/// - [headers]: Optional custom headers to include with the request.
///
/// - [queryParameters]: Optional query parameters appended to the URL.
///
/// - [options]: Custom Dio [Options], such as timeout settings or content type overrides.
///
/// - [responseType]: Defines the expected response type (e.g. [ResponseType.json], [ResponseType.plain], etc.).
///
/// - [onResponse]: Callback triggered on successful response (status code 2xx). Provides the full [Response] object.
///
/// - [onError]: Callback triggered on error. Provides a [DioException] for granular error handling.
///
/// - [showLoader]: If `true`, a loader overlay is shown during the API call. Defaults to `false`.
///
/// - [loaderColor]: The color of the default CircularProgressIndicator loader. Defaults to [Colors.blue].
///
/// - [loaderSize]: Diameter of the loader spinner. Defaults to `40.0`.
///
/// - [customLoader]: Provide a custom [Widget] to use instead of the default loader.
///
/// - [showDebug]: If `true`, logs request/response metadata (for debugging). Defaults to `true`.
```

---

---

## 🧭 Global Navigator Key Setup (Required)

To enable navigation-based features such as displaying a loader or handling errors during API calls, initialize fizzy_api with a global navigatorKey.

### 🔧 Add This to Your main.dart File

```dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  initializeFizzyApi(navigatorKey: navigatorKey);
  runApp(const MyApp());
}
```

This setup is essential for fizzy_api to properly handle UI-based interactions across your app.

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
