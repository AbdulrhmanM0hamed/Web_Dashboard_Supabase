import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/constants/colors.dart';
import 'package:supabase_dashboard/core/services/image_picker_service.dart';
import 'package:supabase_dashboard/dashboard/data/models/special_offer_model.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/special_offers/special_offers_cubit.dart';

class AddSpecialOfferView extends StatefulWidget {
  const AddSpecialOfferView({super.key});

  @override
  State<AddSpecialOfferView> createState() => _AddSpecialOfferViewState();
}

class _AddSpecialOfferViewState extends State<AddSpecialOfferView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String? _image1;
  String? _image2;
  String? _image3;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final offer = SpecialOfferModel(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          image1: _image1,
          image2: _image2,
          isActive: _isActive,
        );

        await context.read<SpecialOffersCubit>().addSpecialOffer(offer);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar( backgroundColor: TColors.success ,content: Text('تم إضافة العرض بنجاح')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar( backgroundColor: TColors.error ,content: Text('حدث خطأ: $e')),
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
        title: const Text('إضافة عرض خاص'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان العرض',
                border: OutlineInputBorder(),
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
              decoration: const InputDecoration(
                labelText: 'العنوان الفرعي للعرض',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'برجاء إدخال العنوان الفرعي للعرض';
                }
                return null;
              },
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
                        ElevatedButton(
                          onPressed: () async {
                            final imageUrl = await ImagePickerService
                                .pickImageSpecialOffer();
                            if (imageUrl != null) {
                              setState(() => _image1 = imageUrl);
                            }
                          },
                          child: const Text('اختر الصورة'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      const Text('الصورة الشمال'),
                      const SizedBox(height: 8),
                      if (_image3 != null)
                        Stack(
                          children: [
                            Image.network(
                              _image3!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() => _image3 = null);
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            final imageUrl = await ImagePickerService
                                .pickImageSpecialOffer();
                            if (imageUrl != null) {
                              setState(() => _image3 = imageUrl);
                            }
                          },
                          child: const Text('اختر الصورة'),
                        ),
                    ],
                  ),
                ),
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
                  backgroundColor: TColors.primary,
                ),
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('إضافة العرض' , style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
