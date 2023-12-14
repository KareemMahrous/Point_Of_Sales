import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/response/bag/bag_model.dart';
import '../../../../data/models/response/tot_products/create_order/tot_create_order.dart';
import '../../../../data/repository/base/order_repo_base.dart';

part 'bag_cubit.freezed.dart';
part 'bag_state.dart';

class BagCubit extends Cubit<BagState> {
  BagCubit(this.repo) : super(_Initial());

  final OrderRepoBase repo;

  Map<String, String> selectedCustomer = {};

  updateCustomer(Map<String, String> selected) {
    selectedCustomer = selected;
  }

  fetch() {
    final List<BagModel> result = [];
    if (result.isEmpty) {
      emit(_EmptyState());
    } else {
      emit(_UpdateListState(bag: result, totalPrice: 0.0));
    }
  }

  checkout({
    required String storeId,
    required String storeName,
    int? total,
    required bool isApproved,
    required String status,
    required String currency,
    int? sum,
    // required Map<String, String> selectedCustomer,
    required List<OrderItem> items,
  }) {
    state.maybeMap(
      orElse: () {},
      updateList: (value) async {
        final data = await repo.fetchResponse(
          items: items,
          currency: currency,
          customerId: selectedCustomer.keys.first,
          customerName: selectedCustomer.values.first,
          isApproved: isApproved,
          status: status,
          storeId: storeId,
          storeName: storeName,
        );

        data.fold(
          (l) => emit(_UpdateListState(bag: value.bag, message: l.message)),
          (r) => emit(
            (_EmptyState(message: "Order created succesfully")),
          ),
        );
      },
    );
  }

  updatedList(BagModel product) async {
    state.maybeMap(
        orElse: () {},
        initial: (value) {},
        empty: (value) {
          emit(_UpdateListState(bag: [product], totalPrice: 0.0));
          // calculateTotalPrice();
        },
        updateList: (value) {
          var list = value.bag;

          list.add(product);

          emit(value.copyWith(bag: list));
          // calculateTotalPrice();
        });
  }

  void clearItem(int index) {
    state.maybeMap(
      orElse: () {},
      initial: (value) {},
      empty: (value) {},
      updateList: (value) {
        value.bag.removeAt(index);
        if (value.bag.isEmpty) {
          emit(_EmptyState());
        } else {
          emit(value.copyWith(bag: value.bag));
          // calculateTotalPrice();
        }
      },
    );
  }

  void clearList() {
    state.maybeMap(
      orElse: () {},
      updateList: (value) {
        emit(_EmptyState());
      },
    );
  }
}
