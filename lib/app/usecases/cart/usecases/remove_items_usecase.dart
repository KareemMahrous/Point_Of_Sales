import 'package:equatable/equatable.dart';

import '../../../../core/types/types.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../domain/cart/repo/cart_repo.dart';
import '../../../../infrastructure/cart/models/graph_remove_item_model.dart';
 
class RemoveCartItemsUsecase
    implements
        BaseUsecase<RemoveCartItemsParams,
            FutureEitherFailureOrType<RemoveCartItemsModel>> {
  final CartRepo _cartRepo;

  RemoveCartItemsUsecase({required CartRepo cartRepo}) : _cartRepo = cartRepo;

  @override
  FutureEitherFailureOrType<RemoveCartItemsModel> call(
      RemoveCartItemsParams params) {
    return _cartRepo.removeCartItems(lineItemIds: params.lineItemId);
  }
}

class RemoveCartItemsParams extends Equatable {
  final List<String> lineItemId;

  const RemoveCartItemsParams({required this.lineItemId});

  @override
  List<Object?> get props => [lineItemId];
}