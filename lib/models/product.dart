import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  static const baseUrl = 'https://lecture16-d5ccd-default-rtdb.firebaseio.com';
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = '$baseUrl/userFav/$userId/$id.json?auth=$token';
    //print('In TogFav, userId: $userId, $isFavorite');
    //print('$url');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      print('1 response.statusCode ${response.statusCode}');
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        print('2 response.statusCode ${response.statusCode}');
      }
    } catch (error) {
      _setFavValue(oldStatus);
      print('error: ${error.toString()}');
    }
  }
}
