# Pzilla

A Flutter-based ecommerce application integrated with Wordpress-based website.

## Getting Started

- [Material UI for Flutter](https://docs.flutter.dev/ui/design/material)
- [Plugins/packages for Flutter and Dart](https://pub.dev/)
- [Woocommerce REST API documentation](https://woocommerce.github.io/woocommerce-rest-api-docs/)
- [Wordpress API documentation](https://developer.wordpress.org/rest-api/reference/)

# Take note of 3 important files

```
items.dart
logindetails.dart
order.dart
```
These files form the backbone of the application. There are various classes declared within. You can change them as per your need.

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

# Networking functionalities to check

- Login
- Register
- Checkout
- Categories initial loading + loadMore
- Shop initial loading + loadMore
- Searching
- Orders fetching
- Logout
