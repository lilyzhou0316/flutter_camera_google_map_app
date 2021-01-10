/*
 * @Author: your name
 * @Date: 2021-01-09 12:54:16
 * @LastEditTime: 2021-01-10 13:58:16
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/page/add_place_page.dart
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_flutter_sec13/model/place.dart';

import '../widget/image_input.dart';
import '../widget/location_input.dart';
import '../provider/places.dart';

class AddPlacePage extends StatefulWidget {
  static const routeName = '/add-place-page';
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _titleController = TextEditingController();
  File _pickedImage; //保存用户选择的图片的信息
  PlaceLocation _pickedLocation; //保存用户选择的地址的信息

//此方法接收从image_input.dart传过来的用户用照相机照的图片
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

//此方法接收从location_input.dart传过来的用户选择的地点信息
  void _selectPlace(double latitude, double longitude) {
    _pickedLocation = PlaceLocation(latitude: latitude, longitude: longitude);
  }

//保存用户输入的所有信息（包括图片）
  void _savePlace() {
    //如果输入为空或者没有图片或者没有地址信息，则直接返回
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    //否则把用户输入的信息新增到_items里（places.dart）
    Provider.of<Places>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    //添加后，离开当前页面回到主页面
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, //水平方向占据整个宽度
        children: [
          //1.获取用户输入
          //Expanded占据了除了RaisedButton需要占据的高度以外的剩余所有高度
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    //因为没有用form所以需要textcontroller
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(height: 20),
                    ImageInput(_selectImage),
                    SizedBox(height: 20),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          //2.保存用户输入信息
          RaisedButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              'add place',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: _savePlace,
            elevation: 0, //去掉阴影
            //去掉多余的margin
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
