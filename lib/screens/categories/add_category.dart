import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nineteenfive_admin_panel/firebase/database/firebase_database.dart';
import 'package:nineteenfive_admin_panel/models/category.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/button/outline_border_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';

class AddCategory extends StatefulWidget {
  Category? category;

  AddCategory();

  AddCategory.editCategory(this.category);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  File? image;
  String? imageUrl;
  TextEditingController categoryNameController = TextEditingController();
  List<FocusNode> focusNodes = [];
  List<TextEditingController> sizeControllers = [];
  GlobalKey<FormState> formKey = GlobalKey();
  bool validateImageError = false;
  ScrollController scrollController = ScrollController();
  PickedFile? pickedFile;

  Future getImage() async {
    print('In Picker');
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
      List sizes = [];
      sizeControllers.forEach((element) {
        sizes.add(element.text);
      });
      if (widget.category != null) {
        updateCategory(sizes);
      } else {
        addNewCategory(sizes);
      }
    }
  }

  addNewCategory(sizes) async {
    String categoryId = DateTime.now().millisecondsSinceEpoch.toString();
    print(categoryId);
    await uploadFile(categoryId);
    Category category = Category(
        categoryId: categoryId,
        categoryName: categoryNameController.text,
        imageUrl: imageUrl ?? '',
        sizes: sizes);
    await FirebaseDatabase.storeCategory(category);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, 'New Category Added');
  }

  updateCategory(sizes) async {
    MyDialog.showLoading(context);
    await uploadFile(widget.category!.categoryId);
    widget.category!.categoryName = categoryNameController.text;
    widget.category!.imageUrl = imageUrl ?? '';
    widget.category!.sizes = sizes;
    await FirebaseDatabase.storeCategory(widget.category);
    Navigator.pop(context);
    MyDialog.showMyDialog(context, 'Category Updated');
  }

  String? validator(value) {
    if (value.isEmpty) {
      return "* Required";
    } else {
      return null;
    }
  }

  bool validateImage() {
    if (image != null) {
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

  Future<bool> uploadFile(String categoryId) async {
    try {
      await FirebaseStorage.instance
          .ref('categories/' + categoryId + ".jpg")
          .putData(await pickedFile!.readAsBytes(),
              SettableMetadata(contentType: 'image/jpeg'));
      await getDownloadUrl(categoryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getDownloadUrl(String categoryId) async {
    imageUrl = await FirebaseStorage.instance
        .ref('categories/' + categoryId + ".jpg")
        .getDownloadURL();
    print(imageUrl);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.category != null) {
      imageUrl = widget.category!.imageUrl;
      categoryNameController.text = widget.category!.categoryName;
      if (widget.category!.sizes != null) {
        widget.category!.sizes!.forEach((element) {
          sizeControllers.add(TextEditingController(text: element));
          focusNodes.add(FocusNode());
        });
      }
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
              Text(widget.category != null ? 'Update Category' : 'Add Category',
                  style: Theme.of(context).textTheme.bodyText1),
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
        color: Theme.of(context).scaffoldBackgroundColor,
        width: DeviceInfo.isMobile(context)
            ? MediaQuery.of(context).size.width * 0.8
            : 500,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        width: DeviceInfo.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.6
                            : 390,
                        height: DeviceInfo.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.6
                            : 390,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).primaryColor),
                        child: Hero(
                          tag: widget.category != null
                              ? widget.category!.categoryId
                              : DateTime.now().millisecondsSinceEpoch,
                          child: ClipOval(
                            child: image != null
                                ? ImageNetwork(
                                    imageUrl: image!.path,
                                    fit: BoxFit.cover,
                                  )
                                : imageUrl != null
                                    ? ImageNetwork(
                                        imageUrl: imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
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
                    text: widget.category != null || image != null
                        ? 'Change Image'
                        : 'Add Image',
                  ),
                  SizedBox(height: 30),
                  BasicTextField(
                    labelText: 'Category Name',
                    controller: categoryNameController,
                    validator: validator,
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
                          'Sizes',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                sizeControllers.add(TextEditingController());
                                focusNodes.add(FocusNode());
                              });
                              setState(() {
                                focusNodes[focusNodes.length - 1]
                                    .requestFocus();
                                scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).accentColor,
                              size: 30,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: sizeControllers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: BasicTextField(
                                labelText: 'Size',
                                controller: sizeControllers[index],
                                focusNode: focusNodes[index],
                                textCapitalization:
                                    TextCapitalization.characters,
                                textInputType: TextInputType.text,
                                validator: validator,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: LongBlueButton(
                                text: 'Delete',
                                onPressed: () {
                                  setState(() {
                                    sizeControllers.removeAt(index);
                                    focusNodes.removeAt(index);
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      );
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
                text: 'Cancel',
                textStyle: Theme.of(context).textTheme.headline3,
                onPressed: () => Navigator.pop(context),
              ),
            if (!DeviceInfo.isMobile(context))
              SizedBox(
                width: 10,
              ),
            Flexible(
              flex: DeviceInfo.isMobile(context) ? 1 : 0,
              child: LongBlueButton(
                width: DeviceInfo.isMobile(context) ? double.infinity : 160,
                text: widget.category != null
                    ? 'Update'
                    : 'Add',
                onPressed: () {
                  validate();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
