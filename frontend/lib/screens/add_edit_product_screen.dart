import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:provider/provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _stock;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Requirement: Pre-filled form for editing
    if (widget.product != null) {
      _name = widget.product!.productName;
      _price = widget.product!.price;
      _stock = widget.product!.stock;
    } else {
      _name = '';
      _price = 0.0;
      _stock = 0;
    }
  }

  Future<void> _saveForm() async {
    // 1. Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productToSave = Product(
      productId: widget.product?.productId,
      productName: _name,
      price: _price,
      stock: _stock,
    );

    try {
      // 2. Check if it's a new product or an update
      if (widget.product == null) {
        // Requirement: Submit button to create new product
        await productProvider.addProduct(productToSave);
      } else {
        // Requirement: Save changes via PUT request
        await productProvider.updateProduct(productToSave);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Handle any errors during the save process
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save product: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: _isLoading
          // Requirement: Loading indicators
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Requirement: TextFormFields for name, price, stock
                    _buildTextFormField(
                      initialValue: _name,
                      labelText: 'Product Name',
                      icon: Icons.shopping_bag_outlined,
                      validator: (value) =>
                          value!.isEmpty ? 'Please provide a name.' : null,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      initialValue: _price > 0 ? _price.toStringAsFixed(2) : '',
                      labelText: 'Price',
                      icon: Icons.attach_money_outlined,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter a price.';
                        if (double.tryParse(value) == null)
                          return 'Please enter a valid number.';
                        if (double.parse(value) <= 0)
                          return 'Please enter a positive price.';
                        return null;
                      },
                      onSaved: (value) => _price = double.parse(value!),
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      initialValue: _stock > 0 ? _stock.toString() : '',
                      labelText: 'Stock Quantity',
                      icon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter a stock value.';
                        if (int.tryParse(value) == null)
                          return 'Please enter a valid integer.';
                        if (int.parse(value) < 0)
                          return 'Stock cannot be negative.';
                        return null;
                      },
                      onSaved: (value) => _stock = int.parse(value!),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save_alt_outlined),
                      label: Text(isEditing ? 'Save Changes' : 'Add Product'),
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper widget to create styled TextFormFields consistently
  Widget _buildTextFormField({
    required String? initialValue,
    required String labelText,
    required IconData icon,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Colors.black.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
