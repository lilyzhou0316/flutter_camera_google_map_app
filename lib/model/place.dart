/*
 * @Author: your name
 * @Date: 2021-01-09 12:58:18
 * @LastEditTime: 2021-01-09 17:29:01
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/model/place.dart
 */
import 'dart:io';
import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude; //保存当前地点的经纬度
  final double longitude;
  final String address;
  const PlaceLocation({
    this.address,
    @required this.latitude,
    @required this.longitude,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    @required this.id,
    @required this.image,
    @required this.location,
    @required this.title,
  });
}
