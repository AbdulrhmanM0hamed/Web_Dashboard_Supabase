part of 'special_offers_cubit.dart';

class SpecialOffersState extends Equatable {
  final bool isLoading;
  final List<SpecialOfferModel> offers;
  final String? error;

  const SpecialOffersState({
    this.isLoading = false,
    this.offers = const [],
    this.error,
  });

  SpecialOffersState copyWith({
    bool? isLoading,
    List<SpecialOfferModel>? offers,
    String? error,
  }) {
    return SpecialOffersState(
      isLoading: isLoading ?? this.isLoading,
      offers: offers ?? this.offers,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, offers, error];
}
