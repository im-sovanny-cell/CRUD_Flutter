import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/screens/add_edit_product_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Corrected import

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: RefreshIndicator(
        // Requirement: Pull-to-refresh
        onRefresh: () => Provider.of<ProductProvider>(context, listen: false)
            .fetchProducts(),
        child: Consumer<ProductProvider>(
          builder: (ctx, provider, _) {
            // Requirement: Loading indicators
            if (provider.state == AppState.loading &&
                provider.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            // Requirement: Error handling
            if (provider.state == AppState.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: ${provider.errorMessage}\n\nPlease ensure the backend server is running.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              );
            }
            if (provider.products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            // Requirement: List of all products using ListView
            return ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (ctx, i) =>
                  _ProductCard(product: provider.products[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const AddEditProductScreen(),
          ));
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(product.productName,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Text(
                  currencyFormat.format(product.price),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            // Middle Row: Stock Info
            Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    size: 18),
                const SizedBox(width: 8),
                Text('Stock available: ${product.stock}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom Row: Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Requirement: Delete with confirmation
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error),
                  onPressed: () => _confirmDelete(context, product),
                ),
                const SizedBox(width: 8),
                // Requirement: Navigate to edit
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text('Edit'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => AddEditProductScreen(product: product),
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product product) {
    // Requirement: Delete with confirmation
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content:
            Text('Are you sure you want to delete "${product.productName}"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await Provider.of<ProductProvider>(context, listen: false)
                    .deleteProduct(product.productId!);
              } catch (e) {
                // Handle error
              }
            },
          ),
        ],
      ),
    );
  }
}
