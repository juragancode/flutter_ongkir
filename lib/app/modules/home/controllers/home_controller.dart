import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkosKirim = [];

  RxBool isLoading = false.obs;

  RxString provAsalId = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString provTujuanId = "0".obs;
  RxString cityTujuanId = "0".obs;
  RxString codeKurir = "".obs;

  void cekOngkir() async {
    if (provAsalId != "0" &&
        provTujuanId != "0" &&
        cityAsalId != "0" &&
        cityTujuanId != "0" &&
        codeKurir != "" &&
        beratC.text != "") {
      try {
        isLoading.value = true;
        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {
            "key": "f218a9714c90ff5a74c89b87cb83df8e",
            "content-type": "application/x-www-form-urlencoded"
          },
          body: {
            "origin": cityAsalId.value,
            "destination": cityTujuanId.value,
            "weight": beratC.text,
            "courier": codeKurir.value,
          },
        );
        isLoading.value = false;
        List ongkir = jsonDecode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;
        ongkosKirim = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
          title: "Ongkos Kirim",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ongkosKirim
                .map(
                  (e) => ListTile(
                    title: Text("${e.service!.toUpperCase()}"),
                    subtitle: Text("${e.cost![0].value}"),
                  ),
                )
                .toList(),
          ),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan!",
          middleText: "Tidak dapat mengecek ongkir!",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan!",
        middleText: "Data input belum lengkap!",
      );
    }
  }
}
