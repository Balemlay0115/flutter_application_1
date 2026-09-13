import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/market_store.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Opens the detail screen of the tapped product.
  /// `await` waits until we come back, then we redraw the screen because
  /// the product may have been edited or deleted in the meantime.
  Future<void> _openProduct(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: product.id),
      ),
    );

    setState(() {});
  }

  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => CartScreen()),
    );

    setState(() {});
  }

  Future<void> _openAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormScreen()),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final products = MarketStore.products;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Mini Market',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: _openCart,
            child: Badge(
              isLabelVisible: MarketStore.cartCount > 0,
              label: Text("${MarketStore.cartCount}"),
              child: Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: products.isEmpty
            ? const Center(
                child: Text(
                  'No products yet.\nTap + to add your first one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (BuildContext context, int index) {
                  Product product = products[index];
                  return _ProductCard(
                    product: products[index],
                    onTap: () => {_openProduct(product)},
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// One square in the grid: picture box, title and price.
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = colorForCategory(product.category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconForCategory(product.category),
                  color: color,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              "\$${product.price}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
