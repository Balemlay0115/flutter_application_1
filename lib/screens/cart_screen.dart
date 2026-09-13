import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/market_store.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _removeItem(String productId) {
    setState(() {
      MarketStore.removeFromCart(productId);
    });
  }

  Future<void> _checkout() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank you!'),
        content: Text('Your order of \$${MarketStore.cartTotal} was placed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    setState(() {
      MarketStore.clearCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = MarketStore.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final color = colorForCategory(item.product.category);

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            iconForCategory(item.product.category),
                            color: color,
                          ),
                        ),
                        title: Text(
                          item.product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Qty ${item.quantity}'),
                        trailing: IconButton(
                          onPressed: () => _removeItem(item.product.id),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            "\$${MarketStore.cartTotal}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _checkout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
