import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nineteenfive_admin_panel/firebase/database/firebase_database.dart';
import 'package:nineteenfive_admin_panel/models/poster.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/data/static_data.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/button/outline_border_button.dart';
import 'package:nineteenfive_admin_panel/widgets/drop_down_button/my_drop_down_button.dart';
import 'package:nineteenfive_admin_panel/widgets/slider/my_slider.dart';
import 'dart:async';

import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';
import 'package:nineteenfive_admin_panel/widgets/switch/my_switch.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class AddPoster extends StatefulWidget {
  Poster? poster;
  String? position;

  AddPoster({Key? key, required this.position}) : super(key: key);

  AddPoster.updatePoster(this.poster);

  @override
  _AddPosterState createState() => _AddPosterState();
}

class _AddPosterState extends State<AddPoster> {
  File? image;
  PickedFile? pickedFile;
  String? imageUrl;
  double height = 210;
  late String selectedCategoryId;
  late String selectedPosition;
  TextEditingController categoryNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool validateImageError = false;
  ScrollController scrollController = ScrollController();

  int productMinOff = 0;
  int productMaxOff = 0;
  int productMinPrice = 0;
  int productMaxPrice = 0;

  TextEditingController productMinPriceController = TextEditingController();
  TextEditingController productMaxPriceController = TextEditingController();

  bool isActive = true;

