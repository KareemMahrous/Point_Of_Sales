import 'package:equatable/equatable.dart'; 

import '../../../../core/types/types.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../domain/orders/repo/orders_repo_base.dart';
import '../../../../infrastructure/orders/model/graph_create_order_model.dart';

class GetOrderDetailsUseCase
    implements
        BaseUsecase<GetOrderDetailsParams,
            FutureEitherFailureOrType<GetOrderByIdModel>> {
  final OrdersRepoBase _ordersRepo;

  GetOrderDetailsUseCase({required OrdersRepoBase ordersRepo})
      : _ordersRepo = ordersRepo;
  @override
  FutureEitherFailureOrType<GetOrderByIdModel> call(
      GetOrderDetailsParams params) {
    return _ordersRepo.getOrderbyId(orderId: params.orderId);
  }
}

class GetOrderDetailsParams extends Equatable {
  final String orderId;

  const GetOrderDetailsParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
