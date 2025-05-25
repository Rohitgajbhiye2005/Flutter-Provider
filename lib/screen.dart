import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/db_helper.dart';


class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {


  DBHelper? dbHelper=DBHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://images.pexels.com/photos/2875814/pexels-photo-2875814.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/109274/pexels-photo-109274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/461210/pexels-photo-461210.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/6605350/pexels-photo-6605350.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  ];
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Product List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,

        actions: [
          InkWell(
            onTap: () {
              
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(builder: (context,value,child){
                  return Text(value.getcounter().toString(),style: TextStyle(color: Colors.white));
                },
                ),
                child: Icon(Icons.shopping_cart)
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          height: 100,
                          width: 100,
                          image: NetworkImage(productImage[index].toString()),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName[index].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              // ignore: prefer_interpolation_to_compose_strings
                              Text(
                                productUnit[index].toString() +
                                    " " +
                                    r"$" +
                                    productPrice[index].toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: (){
                                    dbHelper?.insert(
                                      Cart(id: index,
                                       productId: index.toString(),
                                        productName: productName[index].toString(),
                                         initialPrice: productPrice[index],
                                          productPrice: productPrice[index],
                                           quantity: 1, 
                                           unitTag: productUnit[index].toString(), 
                                           image: productImage[index].toString())
                                    ).then((value) {
                                      print('product is added to cart');
                                      cart.addtotalprice(double.parse(productPrice[index].toString()));
                                      cart.addcounter();
                                    }).onError((error,stackTrace){
                                      // ignore: avoid_print
                                      print(error.toString());
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                  
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.green,
                                    ),
                                    child: Center(child: Text("Add to cart")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
