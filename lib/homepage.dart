import 'package:flutter/material.dart';
import 'data.dart';
import 'product.dart';
import 'login.dart';

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
        actionsPadding: EdgeInsets.only(right: 14),
        centerTitle: true,
        backgroundColor: Colors.white24,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            alignment: Alignment.topLeft,
            onPressed: () {
              DBHelper.clearProducts();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.blue),
            alignment: Alignment.topRight,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductListPage()),
              );
            },
          ),
        ],
      ),

      backgroundColor: Colors.cyan[400],
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white60,
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
          SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: <Widget>[
              _buildProductCard(
                'IPHONE 17',
                29900,
                "https://cdsassets.apple.com/live/7WUAS350/images/tech-specs/iphone-17-pro-17-pro-max-hero.png",
              ),
              _buildProductCard(
                'IPHONE 15',
                20900,
                "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-15-pro-blue-titanium.png?v=c9cac115",
              ),
              _buildProductCard(
                'OPPO RENO 8',
                14900,
                "https://www.oppo.com/content/dam/oppo/product-asset-library/specs/reno8/Reno8-specs.png",
              ),
              _buildProductCard(
                'SAMSUNG A32',
                8499,
                "https://wefix.co.za/cdn/shop/files/Samsung-Galaxy-A32-Black.png?v=1720169197",
              ),
              _buildProductCard(
                'VIVO Y22',
                5000,
                "https://www.j9phone.com/images/content/original-1666773189448.png",
              ),
              _buildProductCard(
                'RTX 5060',
                11500,
                "https://asset.msi.com/resize/image/global/product/product_1744697766c5c115b4f5fd7151513b1dc4f8a217e7.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png",
              ),
              _buildProductCard(
                'RTX 4060',
                10000,
                "https://asset.msi.com/resize/image/global/product/product_1689818386ac068f120cf48b695864a745ea4fe414.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png",
              ),
              _buildProductCard(
                'RTX 5090',
                79500,
                "https://th-store.msi.com/cdn/shop/files/1024_138cc34d-56fe-42fe-8ddf-f3206dc7309b.png?v=1745496213",
              ),
              _buildProductCard(
                'RX 6600',
                6500,
                "https://asset.msi.com/resize/image/global/product/product_163549877903101ecb5a1ed4f51762e05800a7ce8d.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png",
              ),
              _buildProductCard(
                'i9 14900K',
                18000,
                "https://www.jib.co.th/img_master/product/original/2023101615262063040_1.png",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, int price, String imageUrl) {
    return Card(
      color: Colors.white30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, height: 70, width: 70, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(name, style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          Text(
            'ราคา ${price.toString()} บาท',
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              overlayColor: Colors.lightBlue,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            onPressed: () async {
              final existingProducts = await DBHelper.getProducts();
              if (existingProducts.any((p) => p['name'] == name)) {
                final productToUpdate = existingProducts.firstWhere(
                  (p) => p['name'] == name,
                  orElse: () => throw Exception('Product not found'),
                );

                await DBHelper.updateQuantity(
                  productToUpdate['id'],
                  (productToUpdate['quantity'] ?? 1) + 1,
                );

                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$name เพิ่มสำเร็จ')));
                return;
              }
              await DBHelper.insertProduct({
                'name': name,
                'price': price,
                'quantity': 1,
              });

              printDbPath();
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('เพิ่ม$nameลงตะกร้าแล้ว')));
            },
            child: Text(
              'เพิ่มใส่ตะกร้า',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
