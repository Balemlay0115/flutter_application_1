import '../models/product.dart';

/// Holds all the data of the app in memory.
///
/// Everything is `static`, so any screen can read or change the same lists
/// by writing `MarketStore.products` or `MarketStore.cart`. After changing
/// something, the screen calls `setState` to redraw itself.
///
/// (The data is lost when the app closes. A real app would use a database
/// or a server here.)
class MarketStore {
  // Nobody should create a MarketStore object.
  MarketStore._();

  static final List<Product> products = [
    const Product(
      id: 'p1',
      title: 'Phone X',
      price: 549,
      category: 'smartphones',
      description: '6.1-inch display, 128 GB storage, dual camera.',
    ),
    const Product(
      id: 'p2',
      title: 'Headphones',
      price: 89,
      category: 'audio',
      description: 'Over-ear headphones with 30 hours of battery life.',
    ),
    const Product(
      id: 'p3',
      title: 'T-shirt',
      price: 15,
      category: 'clothing',
      description: '100% cotton, regular fit, machine washable.',
    ),
    const Product(
      id: 'p4',
      title: 'Laptop',
      price: 899,
      category: 'computers',
      description: '14-inch laptop, 16 GB RAM, 512 GB SSD.',
    ),
    const Product(
      id: 'p5',
      title: 'Camera',
      price: 320,
      category: 'photography',
      description: 'Compact camera with 20x optical zoom.',
    ),
    const Product(
      id: 'p6',
      title: 'Backpack',
      price: 42,
      category: 'accessories',
      description: 'Water resistant backpack with a laptop pocket.',
    ),
  ];

  static final List<CartItem> cart = [];

  // ---------------------------------------------------------------- products

  /// Finds a product by its id, or returns null when it no longer exists
  /// (for example because it was deleted on the detail screen).
  static Product? findProduct(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  static void addProduct(Product product) {
    products.add(product);
  }

  static void updateProduct(Product updated) {
    final index = products.indexWhere((product) => product.id == updated.id);
    if (index == -1) return; // Nothing to update.
    products[index] = updated;

    // The cart keeps its own copy of the product, so update it as well.
    for (final item in cart) {
      if (item.product.id == updated.id) {
        cart[cart.indexOf(item)] = CartItem(
          product: updated,
          quantity: item.quantity,
        );
      }
    }
  }

  static void deleteProduct(String id) {
    products.removeWhere((product) => product.id == id);
    // A deleted product should not stay in the cart.
    cart.removeWhere((item) => item.product.id == id);
  }

  /// Creates an id that is not used yet, e.g. "p7".
  static String newProductId() {
    return 'p${DateTime.now().millisecondsSinceEpoch}';
  }

  // -------------------------------------------------------------------- cart

  /// Adds a product to the cart. If it is already there, only the
  /// quantity goes up.
  static void addToCart(Product product, int quantity) {
    final index = cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      cart.add(CartItem(product: product, quantity: quantity));
    } else {
      cart[index].quantity += quantity;
    }
  }

  static void removeFromCart(String productId) {
    cart.removeWhere((item) => item.product.id == productId);
  }

  static void clearCart() {
    cart.clear();
  }

  /// How many single items are in the cart (shown in the app bar badge).
  static int get cartCount {
    int count = 0;
    for (final item in cart) {
      count += item.quantity;
    }
    return count;
  }

  static double get cartTotal {
    double total = 0;
    for (final item in cart) {
      total += item.total;
    }
    return total;
  }
}
