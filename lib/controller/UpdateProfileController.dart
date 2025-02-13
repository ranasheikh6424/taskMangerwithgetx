import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Define reactive variables
  var pickedImage = Rx<XFile?>(null); // Initially set to null
  var email = Rx<String>('');
  var firstName = Rx<String>('');
  var lastName = Rx<String>('');
  var mobile = Rx<String>('');
  var password = Rx<String>('');
  var isLoading = false.obs;

  // Method to pick image
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = image; // Update picked image
    }
  }

  // Method to update profile (your existing logic)
  Future<void> updateProfile() async {
    // Your profile update logic here
  }
}
