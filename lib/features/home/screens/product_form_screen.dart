import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../../../core/constants/categories.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product; // null = mode tambah, ada isinya = mode edit

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _selectedCategory = widget.product?.category ?? productCategories.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      price: int.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
      category: _selectedCategory,
      description: _descriptionController.text,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Ubah Produk' : 'Tambah Produk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga wajib diisi';
                  if (int.tryParse(value) == null) return 'Harga harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: productCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'URL gambar wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEditMode ? 'Simpan Perubahan' : 'Tambah Produk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}