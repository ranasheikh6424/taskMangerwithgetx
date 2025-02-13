import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanager/Style/Style.dart';
import 'package:taskmanager/modals/taskCountMOdal.dart';
import '../utility/utility.dart';

class ApiController extends GetxController {
  static const String baseURL = "https://task.teamrabbil.com/api/v1";
  var requestHeader = {"Content-Type": "application/json"};

  RxBool isLoading = false.obs;

  Future<bool> loginRequest(Map<String, dynamic> formValues) async {
    isLoading.value = true;
    var url = Uri.parse("$baseURL/login");
    var postBody = json.encode(formValues);

    try {
      var response =
          await http.post(url, headers: requestHeader, body: postBody);
      var result = json.decode(response.body);
      if (response.statusCode == 200 && result['status'] == "success") {
        SuccessToast("Login Successful");
        await WriteUserData(result);
        return true;
      } else {
        ErrorToast("Login Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setPasswordRequest(Map<String, dynamic> formValues) async {
    isLoading.value = true; // Show loading indicator
    var url = Uri.parse("$baseURL/RecoverResetPass");
    var postBody = json.encode(formValues);

    try {
      var response =
          await http.post(url, headers: requestHeader, body: postBody);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        SuccessToast("Password Reset Successful");
        return true;
      } else {
        ErrorToast("Password Reset Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  Future<bool> registrationRequest(Map<String, dynamic> formValues) async {
    var url = Uri.parse("$baseURL/registration");
    var postBody = json.encode(formValues);

    try {
      var response =
          await http.post(url, headers: requestHeader, body: postBody);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        SuccessToast("Registration Successful");
        return true;
      } else {
        ErrorToast("Registration Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return false;
    }
  }

  Future<bool> verifyEmailRequest(String email) async {
    var url = Uri.parse("$baseURL/RecoverVerifyEmail/$email");

    try {
      var response = await http.get(url, headers: requestHeader);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        await WriteEmailVerification(email);
        SuccessToast("Email Verified");
        return true;
      } else {
        ErrorToast("Email Verification Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return false;
    }
  }

  Future<bool> verifyOtpRequest(String email, String otp) async {
    var url = Uri.parse("$baseURL/RecoverVerifyOTP/$email/$otp");

    try {
      var response = await http.get(url, headers: requestHeader);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        await WriteOTPVerification(otp);
        SuccessToast("OTP Verified");
        return true;
      } else {
        ErrorToast("OTP Verification Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return false;
    }
  }

  Future<List<TaskCountModal>> taskStatusCountListRequest() async {
    var url = Uri.parse("$baseURL/taskStatusCount");
    String? token = await ReadUserData("token");

    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": '$token'
    };

    try {
      var response = await http.get(url, headers: requestHeaderWithToken);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        List<TaskCountModal> data = (result['data'] as List)
            .map((item) => TaskCountModal.fromJson(item))
            .toList();

        return data;
      } else {
        ErrorToast("Failed to fetch task counts");
        return [];
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return [];
    }
  }

  Future<bool> taskCreateRequest(Map<String, dynamic> formValues) async {
    var url = Uri.parse("$baseURL/createTask");
    String? token = await ReadUserData("token");

    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": '$token'
    };

    var postBody = json.encode(formValues);

    try {
      var response =
          await http.post(url, headers: requestHeaderWithToken, body: postBody);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        SuccessToast("Task Created");
        return true;
      } else {
        ErrorToast("Task Creation Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return false;
    }
  }

  Future<bool> taskDeleteRequest(int id) async {
    var url = Uri.parse("$baseURL/deleteTask/$id");
    String? token = await ReadUserData("token");

    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": '$token'
    };

    try {
      var response = await http.get(url, headers: requestHeaderWithToken);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        SuccessToast("Task Deleted");
        return true;
      } else {
        ErrorToast("Task Deletion Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return false;
    }
  }

  Future<bool> taskUpdateRequest(int id, String status) async {
    var url = Uri.parse("$baseURL/updateTaskStatus/$id/$status");
    String? token = await ReadUserData("token");

    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": '$token'
    };

    try {
      var response = await http.get(url, headers: requestHeaderWithToken);
      var result = json.decode(response.body);

      if (response.statusCode == 200 && result['status'] == "success") {
        SuccessToast("Task Updated");
        return true;
      } else {
        ErrorToast("Task Update Failed");
        return false;
      }
    } catch (e) {
      ErrorToast("Error: $e");
      return false;
    }
  }
}
