import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/constants/colors.dart';
import 'package:supabase_dashboard/core/services/image_picker_service.dart';
import 'package:supabase_dashboard/dashboard/data/models/product_model.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/products/products_cubit.dart';

class EditProductView extends StatefulWidget {
  final ProductModel product;

  const EditProductView({
    super.key,
    required this.product,
  });

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _discountPercentageController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _expiryNameController = TextEditingController();
  final _expiryNumberController = TextEditingController();
  String? _imageUrl;
  String? _selectedCategoryId;
  bool _isAvailable = true;
  bool _hasDiscount = false;
  bool _isLoading = false;
  bool _isOrganic = false;
  double _discountPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _discountPercentageController.addListener(_calculateDiscountPrice);
    _priceController.addListener(_calculateDiscountPrice);
  }

  void _calculateDiscountPrice() {
    if (_hasDiscount && 
        _priceController.text.isNotEmpty && 
        _discountPercentageController.text.isNotEmpty) {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final discount = int.tryParse(_discountPercentageController.text) ?? 0;
      setState(() {
        _discountPrice = price * (1 - discount / 100);
      });
    } else {
      setState(() {
        _discountPrice = 0.0;
      });
    }
  }

  void _initializeControllers() {
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _stockController.text = widget.product.stock.toString();
    _imageUrl = widget.product.imageUrl;
    _selectedCategoryId = widget.product.categoryId;
    _isAvailable = widget.product.isAvailable;
    _hasDiscount = widget.product.hasDiscount;
    _isOrganic = widget.product.isOrganic;
    _caloriesController.text = widget.product.caloriesPer100g.toString();
    _expiryNameController.text = widget.product.expiryName;
    _expiryNumberController.text = widget.product.weight.toString();
    if (_hasDiscount && widget.product.discountPercentage != null) {
      _discountPercentageController.text = widget.product.discountPercentage.toString();
      _discountPrice = widget.product.discountPrice ?? 0.0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _discountPercentageController.dispose();
    _caloriesController.dispose();
    _expiryNameController.dispose();
    _expiryNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final imageUrl = await ImagePickerService.pickImage(isProduct: true);
      if (imageUrl != null) {
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في رفع الصورة: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedProduct = widget.product.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrl,
        categoryId: _selectedCategoryId!,
        hasDiscount: _hasDiscount,
        discountPercentage: _hasDiscount
            ? int.parse(_discountPercentageController.text)
            : null,
        discountPrice: _hasDiscount ? _discountPrice : null,
        isAvailable: _isAvailable,
        stock: int.parse(_stockController.text),
        isOrganic: _isOrganic,
        caloriesPer100g: double.tryParse(_caloriesController.text) ?? 0.0,
        expiryName: _expiryNameController.text,
        expiryNumber: double.tryParse(_expiryNumberController.text) ?? 0.0,
      );

      await context.read<ProductsCubit>().updateProduct(widget.product.id, updatedProduct);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث المنتج بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'فشل في تحديث المنتج';
      if (e.toString().contains('updated_at')) {
        errorMessage = 'عذراً، حدث خطأ في تحديث المنتج. سنقوم بإصلاح هذه المشكلة قريباً.';
      } else {
        errorMessage = 'فشل في تحديث المنتج: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'حسناً',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل المنتج'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_imageUrl != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.network(
                    _imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _imageUrl = null),
                  ),
                ],
              )
            else
              InkWell(
                onTap: _isLoading ? null : _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 50),
                              SizedBox(height: 8),
                              Text('اضغط لتغيير الصورة'),
                            ],
                          ),
                        ),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المنتج',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم المنتج';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'وصف المنتج',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال وصف المنتج';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'السعر',
                      border: OutlineInputBorder(),
                      suffixText: 'جنيه مصري',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال السعر';
                      }
                      if (double.tryParse(value) == null) {
                        return 'الرجاء إدخال سعر صحيح';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'الكمية',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الكمية';
                      }
                      if (int.tryParse(value) == null) {
                        return 'الرجاء إدخال كمية صحيحة';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('متوفر'),
              value: _isAvailable,
              onChanged: (value) => setState(() => _isAvailable = value),
            ),
            SwitchListTile(
              title: const Text('خصم'),
              value: _hasDiscount,
              onChanged: (value) {
                setState(() {
                  _hasDiscount = value;
                  if (!value) {
                    _discountPercentageController.clear();
                    _discountPrice = 0.0;
                  }
                });
                _calculateDiscountPrice();
              },
            ),
            SwitchListTile(
              title: const Text('منتج صحى'),
              value: _isOrganic,
              onChanged: (value) => setState(() => _isOrganic = value),
            ),
            if (_hasDiscount) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountPercentageController,
                decoration: const InputDecoration(
                  labelText: 'نسبة الخصم %',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال نسبة الخصم';
                  }
                  final discount = int.tryParse(value);
                  if (discount == null || discount <= 0 || discount >= 100) {
                    return 'الرجاء إدخال نسبة خصم صحيحة بين 1 و 99';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              if (_discountPrice > 0) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'السعر بعد الخصم: ${_discountPrice.toStringAsFixed(2)} ريال',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'السعرات الحرارية لكل 100 جرام',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال السعرات الحرارية';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expiryNameController,
              decoration: const InputDecoration(
                labelText: 'وقت التحضير',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم الصلاحية';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expiryNumberController,
              decoration: const InputDecoration(
                labelText: 'الوزن بالجرام',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الصلاحية';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('حفظ التغييرات' , style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
