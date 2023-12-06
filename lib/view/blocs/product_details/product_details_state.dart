part of 'product_details_bloc.dart';

@freezed
class ProductDetailsState with _$ProductDetailsState {
  const factory ProductDetailsState.initial() = _Initial;
  const factory ProductDetailsState.loadingState() = _LoadingState;
  const factory ProductDetailsState.fetchFailState(String message) =
      _FetchFailState;
  const factory ProductDetailsState.fetchProductByIdState(
    Item product, 
    {
    Variation? masterVariation,
    List<Variation>? variations,
    List<Property?>? ingredients,
    Property? enoughFor,
    Property? numberOfPieces,
    List<Property?>? size,
  }
  ) = _fetchProductByIdState;
}