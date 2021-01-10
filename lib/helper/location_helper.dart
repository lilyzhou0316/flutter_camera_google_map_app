/*
 * @Author: your name
 * @Date: 2021-01-09 16:35:14
 * @LastEditTime: 2021-01-10 14:35:25
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/helper/location_helper.dart
 */
//官方教程见：
//https://developers.google.com/maps/documentation/maps-static/overview?_ga=2.196919727.2020477433.1610239077-769495501.1587870897&_gac=1.224027113.1610239127.CjwKCAiAxeX_BRASEiwAc1QdkZyUcLlF5Fp4aRo5DDGhEZ3shSbKarXnMbb8CODjU8HuDhdI3emxeRoCfOQQAvD_BwE
//注意，需要在google map platform里enable map static apis
import 'dart:convert';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyAWbB2wpjxt17eCJveuIpyo6y77PlYXvX4';

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

//把latitude,longitude转换成用户可读懂的地址信息
  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    //需要发送http请求到google map
    //教程见：https://developers.google.com/maps/documentation/geocoding/overview#ReverseGeocoding
    //注意，这里需要enable geocoding api
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    //print(json.decode(response.body).toString());
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
