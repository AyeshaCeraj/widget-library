import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadingImage extends StatefulWidget {
  const UploadingImage({Key? key}) : super(key: key);

  @override
  State<UploadingImage> createState() => _UploadingImageState();
}

class _UploadingImageState extends State<UploadingImage> {
  File ? _selectedImage;


  Future pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
        print('selected image : ${_selectedImage}');
      });
    } else {
      // Optional: show feedback or just do nothing
      print('No image selected');
    }
  }
  Future pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    } else {
      // Optional: show feedback or just do nothing
      print('No image selected');
    }
  }

  Future<String?> uploadImageToImgBB(File imageFile) async {
    final apiKey = 'd3b8271733e4d2b1bcbb4bec57fa5300';
    final url = 'https://api.imgbb.com/1/upload';

    try {
      final formData = FormData.fromMap({
        'key': apiKey,
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await Dio().post(
        url,
        data: formData,
      );

      if (response.statusCode == 200) {
        final imageUrl = response.data['data']['url'];
        print('Uploaded Image URL: $imageUrl');
        return imageUrl;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void>  ImageSender({required String imageUrl}) async {

    try {

      Map<String,dynamic> data = {
        'image' : imageUrl
      };

      var response = await Dio().patch(
          'https://flutterapitest123-affe0-default-rtdb.firebaseio.com/Pictures.json',
          data: data
      );


    } catch (e) {
      print("Failed to fetch user data");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('data'),
          SizedBox(height: 15,),



          _selectedImage != null
              ? Stack(
            children: [
              Center(
                child: Image.file(
                  _selectedImage!,

                  height: 350,
                  width: 350,
                  fit: BoxFit.fill, // 🔧 this fixes height issues
                ),
              ),
              Positioned(
                  top: 10,
                  right: 17,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle
                    ),
                    child: PopupMenuButton(
                      color : Colors.white,
                      onSelected: (value){
                        if(value== 1){
                          pickImageFromCamera();
                        }
                        if(value== 2){
                          pickImageFromGallery();

                        }
                      },

                      itemBuilder:

                          (BuildContext context) {
                        return [
                          PopupMenuItem(
                              value: 1,
                              child: Text('Camera')
                          ),
                          PopupMenuItem(
                              value: 2,
                              child: Text('Gallery')
                          )
                        ];
                      },),
                  )
              )
            ],
          )
              : Center(
            child: Container(


                height: 350,
                width: 350,

                decoration: BoxDecoration(
                    color: Color(0xFF2C5364).withOpacity(0.03),
                    border: Border.all(color: Color(0xFF2C5364).withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 63,
                            width: 73,

                            child: Icon(Icons.camera_alt_outlined,size: 43,color: Colors.black,)
                        ),
                        SizedBox(height: 12,),
                        Text('Add Product Image'),
                        SizedBox(height: 22,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(onPressed: (){
                              pickImageFromGallery();
                            },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color:Color(0xFF2C5364).withOpacity(0.3) )

                                    )
                                ),
                                child:Row(
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined,color: Colors.black87,),
                                    SizedBox(width: 12,),
                                    Text('Gallery',style: TextStyle(color: Colors.black87,fontFamily: 'Lato'),)
                                  ],)
                            ),

                            ElevatedButton(
                                onPressed: (){
                                  pickImageFromCamera();
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color:Color(0xFF2C5364).withOpacity(0.3) )

                                    )
                                ),
                                child:Row(children: [
                                  Icon(Icons.camera_alt,color: Colors.black87,),
                                  SizedBox(width: 12,),
                                  Text('Camera',style: TextStyle(color: Colors.black87,fontFamily: 'Lato'),)
                                ],)
                            ),
                          ],
                        )
                      ],
                    )
                )
            ),
          ),

          SizedBox(height: 15,),

          ElevatedButton(
            onPressed: () async {
              if (_selectedImage != null) {
                String? imageUrl = await uploadImageToImgBB(_selectedImage!);

                if (imageUrl != null) {
                  ImageSender(imageUrl: '$imageUrl');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Image uploaded: $imageUrl')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select an image first')),
                );
              }
            },
            child: Text("Upload Image"),
          ),

        ],
      )
    );
  }
}
