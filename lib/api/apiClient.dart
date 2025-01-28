import 'dart:convert';
import 'package:taskmanager/Style/Style.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanager/modals/taskCountMOdal.dart';

import '../utility/utility.dart';

var BaseURL = "https://task.teamrabbil.com/api/v1";
var RequestHeader = {"Content-Type": "application/json"};

Future<bool> LoginRequest(FormValues) async {
  var URL = Uri.parse("$BaseURL/login");
  var PostBody = json.encode(FormValues);
  var response = await http.post(URL, headers: RequestHeader, body: PostBody);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    await WriteUserData(ResultBody);
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> RegistrationRequest(FormValues) async {
  var URL = Uri.parse("${BaseURL}/registration");
  var PostBody = json.encode(FormValues);
  var response = await http.post(URL, headers: RequestHeader, body: PostBody);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail....... ! try again");
    return false;
  }
}

Future<Map<String, String>> ProfileUpdateRequest(FormValues) async {
  var URL = Uri.parse("${BaseURL}/profileUpdate");
  var PostBody = json.encode(FormValues);
  var response = await http.post(URL, headers: RequestHeader, body: PostBody);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);

  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    // Returning the updated user data
    return ResultBody[
        'user']; // Assuming the response contains updated user data
  } else {
    ErrorToast("Request fail! Try again");
    return {}; // Returning an empty map in case of failure
  }
}

Future<bool> VerifyEmailRequest(email) async {
  var URL = Uri.parse("${BaseURL}/RecoverVerifyEmail/${email}");
  var response = await http.get(URL, headers: RequestHeader);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    await WriteEmailVerification(email);
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> VerifyOTPRequest(Email, OTP) async {
  var URL = Uri.parse("$BaseURL/RecoverVerifyOTP/$Email/$OTP");
  var response = await http.get(URL, headers: RequestHeader);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    await WriteOTPVerification(OTP);
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> SetPasswordRequest(FormValues) async {
  var URL = Uri.parse("${BaseURL}/RecoverResetPass");
  var PostBody = json.encode(FormValues);

  var response = await http.post(URL, headers: RequestHeader, body: PostBody);

  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);

  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<List> TaskListRequest(Status) async {
  var URL = Uri.parse("${BaseURL}/listTaskByStatus/${Status}");
  String? token = await ReadUserData("token");
  var RequestHeaderWithToken = {
    "Content-Type": "application/json",
    "token": '$token'
  };
  var response = await http.get(URL, headers: RequestHeaderWithToken);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    return ResultBody['data'];
  } else {
    ErrorToast("Request fail ! try again");
    return [];
  }
}

Future<List<TaskCountModal>> TaskStatusCountListRequest() async {
  var URL = Uri.parse("${BaseURL}/taskStatusCount");
  String? token = await ReadUserData("token");

  var RequestHeaderWithToken = {
    "Content-Type": "application/json",
    "token": '$token'
  };

  try {
    var response = await http.get(URL, headers: RequestHeaderWithToken);
    var ResultCode = response.statusCode;
    var ResultBody = json.decode(response.body);

    if (ResultCode == 200 && ResultBody['status'] == "success") {
      // Parse the response into a list of TaskStatusModal
      List<TaskCountModal> data = (ResultBody['data'] as List)
          .map((item) => TaskCountModal.fromJson(item))
          .toList();

      return data;
    } else {
      ErrorToast("Request failed! Please try again.");
      return [];
    }
  } catch (e) {
    ErrorToast("An error occurred! $e");
    return [];
  }
}

Future<bool> TaskCreateRequest(FormValues) async {
  var URL = Uri.parse("${BaseURL}/createTask");
  String? token = await ReadUserData("token");
  var RequestHeaderWithToken = {
    "Content-Type": "application/json",
    "token": '$token'
  };

  var PostBody = json.encode(FormValues);

  var response =
      await http.post(URL, headers: RequestHeaderWithToken, body: PostBody);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> TaskDeleteRequest(id) async {
  var URL = Uri.parse("${BaseURL}/deleteTask/${id}");
  String? token = await ReadUserData("token");
  var RequestHeaderWithToken = {
    "Content-Type": "application/json",
    "token": '$token'
  };
  var response = await http.get(URL, headers: RequestHeaderWithToken);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> TaskUpdateRequest(id, status) async {
  var URL = Uri.parse("${BaseURL}/updateTaskStatus/${id}/${status}");
  String? token = await ReadUserData("token");
  var RequestHeaderWithToken = {
    "Content-Type": "application/json",
    "token": '$token'
  };
  var response = await http.get(URL, headers: RequestHeaderWithToken);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}
