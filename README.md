# fizzy_api

A simplified abstraction over the `dio` package to make API calls clean, consistent, and maintainable in Flutter apps.

---

## 🚀 Features

- Lightweight wrapper over `dio`
- Supports GET, POST, PUT, DELETE methods
- Global configuration for base URL
- Unified response model
- Loader integration for showing API progress
- Custom exception handling

---

## 📦 Installation

Add `fizzy_api` to your `pubspec.yaml`:

```yaml
dependencies:
  fizzy_api: ^1.0.0

## 📚 API Methods

**GET Request**

fizzyApi.getApi(
  'endpoint',
  onResponse: (res) => ApiResponse.success(res.data),
  context: context,
  showLoader: true,
);

**POST Request**

fizzyApi.postApi(
  'login',
  data: {'email': 'test@example.com', 'password': '123456'},
  onResponse: (res) => ApiResponse.success(res.data),
  context: context,
);

