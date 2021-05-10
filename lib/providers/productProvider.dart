import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
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

  Future<void> toggleFavorite(String token, String userId) async {
    final existingState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final res = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (res.statusCode >= 400) {
        isFavorite = existingState;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = existingState;
      notifyListeners();
    }
  }
}
