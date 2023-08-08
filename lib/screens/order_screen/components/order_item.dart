import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_mobile_app/model/cart_model.dart';

import '../../../controller/cart_controller.dart';

class PayCartItem extends StatelessWidget {
  final CartModel cartProduct;
  final cartController = Get.find<CartController>();
  PayCartItem({
    Key? key,
    required this.cartProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          cartController.getProductByDetail("${cartProduct.productDetailId}"),
      builder: (context, detail) {
        if (detail.hasData) {
          final productDetail = detail.data!;
          return FutureBuilder(
            future: cartController.getProductById("${productDetail.productId}"),
            builder: (context, productSnapshot) {
              if (productSnapshot.hasData) {
                final product = productSnapshot.data!;
                return Row(children: [
                  SizedBox(
                    width: 88 * (MediaQuery.of(context).size.width) / 375,
                    child: AspectRatio(
                      aspectRatio: 0.88,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              '${product.displayUrl}', //widget.cartProduct.!.urlImageThumb!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator.adaptive(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20 * (MediaQuery.of(context).size.width) / 375,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                              text: '${product.productName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kDefaultIconDarkColor,
                              )),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          NumberFormat.simpleCurrency(
                                  locale: 'vi-VN', decimalDigits: 0)
                              .format(productDetail.price ??
                                  0 * (cartProduct.quantity ?? 0)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(TextSpan(
                          text: "SL: ${cartProduct.quantity}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.black),
                        ))
                      ],
                    ),
                  )
                ]);
              }
              return const Text('NotFound');
            },
          );
        }
        return const Text('NotFound');
      },
    );
  }
}
