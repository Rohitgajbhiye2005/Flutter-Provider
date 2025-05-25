import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/db_helper.dart';


class CartProvider with ChangeNotifier{


  DBHelper db=DBHelper();
  int _counter=0;
  int get counter=>_counter;

  double _totalprice=0.0;
  double get totalprice=>_totalprice;

  late Future<List<Cart>> _cart;

  Future<List<Cart>> get cart=> _cart;

  Future<List<Cart>> getData()async{
    _cart=db.getcartList();
    return _cart;
  }
  

  void setpref()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setInt('cart_item', _counter);
    pref.setDouble('total_price', _totalprice);
    notifyListeners();
  }

  void getpref()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    _counter=pref.getInt('cart_item')?? 0;
    _totalprice=pref.getDouble('total_price')?? 0.0;
    notifyListeners();
  }

  void addcounter(){
    _counter++;
    setpref();
    notifyListeners();
  }

   void removecounter(){
    _counter--;
    setpref();
    notifyListeners();
  }

  int getcounter(){
    getpref();
    return _counter;
  }

  void addtotalprice(double productPrice){
    _totalprice+=productPrice;
    setpref();
    notifyListeners();
  }

   void removetotalprice(double productPrice){
    _totalprice-=productPrice;
    setpref();
    notifyListeners();
  }

  double gettotalprice(){
    getpref();
    return _totalprice;
  }

}