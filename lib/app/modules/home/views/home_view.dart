import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dio/dio.dart';
import '../../../data/models/province_model.dart';
import '../../../data/models/city_model.dart';
import '../../../constant/color.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: applightGreen,
        title: Text('Ongkos Kirim'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Provinsi Asal",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {
                  "key": "f218a9714c90ff5a74c89b87cb83df8e",
                },
              );

              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.provAsalId.value = value?.provinceId ?? "0",
          ),
          SizedBox(height: 15),
          DropdownSearch<City>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.type} ${item.cityName}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Kota Asal",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provAsalId}",
                queryParameters: {
                  "key": "f218a9714c90ff5a74c89b87cb83df8e",
                },
              );

              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.cityAsalId.value = value?.cityId ?? "0",
          ),
          SizedBox(height: 15),
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Provinsi Tujuan",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {
                  "key": "f218a9714c90ff5a74c89b87cb83df8e",
                },
              );

              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.provTujuanId.value = value?.provinceId ?? "0",
          ),
          SizedBox(height: 15),
          DropdownSearch<City>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.type} ${item.cityName}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Kota Tujuan",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provTujuanId}",
                queryParameters: {
                  "key": "f218a9714c90ff5a74c89b87cb83df8e",
                },
              );

              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.cityTujuanId.value = value?.cityId ?? "0",
          ),
          SizedBox(height: 15),
          DropdownSearch<Map<String, dynamic>>(
            items: [
              {
                "code": "jne",
                "name": "JNE",
              },
              {
                "code": "pos",
                "name": "POS Indonesia",
              },
              {
                "code": "tiki",
                "name": "TIKI",
              },
            ],
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item['name']}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Pilih Kurir",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
            dropdownBuilder: (context, selectedItem) =>
                Text("${selectedItem?['name'] ?? "Pilih Kurir"}"),
            onChanged: (value) =>
                controller.codeKurir.value = value?['code'] ?? "",
          ),
          SizedBox(height: 15),
          TextField(
            controller: controller.beratC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Berat (gram)",
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          Obx(() => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.cekOngkir();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: applightGreen, // background
                ),
                child: Text(
                    controller.isLoading.isFalse ? "Cek Ongkir" : "Loading"),
              )),
        ],
      ),
    );
  }
}
