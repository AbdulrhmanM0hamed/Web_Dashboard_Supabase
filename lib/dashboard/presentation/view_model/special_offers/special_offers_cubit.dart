import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_dashboard/dashboard/data/models/special_offer_model.dart';

part 'special_offers_state.dart';

class SpecialOffersCubit extends Cubit<SpecialOffersState> {
  final _client = Supabase.instance.client;

  SpecialOffersCubit() : super(const SpecialOffersState());

  Future<void> loadSpecialOffers() async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _client
          .from('special_offers')
          .select()
          .order('created_at', ascending: false);
      
      final offers = (response as List)
          .map((offer) => SpecialOfferModel.fromJson(offer))
          .toList();
          
      emit(state.copyWith(
        isLoading: false,
        offers: offers,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> addSpecialOffer(SpecialOfferModel offer) async {
    try {
      await _client.from('special_offers').insert(offer.toJson());
      await loadSpecialOffers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      print(e);
      rethrow;
    }
  }

  Future<void> updateSpecialOffer(SpecialOfferModel offer) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _client.from('special_offers').update({
        'title': offer.title,
        'subtitle': offer.subtitle,
        'image1': offer.image1,
        'image2': offer.image2,
        'is_active': offer.isActive,
      }).eq('id', offer.id!);

      await loadSpecialOffers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateSpecialOfferOld(String id, SpecialOfferModel offer) async {
    try {
      await _client
          .from('special_offers')
          .update(offer.toJson())
          .eq('id', id);
      await loadSpecialOffers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteSpecialOffer(String id) async {
    try {
      // جلب بيانات العرض قبل الحذف للحصول على روابط الصور
      final response = await _client
          .from('special_offers')
          .select()
          .eq('id', id)
          .single();
      
      final offer = SpecialOfferModel.fromJson(response);
      
      // حذف الصور من storage إذا وجدت
      if (offer.image1 != null) {
        final image1Path = Uri.parse(offer.image1!).pathSegments.last;
        await _client.storage.from('specialOfferBucket-images').remove([image1Path]);
      }
      if (offer.image2 != null) {
        final image2Path = Uri.parse(offer.image2!).pathSegments.last;
        await _client.storage.from('specialOfferBucket-images').remove([image2Path]);
      }
    

      // حذف العرض من قاعدة البيانات
      await _client.from('special_offers').delete().eq('id', id);
      await loadSpecialOffers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> toggleSpecialOfferStatus(String id, bool isActive) async {
    try {
      await _client
          .from('special_offers')
          .update({'is_active': isActive})
          .eq('id', id);
      await loadSpecialOffers();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }
}
