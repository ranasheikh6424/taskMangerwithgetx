import 'package:get/get.dart';

import '../api/apiClient.dart';

class TaskCreateController extends GetxController {
  var formValues = {"title": "", "description": "", "status": "New"}.obs;

  var loading = false.obs;

  void inputOnChange(String mapKey, String textValue) {
    formValues.update(mapKey, (value) => textValue);
  }

  Future<void> formOnSubmit() async {
    if (formValues['title']!.isEmpty) {
      Get.snackbar("Error", "Title Required!");
    } else if (formValues['description']!.isEmpty) {
      Get.snackbar("Error", "Description Required!");
    } else {
      loading.value = true;
      bool res = await TaskCreateRequest(formValues);
      if (res) {
        Get.offAllNamed('/'); // Navigate to home screen
      } else {
        loading.value = false;
      }
    }
  }
}
