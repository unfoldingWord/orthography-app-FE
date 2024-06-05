import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orthoappflutter/core/app_export.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/syllabic_list_model.dart';

class ExpandedViewController extends GetxController {
  var counter = 0.obs;
  RxList<SyllabicData> syllabiclistItemList = <SyllabicData>[].obs;
  RxInt selectedImgIndex = 0.obs;
  RxBool isImgCompleted = false.obs;
  RxInt syllableType = 1.obs;
  RxBool isLoading = false.obs;
  var URL = dotenv.get("API_URL",fallback: "");

  @override
  void onInit() {
    super.onInit();
    ever(syllableType, (_) {
      fetchSyllablesType(syllableType.value);
    });
  }

  Future<void> fetchSyllablesType(type) async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString('userId');
      var response = await http.get(Uri.parse(
          URL + '/api/syllable/getSyllableByType?userId=${userId}&syllableType=${type}'));
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final apiResponse = SyllabicDataResponse.fromJson(jsonResponse);
        syllabiclistItemList.value=apiResponse.data ??[];
        isLoading.value = false;
        update();

      } else {
        Fluttertoast.showToast(msg: jsonResponse['message'],
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
          gravity: ToastGravity.CENTER,);
        throw Exception('Failed to load data');

      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void nextImgHandler() {
    if(selectedImgIndex.value==syllabiclistItemList.length-1)
    {
      isImgCompleted.value=true;
      update();
    }else{
      selectedImgIndex.value += 1;
      update();
    }

  }

  void updateIndex(index) {
    selectedImgIndex.value = index;
    update();
  }

  void updateSyllableType(val) {
    syllableType.value = val;
    update();
  }

  void previousImgHandler() {
    if(selectedImgIndex.value==0)
    {}else{
      selectedImgIndex.value -= 1;
      update();
    }

  }

}
