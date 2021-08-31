import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/category.dart';
import 'package:nineteenfive_admin_panel/screens/categories/add_category.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/data/static_data.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  addNewCategory(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddCategory();
        });
    setState(() {});
  }

  editCategory(BuildContext context, Category category) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddCategory.editCategory(category);
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: MediaQuery.of(context).size.width > 420
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      addNewCategory(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(
                              Constants.buttonBorderRadius)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 20,
                            color: Theme.of(context).accentColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Add Category',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              GridView.builder(
                  itemCount: StaticData.categories.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 40,
                      crossAxisCount: MediaQuery.of(context).size.width > 1200
                          ? 4
                          : MediaQuery.of(context).size.width > 900
                              ? 3
                              : 2,
                      crossAxisSpacing: 40,
                      childAspectRatio:
                          DeviceInfo.isMobile(context) ? 0.82 : 0.88),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        editCategory(context, StaticData.categories[index]);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipOval(
                                child: ImageNetwork(
                                  imageUrl:
                                      StaticData.categories[index].imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              StaticData.categories[index].categoryName,
                              style: Theme.of(context).textTheme.headline3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
