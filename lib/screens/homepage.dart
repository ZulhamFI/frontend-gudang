import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas/screens/add_product.dart';
import 'package:uas/screens/edit_product.dart';
import 'dart:convert';

import 'package:uas/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'http://10.0.2.2:8000/api/products';

//127.0.0.1
  Future getProducts() async {
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  Future deleteProduct(String productID) async {
    String url = 'http://10.0.2.2:8000/api/products/' + productID;

    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Gudang'),
      ),
      body: FutureBuilder(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data['data'].length,
                  itemBuilder: (context, index) {
                    // return Text(snapshot.data['data'][index]['name']);
                    return Container(
                      height: 160,
                      child: Card(
                        elevation: 5,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                              product: snapshot.data['data']
                                                  [index],
                                            )));
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  height: 120,
                                  width: 120,
                                  child: Image.network(
                                    snapshot.data['data'][index]['image_url'],
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      snapshot.data['data'][index]['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data['data'][index]
                                          ['description'],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Stock : "),
                                        Text(snapshot.data['data'][index]
                                            ['total']),
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  editProduct(
                                                                    product: snapshot
                                                                            .data['data']
                                                                        [index],
                                                                  )));
                                                },
                                                child: Icon(Icons.edit)),
                                            GestureDetector(
                                                onTap: () {
                                                  deleteProduct(snapshot
                                                          .data['data'][index]
                                                              ['id']
                                                          .toString())
                                                      .then((value) {
                                                    setState(() {});
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Product Berhasil di Hapus")));
                                                  });
                                                },
                                                child: Icon(Icons.delete)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Text('data error');
            }
          }),
    );
  }
}
