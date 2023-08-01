import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/product_api.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';

class CartController extends GetxController {
  Rx<ProductDetailModel?> selectedProductDetails =
      Rx<ProductDetailModel?>(null);
  final imageUrlList = <String>[].obs;
  final productApi = Get.find<ProductApi>();
  Future choseProduct(ProductDetailModel? chosenProductDetails) async {
    if (chosenProductDetails != null) {
      if (chosenProductDetails.imageUrl != null) {
        imageUrlList.value =
            DataConvert().encodeListImages(chosenProductDetails.imageUrl!);
      }
    }
  }
}
