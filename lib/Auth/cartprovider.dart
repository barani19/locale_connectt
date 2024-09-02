import 'package:flutter/material.dart';

class Cartprovider extends ChangeNotifier {
  Map<String, dynamic> cart = {};
  List<Map<String, dynamic>> order = [];

  double total = 0;
  void addproduct(Map<String, dynamic> product, String vendid) {
    if (cart.containsKey(vendid)) {
      cart[vendid].add(product);
    } else {
      cart[vendid] = [product];
    }
    notifyListeners();
  }

  void removeproduct(Map<String, dynamic> product, String vendid) {
    cart[vendid].remove(product);
    notifyListeners();
  }

  void updateorder(List<Map<String, dynamic>> mycart) {
    order += mycart;
    notifyListeners();
  }

  void removeall() {
    cart = {};
    order = [];
    total = 0;
    notifyListeners();
  }

  void addmoney(double price) {
    total += price;
  }

  void removemoney(double price) {
    total -= price;
  }

  double get money => total;
}
