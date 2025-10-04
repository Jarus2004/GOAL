import 'package:flutter/material.dart';
import 'data.dart';
import 'product.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ร้านค้า'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductListPage()),
              );
            },
          ),
        ],
      ),

      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'ยินดีต้อนรับสู่ร้านค้าออนไลน์',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 24),
          // Product List
          Text(
            'สินค้า',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: <Widget>[
              _buildProductCard('สมาร์ทโฟน', 10000),
              _buildProductCard('สมาร์ทโฟน', 10000),
              _buildProductCard('สมาร์ทโฟน', 10000),
              _buildProductCard('สมาร์ทโฟน', 10000),
              _buildProductCard('สมาร์ทโฟน', 10000),
              _buildProductCard('สมาร์ทโฟน', 10000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, int price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_android, size: 48, color: Colors.blue),
          SizedBox(height: 8),
          Text(name, style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          Text(
            'ราคา ${price.toString()} บาท',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          ElevatedButton(
            onPressed: () async {
              await DBHelper.insertProduct({'name': name, 'price': price});
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('เพิ่ม$nameลงตะกร้าแล้ว')));
            },
            child: Text('เพิ่มใส่ตะกร้า'),
          ),
        ],
      ),
    );
  }
}
