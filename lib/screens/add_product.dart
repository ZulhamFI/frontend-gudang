import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uas/screens/homepage.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _totalController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

  Future saveProduct() async {
    final response =
        await http.post(Uri.parse("http://10.0.2.2:8000/api/products"), body: {
      "name": _nameController.text,
      "description": _descController.text,
      "total": _totalController.text,
      "image_url": _imageController.text
    });

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0), labelText: "Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Masukkan Nama Product";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
                  labelText: "Description"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Masukkan Deskripsi Product";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _totalController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0), labelText: "Total"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Masukkan Jumlah Product";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0), labelText: "Image_url"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Masukkan Image_url Product";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveProduct().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Product Berhasil di Tambah"),
                      ));
                    });
                  }
                },
                child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
