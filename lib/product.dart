import 'package:flutter/material.dart';
import 'data.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DBHelper.getProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสินค้าในตะกร้า'),
        backgroundColor: Colors.blue,
      ),
      body: _products.isEmpty
          ? Center(child: Text('ยังไม่มีสินค้าในตะกร้า'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final item = _products[index];
                final quantity = item['quantity'] ?? 1;
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(item['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคา ${item['price']} บาท'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () async {
                              if (quantity > 1) {
                                await DBHelper.updateQuantity(
                                  item['id'],
                                  quantity - 1,
                                );
                                _loadProducts();
                              }
                            },
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              await DBHelper.updateQuantity(
                                item['id'],
                                quantity + 1,
                              );
                              _loadProducts();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DBHelper.deleteProduct(item['id']);
                      _loadProducts();
                    },
                  ),
                );
              },
            ),
    );
  }
}
