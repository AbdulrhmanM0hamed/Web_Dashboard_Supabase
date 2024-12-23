import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/constants/colors.dart';
import 'package:supabase_dashboard/core/services/image_picker_service.dart';
import 'package:supabase_dashboard/dashboard/data/models/special_offer_model.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/special_offers/special_offers_cubit.dart';

class EditSpecialOfferView extends StatefulWidget {
  final SpecialOfferModel offer;

  const EditSpecialOfferView({Key? key, required this.offer}) : super(key: key);

  @override
  State<EditSpecialOfferView> createState() => _EditSpecialOfferViewState();
}

class _EditSpecialOfferViewState extends State<EditSpecialOfferView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _offerPriceController;
  final _newItemController = TextEditingController();
  final _newTermController = TextEditingController();
  
  List<String> _includedItems = [];
  List<String> _terms = [];
  String? _categoryId;
  DateTime? _validUntil;
  Map<String, dynamic>? _customizations;
  String? _image1;
  String? _image2;
  bool _isActive = true;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.offer.title);
    _subtitleController = TextEditingController(text: widget.offer.subtitle);
    _descriptionController = TextEditingController(text: widget.offer.description);
    _offerPriceController = TextEditingController(
        text: widget.offer.offerPrice?.toString() ?? '');
    _includedItems = List.from(widget.offer.includedItems);
    _terms = List.from(widget.offer.terms);
    _categoryId = widget.offer.categoryId;
    _validUntil = widget.offer.validUntil;
    _customizations = widget.offer.customizations;
    _image1 = widget.offer.image1;
    _image2 = widget.offer.image2;
    _isActive = widget.offer.isActive;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _offerPriceController.dispose();
    _newItemController.dispose();
    _newTermController.dispose();
    super.dispose();
  }

  void _addIncludedItem() {
    if (_newItemController.text.isNotEmpty) {
      setState(() {
        _includedItems.add(_newItemController.text);
        _newItemController.clear();
      });
    }
  }

  void _removeIncludedItem(int index) {
    setState(() {
      _includedItems.removeAt(index);
    });
  }

  void _addTerm() {
    if (_newTermController.text.isNotEmpty) {
      setState(() {
        _terms.add(_newTermController.text);
        _newTermController.clear();
      });
    }
  }

  void _removeTerm(int index) {
    setState(() {
      _terms.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final updatedOffer = widget.offer.copyWith(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          description: _descriptionController.text,
          offerPrice: double.tryParse(_offerPriceController.text),
          includedItems: _includedItems,
          validUntil: _validUntil,
          terms: _terms,
          categoryId: _categoryId,
          customizations: _customizations,
          image1: _image1,
       //   image2: _image2,
          isActive: _isActive,
        );

        await context
            .read<SpecialOffersCubit>()
            .updateSpecialOffer(updatedOffer);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: TColors.success,
                content: Text('تم تحديث العرض بنجاح')),
          );
          Navigator.pop(context, true); // Return true to trigger refresh
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: TColors.error,
                content: Text('حدث خطأ: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل العرض'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان العرض *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'برجاء إدخال عنوان العرض';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subtitleController,
                decoration: InputDecoration(
                  labelText: 'العنوان الفرعي *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'برجاء إدخال العنوان الفرعي';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'وصف العرض',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _offerPriceController,
                decoration: InputDecoration(
                  labelText: 'سعر العرض',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              const Text(
                'المميزات المتضمنة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _newItemController,
                      decoration: InputDecoration(
                        labelText: 'أضف ميزة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addIncludedItem,
                    icon: const Icon(Icons.add_circle),
                    color: TColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _includedItems.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeIncludedItem(entry.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'الشروط والأحكام',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _newTermController,
                      decoration: InputDecoration(
                        labelText: 'أضف شرط',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addTerm,
                    icon: const Icon(Icons.add_circle),
                    color: TColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _terms.asMap().entries.map((entry) {
                  return Chip(
                    label: Text(entry.value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeTerm(entry.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('تاريخ انتهاء العرض'),
                subtitle: Text(_validUntil?.toString() ?? 'غير محدد'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _validUntil ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            _validUntil ?? DateTime.now()),
                      );
                      if (time != null) {
                        setState(() {
                          _validUntil = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'صور العرض:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('الصورة الأساسية'),
                        const SizedBox(height: 8),
                        if (_image1 != null)
                          Stack(
                            children: [
                              Image.network(
                                _image1!,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() => _image1 = null);
                                  },
                                ),
                              ),
                            ],
                          )
                        else
                          _isUploadingImage
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primary,
                                  ),
                                  onPressed: () async {
                                    setState(() => _isUploadingImage = true);
                                    try {
                                      final imageUrl = await ImagePickerService
                                          .pickImageSpecialOffer();
                                      if (imageUrl != null) {
                                        setState(() => _image1 = imageUrl);
                                      }
                                    } finally {
                                      setState(() => _isUploadingImage = false);
                                    }
                                  },
                                  child: const Text(
                                    'اختر الصورة',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Expanded(
                  //   child: Column(
                  //     children: [
                  //       const Text('الصورة الشمال'),
                  //       const SizedBox(height: 8),
                  //       if (_image2 != null)
                  //         Stack(
                  //           children: [
                  //             Image.network(
                  //               _image2!,
                  //               height: 100,
                  //               width: double.infinity,
                  //               fit: BoxFit.contain,
                  //             ),
                  //             Positioned(
                  //               right: 0,
                  //               child: IconButton(
                  //                 icon: const Icon(Icons.close),
                  //                 onPressed: () {
                  //                   setState(() => _image2 = null);
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //       else
                  //         ElevatedButton(
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: TColors.primary,
                  //           ),
                  //           onPressed: () async {
                  //             final imageUrl = await ImagePickerService
                  //                 .pickImageSpecialOffer();
                  //             if (imageUrl != null) {
                  //               setState(() => _image2 = imageUrl);
                  //             }
                  //           },
                  //           child: const Text(
                  //             'اختر الصورة',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('نشط'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'حفظ التغييرات',
                          style: TextStyle(fontSize: 16),
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
