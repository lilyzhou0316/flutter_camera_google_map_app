/*
 * @Author: your name
 * @Date: 2021-01-09 13:34:17
 * @LastEditTime: 2021-01-10 13:50:36
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/widget/image_input.dart
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; //照相机
import 'package:path_provider/path_provider.dart'
    as pathpro; //保存图片到手机内存中（作用：找到path）
import 'package:path/path.dart' as pathsys; //保存图片到手机内存中(作用：组合path)

class ImageInput extends StatefulWidget {
  //接收从add_place_page.dart传过来的方法
  //这个方法会把用户通过照相机照的图片传递给add_place_page.dart
  final Function selectImage;
  ImageInput(this.selectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    //这里需要将用照相机照的照片保存在手机内存中
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );
    //如果用户没有选择图片直接返回
    if (imageFile == null) {
      return;
    }
    setState(() {
      //imageFile类型为pickedfile需要转换成file
      _storedImage = File(imageFile.path);
    });
    //getApplicationDocumentsDirectory找到了当前app在硬盘哪个位置
    final appDirectory = await pathpro.getApplicationDocumentsDirectory();
    //找到文件名
    final fileName = pathsys.basename(imageFile.path);
    //上两者合并起来即为图片文件的保存路径,把它保存到手机内存中
    final savedImage =
        await File(imageFile.path).copy('${appDirectory.path}/$fileName');
    //最后把这个被保存的图片传给add_place_page.dart
    widget.selectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //预览图片
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'no image taken!',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        //打开相册或者相机
        //注意：android不需要另外添加permit, ios手机需要在<project root>/ios/Runner/Info.plist
        //中按照package里的readme里的要求添加permit
        FlatButton(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('take a picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