  Future getImage() async {
    pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile!.path);
      });
    }
  }

  validate() async {
    bool imageValidate = validateImage();
    bool formValidate = formKey.currentState!.validate();
    if (imageValidate && formValidate) {
      if(widget.poster!=null) {
        editPoster();
      } else {
        addPoster();
      }

    }
  }

  editPoster() async {
   if(pickedFile!=null) {
     await uploadFile(widget.poster!.posterId);
     widget.poster!.imageUrl = imageUrl!;
   }
   widget.poster!.isActive = isActive;
   widget.poster!.position = selectedPosition;
   widget.poster!.categoryId = selectedCategoryId;
   widget.poster!.maxAmount = productMaxPrice;
   widget.poster!.minAmount = productMinPrice;
   widget.poster!.maxOff = productMaxOff;
   widget.poster!.minOff = productMinOff;
   MyDialog.showLoading(context);
   await FirebaseDatabase.storePoster(widget.poster);
   Navigator.pop(context);
   Navigator.pop(context);
   MyDialog.showMyDialog(context, "Poster Updated");
  }
  addPoster() async {
    String posterId = DateTime.now().millisecondsSinceEpoch.toString();
    await uploadFile(posterId);
    Poster poster = Poster(
        imageUrl: imageUrl ?? '',
        position: selectedPosition,
        categoryId: selectedCategoryId,
        posterId: posterId,
        maxAmount: productMaxPrice,
        minAmount: productMinPrice,
        maxOff: productMaxOff,
        isActive: isActive,
        minOff: productMinOff);
    MyDialog.showLoading(context);
    await FirebaseDatabase.storePoster(poster);
    Navigator.pop(context);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, "Poster Published");
  }

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  bool validateImage() {
    if (image != null || imageUrl!=null) {
      setState(() {
        validateImageError = false;
      });
      return true;
    } else {
      setState(() {
        validateImageError = true;
      });
      return false;
    }
  }

  Future<bool> uploadFile(String posterId) async {
    try {
      print(image);
      await FirebaseStorage.instance
          .ref('posters/' + posterId + ".jpg")
          .putData(await pickedFile!.readAsBytes(),
              SettableMetadata(contentType: 'image/jpeg'));
      await getDownloadUrl(posterId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> uploadFile(String posterId) async {
  //   try {
  //     await FirebaseStorage.instance
  //         .ref('posters/' + posterId + ".jpg")
  //         .putFile(image!);
  //     await getDownloadUrl(posterId);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> getDownloadUrl(String posterId) async {
    imageUrl = await FirebaseStorage.instance
        .ref('posters/' + posterId + ".jpg")
        .getDownloadURL();
    print(imageUrl);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.poster != null) {
      imageUrl = widget.poster!.imageUrl;
      selectedCategoryId = widget.poster!.categoryId;
      selectedPosition = widget.poster!.position;
      productMaxOff = widget.poster!.maxOff ?? 0;
      productMinOff = widget.poster!.minOff ?? 0;
      productMinPrice = widget.poster!.minAmount ?? 0;
      productMaxPrice = widget.poster!.maxAmount ?? 0;
      isActive = widget.poster!.isActive!;
    } else {
      selectedCategoryId = StaticData.categories.first.categoryId;
      selectedPosition = widget.position ?? '';
    }

    productMinPriceController.text = productMinPrice.toString();
    productMaxPriceController.text = productMaxPrice.toString();
    if (selectedPosition == "Top") {
      height = Constants.TOP_POSTER_HEIGHT + 40;
    } else {
      height = Constants.BOTTOM_POSTER_HEIGHT + 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                widget.poster != null
                    ? 'Update $selectedPosition Poster'
                    : 'New $selectedPosition Poster',
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 26,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: Container(
        width: DeviceInfo.isMobile(context)
            ? MediaQuery.of(context).size.width * 0.8
            : 500,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 28),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        width: double.infinity,
                        height: height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: Theme.of(context).primaryColor),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              selectedPosition == "Top" ? 15 : 0),
                          child: image != null
                              ? Image.network(
                                  image!.path,
                                  fit: BoxFit.cover,
                                )
                              : imageUrl != null
                                  ? ImageNetwork(
                                      imageUrl: imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox(
                                      height: height,
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: ColorPalette.grey,
                                      ),
                                    ),
                        )),
                  ),
                  if (validateImageError)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 10),
                      child: Text(
                        '* Image required',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  SizedBox(
                    height: 40,
                  ),
                  OutlineBorderButton(
                    onPressed: getImage,
                    text: widget.poster != null || image != null
                        ? 'Change Image'
                        : 'Add Image',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyDropDownButton(
                    height: 60,
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value.toString();
                      });
                    },
                    items: List.generate(StaticData.categories.length, (index) {
                      return DropdownMenuItem(
                        value: StaticData.categories[index].categoryId,
                        child: Text(
                          StaticData.categories[index].categoryName,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Theme.of(context).accentColor,
                                  ),
                        ),
                      );
                    }),
                    value: selectedCategoryId,
                    isExpanded: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      MySwitch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          })
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BasicTextField(
                    labelText: 'Product Min Price',
                    controller: productMinPriceController,
                    textInputType: TextInputType.number,
                    enableInteractiveSelection: false,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffixText: Constants.currencySymbol,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        productMinPrice = int.parse(value);
                      } else {
                        productMinPrice = 0;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  BasicTextField(
                    labelText: 'Product Max Price',
                    controller: productMaxPriceController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        productMaxPrice = int.parse(value);
                      } else {
                        productMaxPrice = 0;
                      }
                    },
                    textInputType: TextInputType.number,
                    enableInteractiveSelection: false,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    suffixText: Constants.currencySymbol,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product Min Off',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Theme.of(context).accentColor,
                                  ),
                        ),
                        Text(
                          productMinOff.toString() + "%",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Theme.of(context).accentColor,
                                  ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  MySlider(
                    value: productMinOff.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        productMinOff = value!.toInt();
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product Max Off',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Theme.of(context).accentColor,
                                  ),
                        ),
                        Text(
                          productMaxOff.toString() + "%",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Theme.of(context).accentColor,
                                  ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  MySlider(
                    value: productMaxOff.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        productMaxOff = value!.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.symmetric(horizontal: 20),
      actions: [
        Container(
          width: double.infinity,
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!DeviceInfo.isMobile(context))
              LongBlueButton(
                width: 100,
                color: Colors.transparent,
                textStyle: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            if (!DeviceInfo.isMobile(context))
              SizedBox(
                width: 10,
              ),
            Flexible(
              flex: DeviceInfo.isMobile(context) ? 1 : 0,
              child: LongBlueButton(
                width: DeviceInfo.isMobile(context) ? double.infinity : 200,
                text:
                    widget.poster != null ? 'Update Poster' : 'Publish Poster',
                onPressed: () => validate(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
