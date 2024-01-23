import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tot_atomic_design/tot_atomic_design.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/store_config.dart';
import '../../../data/products/model/qraph_product_model.dart';

class TotPOSProductDetailsDialogOrganism extends HookWidget {
  const TotPOSProductDetailsDialogOrganism({
    super.key,
    required this.onAddToCart,
    required this.product,
    required this.variations,
    required this.masterVariation,
    required this.onVariationTapped,
    this.padding,
    this.imgHeight,
    this.imgWidth,
    this.imgBorderRadius,
    this.buttonBorderRadius,
    this.buttonBackgroundColor,
    this.quantityControlsColor,
    this.addToCartTitle = "Add to cart",
    this.addTocartTextStyle,
    this.crossAxisSpacing,
    this.productNameTextStyle,
    this.productDescriptionTextStyle,
    this.priceTextStyle,
    this.priceTitle = "Price",
    this.dividerColor,
    this.variationHeight,
    this.sizeTitle = "Size",
    this.activeVartiationColor,
    this.inActiveVartiationColor,
    this.productFallbackImg,
  });

  final void Function(Item product, int count)? onAddToCart;
  final Item product;
  final List<Variation> variations;
  final Variation masterVariation;
  final void Function(Variation variation) onVariationTapped;

  final EdgeInsets? padding;
  final double? imgHeight;
  final double? imgWidth;
  final double? imgBorderRadius;
  final double? buttonBorderRadius;
  final Color? buttonBackgroundColor;
  final Color? quantityControlsColor;
  final String addToCartTitle;
  final TextStyle? addTocartTextStyle;
  final double? crossAxisSpacing;
  final TextStyle? productNameTextStyle;
  final TextStyle? productDescriptionTextStyle;
  final String priceTitle;
  final TextStyle? priceTextStyle;
  final Color? dividerColor;
  final double? variationHeight;
  final String sizeTitle;
  final Color? activeVartiationColor;
  final Color? inActiveVartiationColor;
  final String? productFallbackImg;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    final counter = useState(1);

    return Padding(
      padding: padding ?? const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? img
                ClipRRect(
                  borderRadius: BorderRadius.circular(imgBorderRadius ?? 8),
                  child: CachedNetworkImage(
                    height: imgHeight ?? w * 0.135,
                    width: imgWidth ?? w * 0.18,
                    fit: BoxFit.fill,
                    imageUrl: product.imgSrc ?? "",
                    errorWidget: (context, error, stackTrace) {
                      return (productFallbackImg != null)
                          ? Image.asset(
                              ImgsManager.totLogo,
                            )
                          : Container(
                              color: Colors.grey.shade400,
                            );
                    },
                  ),
                ),
                //? counter
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: TOTPOSItemCounterMolecule(
                    borderColor: buttonBackgroundColor,
                    addIconColor: quantityControlsColor ?? Colors.white,
                    removeIconColor: quantityControlsColor ?? Colors.white,
                    increment: () {
                      if (counter.value >=
                          (product.masterVariation?.availabilityData
                                  ?.inventories
                                  ?.firstWhere(
                                      orElse: () =>
                                          const Inventory(inStockQuantity: 0),
                                      (inventory) =>
                                          inventory.fulfillmentCenterId ==
                                          StoreConfig.octoberBranchId)
                                  .inStockQuantity ??
                              0)) {
                        return;
                      }
                      counter.value++;
                    },
                    decrement: () {
                      if (counter.value <= 1) return;

                      counter.value--;
                    },
                    value: counter.value.toString(),
                  ),
                ),
                TotButtonAtom(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(buttonBorderRadius ?? 16)),
                  text: addToCartTitle,
                  onPressed: onAddToCart == null
                      ? null
                      : () async {
                          onAddToCart?.call(product, counter.value);

                          context.pop();
                        },
                  textStyle: addTocartTextStyle ??
                      context.titleMedium.copyWith(color: Colors.white),
                  backgroundColor: buttonBackgroundColor,
                )
              ],
            ),
          ),
          SizedBox(width: crossAxisSpacing ?? 30),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  masterVariation.name.toString(),
                  style: productNameTextStyle ??
                      context.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                Text(
                    product.descriptions
                            ?.where(
                                (element) => element.languageCode == "ar-EG")
                            .first
                            .content ??
                        "",
                    style: productDescriptionTextStyle ??
                        context.titleMedium.copyWith(
                          color: Colors.grey,
                        )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$priceTitle:\n ${masterVariation.price?.actual?.formattedAmount ?? "0"}",
                      style: priceTextStyle ??
                          context.titleMedium.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: dividerColor ?? Colors.grey,
                ),
                TotVariationCardMolecule<Variation>(
                  height: variationHeight ?? w * 0.028,
                  variations: variations,
                  textList: variations
                      .map(
                        (e) => e.properties!
                            .firstWhere((element) => element.name == "size")
                            .value
                            .toString(),
                      )
                      .toList(),
                  itemOnTap: onVariationTapped,
                  reverse: false,
                  title: sizeTitle,
                  titleTextStyle: context.titleMedium,
                  falseColor: inActiveVartiationColor ?? Colors.white,
                  successColor: activeVartiationColor ?? Colors.green,
                  isMasterList: variations.map((e) => e.isMaster).toList(),
                  itemBorderColor: Colors.transparent,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
