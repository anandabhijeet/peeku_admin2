import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';


class Homepage extends StatefulWidget {


  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  //token area
  var jwtToken;

  void initState() {
    super.initState();
    read();
  }


  Future read() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    jwtToken = value;
    print('token: $jwtToken');
  }

  //upload image area

  var _language = ['Hindi', 'English', 'others'];
  var _currentItemSelected = 'English';

  TextEditingController _newsCaption = TextEditingController();
  TextEditingController _newsLink = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  File selectedImage;
  File selectedImage1;
  File selectedImage2;
  bool _isLoading = false;




  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }
  Future getImage1() async {
    // ignore: deprecated_member_use
    var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage1 = image1;
    });
  }
  Future getImage2() async {
    // ignore: deprecated_member_use
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage2 = image2;
    });
  }
  var imageUrl = new List();
  var imageList = new List(3);

  Future getimages(){
    setState(() {
      imageList[0] = selectedImage;
      imageList[1] = selectedImage1;
      imageList[2] = selectedImage2;
    });
    print(imageList);
  }



  _uploadImages(filepath) async{
    String fileName = basename(filepath.path); 
    print("File base name: $fileName");
    try{
      dio.FormData formData =
      new dio.FormData.from({"file": new dio.UploadFileInfo(filepath, fileName)});

      dio.Response response =
      await dio.Dio().post("http://165.22.214.234:9000/uploads", data: formData,
          options: dio.Options(responseType: dio.ResponseType.json,  contentType: ContentType('image', 'jpg'),
              headers: {
                "Authorization": "Bearer $jwtToken",
                "Content-Type": "multipart/form-data"
              }
          ));print(response);
        imageUrl.add(json.decode(response.toString())["url"]);
        print(imageUrl);


    } catch(e){
      print("Exception Caught $e");
    }

  }

  _upload_images(ListOfImage){
    for(int i = 0; i<ListOfImage.length; i++){
      if(ListOfImage[i] != null){
        _uploadImages(ListOfImage[i]);

      }
    }
  }


  //final news section
  _finalNews() async {
    print('final news method is starting');
    try {
      dio.Response res = await dio.Dio().post(
          "http://165.22.214.234:9000/news",
          data: {"lang": _currentItemSelected,
            "images": imageUrl,
            "headline": _newsCaption,
            "link": _newsLink},
          options: dio.Options(responseType: dio.ResponseType.json,
              contentType: ContentType('news', 'String'),

              headers: {
                "Authorization": "Bearer $jwtToken",
                "Content-Type": "application/json"
              })
      );

      print(res);



    }
    on dio.DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
  }

  //final call area

  finalCall() async{
    if(imageList != null){
      _upload_images(imageList);

    }if(imageUrl != null){
     await _finalNews();

    }

  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Flutter",
                style: TextStyle(fontSize: 22),
              ),
              Text(
                "Blog",
                style: TextStyle(fontSize: 22, color: Colors.blue),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                getimages();
                if (_formKey.currentState.validate()){
                  finalCall();
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.file_upload)),
            )
          ],
        ),
        body: _isLoading
            ? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
            : Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    width: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        selectedImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    width: 400,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.black45,
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    getImage1();
                  },
                  child: selectedImage1 != null
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    width: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        selectedImage1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    width: 400,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.black45,
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    getImage2();
                  },
                  child: selectedImage2 != null
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    width: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        selectedImage2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    width: 400,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.black45,
                    ),
                  )),
              SizedBox(
                height: 8,
              ),

              Container(

                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 5, right: 5),
                            child: Container(
                              child: TextFormField(
                                controller: _newsCaption,
                                // ignore: missing_return
                                validator: (String value){
                                  if(value.isEmpty){
                                    // ignore: missing_return
                                    return 'Please Enter news headline';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Headline',
                                    hintText: 'Enter News Headline',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    )
                                ),),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 5, right: 5),
                            child: Container(
                              child: TextFormField(
                                controller: _newsLink,
                                // ignore: missing_return
                                validator: (String value){
                                  if(value.isEmpty){
                                    // ignore: missing_return
                                    return 'Please provide news Link';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Link',
                                    hintText: 'Enter News Caption',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    )
                                ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton<String>(

                      items: _language.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,

                          child: Text(dropDownStringItem),

                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        // Your code to execute, when a menu item is selected from drop down
                        setState(() {
                          this._currentItemSelected = newValueSelected;
                        });
                      },
                      value: _currentItemSelected,
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
