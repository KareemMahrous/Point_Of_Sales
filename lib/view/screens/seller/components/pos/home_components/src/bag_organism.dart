import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tot_atomic_design/tot_atomic_design.dart';

import '../../../../../../../core/theme/palette.dart';
import '../../../../../../../domain/bag/entities/bag_item.dart';

class BagOrganism<T> extends HookWidget {
  const BagOrganism({
    super.key,
    required this.items,
    required this.price,
    required this.onSlide,
    required this.onCheckout,
    required this.onClearList,
    required this.discounts,
    required this.discountVariations,
    required this.selectedDiscounts,
    // this.isEmpty = false,
  });

  final List<BagItem> items;
  final double price;
  final void Function(BagItem) onSlide;
  final VoidCallback onCheckout;
  final VoidCallback onClearList;
  final List<String> discounts;
  final List<T> discountVariations;
  final List<bool> selectedDiscounts;
  // final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          if (kDebugMode) {
            print('TextField lost focus. Value: ${controller.text} ');
          }
        }
        // print('TextField lost focus. Value: ${controller.text} ');
      });
      return null;
      // return null;
    }, [controller.text]);

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.all(8.0),
        height: h * 0.7,
        width: 370.w,
        child: items.isEmpty
            ? Center(
                child: Text(
                  "The bag is empty",
                  style: context.titleMedium.copyWith(color: Palette.grey),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Slidable(
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.2,
                              children: [
                                SlidableAction(
                                  autoClose: true,
                                  flex: 1,
                                  onPressed: (context) {
                                    onSlide(item);
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ]),
                          child: ListTile(
                            leadingAndTrailingTextStyle: context.bodyMedium,
                            contentPadding: EdgeInsets.zero,
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name!),
                                Text(
                                    'Available Quantity: ${(item.product.availabilityData!.inventories?.first.inStockQuantity ?? 0)}')
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Count: ${item.count}'),
                                Text(
                                    'Unit Price: ${(item.product.price?.actual?.amount ?? 0)}')
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Wrap(
                    runSpacing: 6,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: TotVariationCardMolecule<T>(
                                variations: discountVariations,
                                shrinkWrap: true,
                                isMasterList: selectedDiscounts,
                                height: 40.h,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                falseColor: Palette.white,
                                successColor: Palette.primary,
                                itemBorderColor: Colors.white,
                                itemOnTap: (value) {},
                                textList: discounts,
                              ),
                            ),
                            if (selectedDiscounts[0])
                              Column(
                                children: [
                                  //? divider
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Row(
                                      // mainAxisAlignment:
                                      // MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Palette.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text("Or"),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            // height: 10,
                                            thickness: 1,
                                            color: Palette.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //? Add custom discount
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Row(
                                      // mainAxisAlignment:
                                      // MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Add custom discount: ",
                                            style: context.titleMedium,
                                          ),
                                        ),
                                        SizedBox(
                                          width: w * 0.04,
                                          height: h * 0.04,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder()),
                                            style: context.titleMedium,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            focusNode: focusNode,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              decimal: false,
                                            ),
                                            controller: controller,
                                          ),
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TotButtonAtom(
                              backgroundColor: Palette.primary,
                              text: "Checkout",
                              onPressed: onCheckout,
                              textStyle: context.titleMedium
                                  .copyWith(color: Palette.white),
                            ),
                          ),
                          const Spacer(),
                          // const SizedBox(width: 16),
                          Text(
                            'Total Price: $price',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TotButtonAtom(
                        backgroundColor: Palette.orange,
                        text: "Clear list",
                        onPressed: onClearList,
                        textStyle:
                            context.titleMedium.copyWith(color: Palette.black),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
