import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tot_atomic_design/tot_atomic_design.dart';
import 'package:tot_pos/core/theme/pallete.dart';
import 'package:tot_pos/data/models/response/bag/bag_model.dart';
import 'package:tot_pos/view/blocs/home/home_bloc.dart';
import 'package:tot_pos/view/blocs/products/products_cubit.dart';
import 'package:tot_pos/view/screens/seller/components/pos/home_components/home_exp.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const TOTPOSHomePageAppBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: w * 0.6,
              height: h * 0.8,
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    fetchingCustomersFailed: (message) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            message.trim.toString(),
                          ),
                        ),
                      ),
                    ),
                    failedLoadingData: (message) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            message.toString(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                builder: (context, state) {
                  return state.maybeMap(
                      orElse: () {
                        return Container(
                          color: Colors.orange,
                          width: 100,
                          height: 100,
                        );
                      },
                      failedLoadingData: (value) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      initial: (value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      loadedData: (value) {
                        if (value.products.isEmpty &&
                            value.isSearching == false) {
                          return Center(
                            child: Text(
                              "No items found!",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          );
                        }
                        if (value.isSearching == true) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, childAspectRatio: 0.7),
                          itemCount: value.products.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TOTPOSFoodCardItemMolecule(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        icon: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.close))),
                                        content: SizedBox(
                                          width: w * 0.6,
                                          height: h * 0.6,
                                          child: POSFoodItemAlertDialog(
                                            data: value.products[index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                mealImage: value.products[index].imgSrc == null
                                    ? "https://foodyman.s3.amazonaws.com/public/images/products/334-1676377275.jpeg"
                                    : value.products[index].imgSrc.toString(),
                                mealName:
                                    value.products[index].name.toString() ==
                                            "null"
                                        ? "Not found"
                                        : value.products[index].name.toString(),
                                mealDescription:
                                    value.products[index].minQuantity == null ||
                                            value.products[index].minQuantity ==
                                                0
                                        ? "Out of stock"
                                        : "In stock",
                                price: value.products[index].minQuantity != null
                                    ? "120"
                                    : "0"),
                          ),
                        );
                      });
                },
              ),
            ),
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                return state.map(
                  empty: (value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w * 0.31,
                        color: AppColors.white,
                        height: h * 0.5,
                        child: const Center(
                          child: TOTTextAtom.headLineMedium("The bag is empty",
                              color: AppColors.grey),
                        ),
                      ),
                    );
                  },
                  initial: (value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w * 0.31,
                        color: AppColors.white,
                        height: h * 0.5,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                  updateList: (value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w * 0.31,
                        color: AppColors.white,
                        height: h * 0.5,
                        child: Column(
                          children: [
                            SizedBox(
                              height: h * 0.4,
                              child: ListView.builder(
                                itemCount: value.bag.length,
                                itemBuilder: (context, index) {
                                  BagModel item = value.bag[index];
                                  return Slidable(
                                    startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        extentRatio: 0.2,
                                        children: [
                                          SlidableAction(
                                            autoClose: true,
                                            flex: 1,
                                            onPressed: (context) {
                                              context
                                                  .read<ProductsCubit>()
                                                  .clearItem(index);
                                            },
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ]),
                                    child: ListTile(
                                      title: Text(item.itemName),
                                      subtitle:
                                          Text('Price: \$${item.itemPrice}'),
                                      trailing: Text(
                                          'Quantity: ${item.itemQuantity}'),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Price: ${value.totalPrice.toString()}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TOTButtonAtom.filledButton(
                                      backgroundColor: AppColors.orange,
                                      text: "Clear list",
                                      onPressed: () {
                                        context
                                            .read<ProductsCubit>()
                                            .clearList();
                                      },
                                      textColor: AppColors.black)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
