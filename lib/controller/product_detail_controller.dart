import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/product_api.dart';
import 'package:keyboard_mobile_app/model/product_details_model.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';

class ProductDetailController extends GetxController {
  Rx<ProductDetailModel?> chosenDetails = Rx<ProductDetailModel?>(null);
  Rx<List<String>?> imageUrlList = Rx<List<String>?>(null);
  @override
  void onClose() {
    super.onClose();
    imageUrlList.value = chosenDetails.value = null;
  }

  final productApi = Get.find<ProductApi>();
  Future choseProduct(ProductDetailModel? chosenProductDetails) async {
    if (chosenProductDetails != null) {
      chosenDetails.value = chosenProductDetails;
      if (chosenProductDetails.imageUrl != null) {
        imageUrlList.value =
            DataConvert().encodeListImages(chosenProductDetails.imageUrl!);
      }
    }
  }
}
