# pzilla

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# networking functionalities to check

- login
- register
- checkout
- categories initial loading + nextpage
- shop initial loading + nextpage
- searching
- orders fetching
- logout

# Setup
- Create a ```credentials.dart``` file inside ``lib`` folder. This contains API keys to interact with server.
```dart
class Credentials {
  static const String readApiKey =
      '';
  static const String readApiSecret =
      '';
  static const String writeApiKey =
      '';
  static const String writeApiSecret =
      '';
  static const String rootAddress =
      '';
// Add other credentials as needed
}
```
