import 'dart:developer'; // استيراد مكتبة log
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:supabase_dashboard/core/services/supabase_service.dart';
import 'package:supabase_dashboard/dashboard/data/models/category_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final SupabaseService _supabaseService = SupabaseService();

  CategoriesCubit() : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      final categoriesData = await _supabaseService.getCategories();
      

      final categories =
          categoriesData.map((data) => CategoryModel.fromJson(data)).toList();
    
      emit(CategoriesLoaded(categories));
    } catch (e, stackTrace) {
      log('Error in loadCategories', name: 'CategoriesCubit', error: e, stackTrace: stackTrace);
      emit(CategoriesError('حدث خطأ أثناء تحميل الفئات: $e'));
    }
  }

  Future<void> createCategory(CategoryModel category) async {
    try {
      log('Starting category creation...', name: 'CategoriesCubit');
      emit(CategoriesLoading());
      
      log('Converting category to JSON...', name: 'CategoriesCubit');
      final categoryJson = category.toJson();
      log('Category JSON: $categoryJson', name: 'CategoriesCubit');
      
      log('Calling Supabase service...', name: 'CategoriesCubit');
      await _supabaseService.createCategory(categoryJson);
      log('Category created in Supabase', name: 'CategoriesCubit');
      
      log('Loading updated categories...', name: 'CategoriesCubit');
      await loadCategories();
      
      log('Emitting success state...', name: 'CategoriesCubit');
      if (state is CategoriesLoaded) {
        emit(CategoriesLoaded((state as CategoriesLoaded).categories));
      } else {
        emit(CategoriesLoaded([]));
      }
      log('Creation completed successfully', name: 'CategoriesCubit');
    } catch (e, stackTrace) {
      log('Error occurred in createCategory', name: 'CategoriesCubit', error: e, stackTrace: stackTrace);
      emit(CategoriesError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateCategory(String? id, CategoryModel category) async {
    if (id == null || id.isEmpty) {
      emit(CategoriesError('معرف الفئة غير صالح'));
      return;
    }

    emit(CategoriesLoading());
    try {
      log('Updating category: $id with data: $category', name: 'CategoriesCubit');
      final success =
          await _supabaseService.updateCategory(id, category.toJson());
      log('Category update result: $success', name: 'CategoriesCubit');

      if (success) {
        await loadCategories();
      } else {
        emit(CategoriesError('فشل في تحديث الفئة'));
      }
    } catch (e, stackTrace) {
      log('Error in updateCategory', name: 'CategoriesCubit', error: e, stackTrace: stackTrace);
      emit(CategoriesError('حدث خطأ أثناء تحديث الفئة: $e'));
    }
  }

  Future<void> deleteCategory(String? id) async {
    if (id == null || id.isEmpty) {
      emit(CategoriesError('معرف الفئة غير صالح'));
      return;
    }

    emit(CategoriesLoading());
    try {
      log('Deleting category: $id', name: 'CategoriesCubit');
      final success = await _supabaseService.deleteCategory(id);
      log('Category deletion result: $success', name: 'CategoriesCubit');

      if (success) {
        await loadCategories();
      } else {
        emit(CategoriesError('فشل في حذف الفئة'));
      }
    } catch (e, stackTrace) {
      log('Error in deleteCategory', name: 'CategoriesCubit', error: e, stackTrace: stackTrace);
      emit(CategoriesError('حدث خطأ أثناء حذف الفئة: $e'));
    }
  }
}
