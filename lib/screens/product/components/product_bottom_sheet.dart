import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_mobile_app/configs/mediaquery.dart';
import 'package:keyboard_mobile_app/controller/product_detail_controller.dart';
import 'package:keyboard_mobile_app/model/product_model.dart';
import 'package:keyboard_mobile_app/screens/product/components/color_selected.dart';
import 'package:keyboard_mobile_app/screens/product/components/quantity_selector.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_button.dart';
import 'package:keyboard_mobile_app/widgets/custom_widgets/custom_swiper_panation.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final ProductModel product;
  final detailController = Get.find<ProductDetailController>();
  // final accountController = Get.find<AccountApi>();

  ProductDetailsBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.91,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.aspectRatio * 20),
                  child: Center(
                    child: Text(
                      "${product.productName}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollEdgeListener(
              edge: ScrollEdge.start,
              edgeOffset: 0,
              continuous: false,
              dispatch: true,
              listener: () {
                //Đóng bottom sheet khi người dùng kéo hết cạnh trên của nó
                //Hoạt động không như mong đợi vì 1 số lỗi
                // Navigator.pop(context);
              },
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Obx(() {
                        if (detailController.imageUrlList.value == null) {
                          return Container(
                            height: mediaHeight(context, 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: const [
                                  BoxShadow(blurRadius: 3, spreadRadius: 1)
                                ]),
                            child: Hero(
                              tag: "${product.displayUrl}",
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: "${product.displayUrl}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          final listImageUrl =
                              detailController.imageUrlList.value;
                          return SizedBox(
                            width: double.infinity,
                            height: mediaHeight(context, 5),
                            child: Swiper(
                              itemCount: listImageUrl!.length,
                              physics: listImageUrl.length > 1
                                  ? const ClampingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = listImageUrl[index];
                                return SizedBox(
                                  height: mediaHeight(context, 4),
                                  child: Hero(
                                    tag: item,
                                    child: CachedNetworkImage(
                                      imageUrl: item,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                              pagination: SwiperCustomPagination(
                                builder: (context, config) {
                                  return CustomSwiperPagination(
                                      itemCount: listImageUrl.length,
                                      activeIndex: config.activeIndex);
                                },
                              ),
                            ),
                          );
                        }
                      }),
                      Divider(
                        color: Colors.black.withOpacity(0.2),
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Chọn màu',
                                  style: GoogleFonts.nunito(fontSize: 16),
                                ),
                              ],
                            ),
                            ColorChoiceWidget(
                              onSizeSelected: (value) {
                                detailController.choseProduct(value);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.2),
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              'Chọn số lượng',
                              style: GoogleFonts.nunito(fontSize: 16),
                            ),
                            const Spacer(),
                            Obx(
                              () => Visibility(
                                visible: detailController.chosenDetails.value !=
                                    null,
                                child: Transform.scale(
                                  scale: size.aspectRatio / 0.6,
                                  child: QuantitySelector(
                                    initialValue: 1,
                                    maxQuantity: detailController
                                            .chosenDetails.value?.quantity ??
                                        1,
                                    onValueChanged: (quantity) {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mediaHeight(context, 40),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.2),
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: DefaultButton(
                            press: () {}, text: 'Thêm vào giỏ hàng'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
