import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/dummy_products.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/summary_card.dart';
import '../widgets/category_filter.dart';
import '../../../core/constants/categories.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _products = List.of(dummyProducts);
  String _selectedCategory = 'Semua';

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Semua') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin mau hapus "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openAddProductForm() async {
    final newProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormScreen()),
    );

    if (newProduct != null) {
      setState(() {
        _products.add(newProduct);
      });
    }
  }

  void _openEditProductForm(Product product) async {
    final updatedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (context) => ProductFormScreen(product: product)),
    );

    if (updatedProduct != null) {
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        _products[index] = updatedProduct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog Dashboard'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SummaryCard(
                    label: 'Total Produk',
                    value: '${_products.length}',
                    icon: Icons.inventory_2,
                  ),
                  SummaryCard(
                    label: 'Kategori',
                    value: '${productCategories.length}',
                    icon: Icons.category,
                  ),
                ],
              ),
            ),
            CategoryFilter(
              categories: ['Semua', ...productCategories],
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = (constraints.maxWidth / 180).floor().clamp(2, 6);

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductGridItem(
                        product: product,
                        onEdit: () => _openEditProductForm(product),
                        onDelete: () => _confirmDelete(product),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProductForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
