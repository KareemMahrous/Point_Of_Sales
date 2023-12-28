part of 'inventory_bloc.dart';

@freezed
class InventoryEvent with _$InventoryEvent {
  const factory InventoryEvent.fetch() = _Fetch;
  const factory InventoryEvent.search(String? query) = _Search;
  const factory InventoryEvent.updateQuantity({required String productId,required int inStockQuantity,int? reservedQuantity}) =
      _UpdateQuantity;
  // const factory InventoryEvent.refresh() = _Refresh;
}