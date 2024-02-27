import 'package:freezed_annotation/freezed_annotation.dart';
 
import '../../cart/models/graph_create_cart_model.dart';
import '../../products/model/qraph_product_model.dart';


part 'graph_create_order_model.freezed.dart';
part 'graph_create_order_model.g.dart';

@freezed
class CreateOrderModel with _$CreateOrderModel {
  const factory CreateOrderModel({
    CreateOrderFromCart? createOrderFromCart,
  }) = _CreateOrderModel;

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderModelFromJson(json);
}

@freezed
class GetOrderByIdModel with _$GetOrderByIdModel {
  const factory GetOrderByIdModel({
    CreateOrderFromCart? order,
  }) = _GetOrderByIdModel;

  factory GetOrderByIdModel.fromJson(Map<String, dynamic> json) =>
      _$GetOrderByIdModelFromJson(json);
}

@freezed
class CreateOrderFromCart with _$CreateOrderFromCart {
  const factory CreateOrderFromCart({
    String? id,
    String? number,
    MoneyType? total,
    MoneyType? subTotal,
    MoneyType? taxTotal,
    MoneyType? shippingTotal,
    MoneyType? discountTotal,
    MoneyType? discountAmount,
    String? customerId,
    String? customerName,
    String? createdDate,
    List<CartItem>? items,
    num? feeTotal,
    Currency? currency,
    String? status,
    String? createdBy,
    String? modifiedBy,
    String? modifiedDate,
  }) = _CreateOrderFromCart;

  factory CreateOrderFromCart.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderFromCartFromJson(json);
}
