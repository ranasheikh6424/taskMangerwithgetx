import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Reactive form values
  var formValues = <String, String>{}.obs;

  // Set the form values
  void setFormValues(Map<String, String> values) {
    formValues.assignAll(values);
  }
}
