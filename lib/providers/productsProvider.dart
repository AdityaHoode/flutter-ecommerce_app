import 'package:ecommerce_app/providers/productProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get getItems {
    return [..._items];
  }

  List<Product> get getFavItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> getProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final res = await http.get(url);
      final extractedProducts = json.decode(res.body) as Map<String, dynamic>;
      if (extractedProducts == null) {
        return;
      }

      final favUrl = Uri.parse(
          'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favRes = await http.get(favUrl);
      final favData = json.decode(favRes.body);

      final List<Product> loadedProducts = [];
      extractedProducts.forEach((pId, pData) {
        loadedProducts.add(
          Product(
            id: pId,
            title: pData['title'],
            price: pData['price'],
            description: pData['description'],
            imageUrl: pData['imageUrl'],
            isFavorite: favData == null ? false : favData[pId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    return http
        .post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        },
      ),
    )
        .then((res) {
      print(json.decode(res.body));
      final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) {
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    return http.delete(url).then((res) {
      print(json.decode(res.body));
      if (res.statusCode >= 400) {
        throw Exception();
      }
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }
}
