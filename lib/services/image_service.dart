import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_car_app/services/secure_storage.dart';
import 'package:smart_car_app/services/shared_prefs.dart';
import 'package:smart_car_app/utils/functions.dart';

import '../constants/variables.dart';
import 'dio/dio_client.dart';

class ImageService {
  static pickImage({required ImageSource imageSource}) async {
    try {
      var image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      await MySharedPrefs().saveVehicleImage(
          key: MySharedPrefs.vehicleImageKey, path: image.path);
      var imageTemporary = File(image.path);
      log("Image file: ${imageTemporary.path}");
      await _uploadImage().then((response) async {
        log("Upload response; $response");
        var imageUrl = response.data['responseDto']['image']['url'];
        await MySharedPrefs().saveVehicleImage(
            key: MySharedPrefs.vehicleImageUrlKey, path: "$imageUrl");
        MyValueNotifiers.uploadImageLoading.value = "uploadImageLoaded";
      });
      // todo image ni pick qimasdan orqaga qaytganda rasm ko'rinmay qolyapti. => tugirlash kk
      popBack();
      return imageTemporary;
    } catch (error) {
      log("Pick image error:  $error");
      MyValueNotifiers.uploadImageLoading.value = "uploadImageError";
    }
  }

  static Future<Response<dynamic>> _uploadImage() async {
    MyValueNotifiers.uploadImageLoading.value = "uploadImageLoading";
    var token = await SecureStorage.read(key: SecureStorage.token);
    File? file;
    await MySharedPrefs()
        .getVehicleImage(key: MySharedPrefs.vehicleImageKey)
        .then((value) => file = File(value));
    var fileName = file?.path.split("/").last;
    FormData formData = FormData.fromMap({
      "multipartFile": await MultipartFile.fromFile(
        file?.path ?? '',
        filename: fileName,
        contentType: MediaType("image", "png"),
      ),
      "type": "image/png",
    });
    return await DioClient.instance.post(
      AppUrl.uploadImage(),
      data: formData,
      options: Options(headers: {
        "accept": "*/*",
        'Authorization': 'Bearer $token',
        "Content-type": "multipart/form-data"
      }),
    );
  }
}
