import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'update_Dish.dart'; // Import trang update_Dish.dart
import 'package:fn_prj/admin/add_Dish1.dart';
class DishListPage1 extends StatefulWidget {
  @override
  _DishListPageState createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage1> {
  final DatabaseReference _dishesRef =
      FirebaseDatabase.instance.ref().child("dishes");

  List<Map<String, dynamic>> _dishes = [];

  @override
  void initState() {
    super.initState();
    _fetchDishes();
  }

  void _fetchDishes() {
    _dishesRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        List<Map<String, dynamic>> dishesList = [];
        data.forEach((key, value) {
          dishesList.add({
            'id': key,
            'name': value['name'] ?? 'Unknown',
            'category': value['category'] ?? 'Unknown',
            'description': value['description'] ?? 'No description available',
            'image_base64': value['image_base64'] ?? '',
            'created_at': value['created_at'] ?? 'Unknown time',
          });
        });
        setState(() {
          _dishes = dishesList;
        });
      }
    });
  }

  void _deleteDish(String id) {
    _dishesRef.child(id).remove();
  }

  void _navigateToUpdatePage(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateDish(dishId: id),
      ),
    );
  }
void _navigateToAddDishPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDish1(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách món ăn'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddDishPage,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dishes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dishes[index]['name'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDish(_dishes[index]['id']),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _navigateToUpdatePage(_dishes[index]['id']),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${_dishes[index]['category']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description: ${_dishes[index]['description']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Created at: ${_dishes[index]['created_at']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  _dishes[index]['image_base64']!.isNotEmpty
                      ? Image.memory(
                          Base64Decoder()
                              .convert(_dishes[index]['image_base64']!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image, size: 50, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
