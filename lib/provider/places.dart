/*
 * @Author: your name
 * @Date: 2021-01-09 12:57:36
 * @LastEditTime: 2021-01-10 14:50:04
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/provider/places.dart
 */
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../model/place.dart';
import '../helper/db_helper.dart';
import '../helper/location_helper.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    //返回一个_items的copy.而不是直接返回_items
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

//给_items里新增place
  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    //把location从lati,longi格式转换成用户可识别的地址格式
    final address = await LocationHelper.getPlaceAddress(
        location.latitude, location.longitude);
    final updatedLocation = PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      address: address,
    );

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    //把新place加入sql数据库
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      //image存入的是它的path
      'image': newPlace.image.path,
      'title': newPlace.title,
      'location_lat': newPlace.location.latitude,
      'location_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['location_lat'],
                longitude: item['location_lng'],
                address: item['address'],
              ),
            ))
        .toList();
  }
}
