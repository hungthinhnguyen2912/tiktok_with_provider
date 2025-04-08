import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/database/service/store_service.dart';
import 'package:tiktokclone/database/service/user_service.dart';
import 'package:tiktokclone/provider/loading_model.dart';

import '../../../../database/service/auth_service.dart';
import '../../../widgets/colors.dart';
import '../../../widgets/custom_text.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    Future<File?> getImage() async {
      var picker = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picker != null) {
        File? imageFile = File(picker.path);
        return imageFile;
      }
      return null;
    }
    return Scaffold(
      body: FutureBuilder(
        future: UserService.getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 8,
                    // ),
                    IconButton(
                      onPressed: () {},
                      iconSize: 25,
                      icon: Icon(Icons.menu, color: MyColors.thirdColor),
                    ),
                    Center(
                      child: CustomText(
                        fontsize: 20,
                        text: '${snapshot.data.get('fullname') ?? "No name"}',
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => showLogoutDialog(context),
                      iconSize: 25,
                      icon: Icon(Icons.logout, color: MyColors.thirdColor),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: StreamBuilder(
                          stream: getUserImage(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            }
                            return Consumer<LoadingModel>(
                              builder: (_, isLoadingImage, _) {
                                if (isLoadingImage.isLoading) {
                                  return CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor: MyColors.mainColor,
                                    backgroundImage: NetworkImage(snapshot
                                        .data?.docs.first['avatarURL']),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: -16,
                        right: -15,
                        child: IconButton(
                          onPressed: () async {
                            context.read<LoadingModel>().changeLoading();
                            File? fileImage = await getImage();
                            if (fileImage == null) {
                              context.read<LoadingModel>().changeLoading();
                            } else {
                              String fileName =
                              await StorageService.uploadImage(fileImage.path);
                              UserService.addAvatarFirebase(fileName);
                              context.read<LoadingModel>().changeLoading();
                            }
                          },
                          icon: Icon(
                            Icons.upload_sharp,
                            color: MyColors.thirdColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getUserImage() async* {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUserID)
        .snapshots();
  }

  showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'SIGN OUT',
                      style: TextStyle(fontSize: 25, color: Colors.red),
                    ),
                    Text('Are you sure ?', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      AuthService.logOut(context: context);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.done, color: Colors.green),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'Yes',
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Row(
                      children: const [
                        Icon(Icons.cancel, color: Colors.red),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'No',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
