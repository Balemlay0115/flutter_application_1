import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/market_store.dart';
import '../models/product.dart';

/// One screen for both jobs:
/// - `ProductFormScreen()`            -> add a new product
/// - `ProductFormScreen(product: p)`  -> edit the product `p`
class ProductFormScreen extends StatefulWidget {
  final Product? product; // will be null while adding a product

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  /// The key lets us run the validators of every field at once.
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = kCategories.first;

  /// True when we opened the screen with a product to edit.
  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    // When editing, start with the values the product already has.
    final product = widget.product;
    if (product != null) {
      _titleController.text = product.title;
      _priceController.text = product.price.toStringAsFixed(0);
      _descriptionController.text = product.description;
      _category = product.category;
    }
  }

  @override
  void dispose() {
    // Controllers must be cleaned up, otherwise they leak memory.
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a title';
    }
    return null; // null means "this field is fine".
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a price';
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Enter a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  void _save() {
    // validate() runs every validator above and shows the red messages.
    if (!_formKey.currentState!.validate()) {
      return; // Something is wrong, stay on the screen.
    }

    final title = _titleController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim();

    if (_isEditing) {
      MarketStore.updateProduct(
        widget.product!.copyWith(
          title: title,
          price: price,
          category: _category,
          description: description,
        ),
      );
    } else {
      MarketStore.addProduct(
        Product(
          id: MarketStore.newProductId(),
          title: title,
          price: price,
          category: _category,
          description: description,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Product updated' : 'Product added'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit product' : 'Add product',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const _FieldLabel('Title'),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'Desk lamp'),
                      validator: _validateTitle,
                    ),
                    const SizedBox(height: 16),

                    const _FieldLabel('Price'),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '0'),
                      validator: _validatePrice,
                    ),
                    const SizedBox(height: 16),

                    const _FieldLabel('Category'),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      items: [
                        for (final category in kCategories)
                          DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _category = value);
                      },
                    ),
                    const SizedBox(height: 16),

                    const _FieldLabel('Description'),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Short description',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Save changes' : 'Save product',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The small grey text above every field.
class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }
}
