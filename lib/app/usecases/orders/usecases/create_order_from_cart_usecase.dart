import 'package:equatable/equatable.dart'; 

import '../../../../core/types/types.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../domain/orders/repo/orders_repo_base.dart';
import '../../../../infrastructure/orders/model/graph_create_order_model.dart';

class CreateOrderFormCartUsecase
    implements
        BaseUsecase<
            CreateOrderFormCartParams,
            FutureEitherFailureOrType<
                ({CreateOrderModel createOrderModel, bool isAnonymous})>> {
  final OrdersRepoBase _ordersRepo;

  CreateOrderFormCartUsecase({required OrdersRepoBase ordersRepo})
      : _ordersRepo = ordersRepo;
  @override
  FutureEitherFailureOrType<
          ({CreateOrderModel createOrderModel, bool isAnonymous})>
      call(CreateOrderFormCartParams params) async {
    return _ordersRepo.createOrderFromCart(cartId: params.cartId);
    // final record = ;
    // return record;
  }
}

class CreateOrderFormCartParams extends Equatable {
  final String cartId;

  const CreateOrderFormCartParams({required this.cartId});

  @override
  List<Object?> get props => [cartId];
}
