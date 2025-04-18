import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/database/service/store_service.dart';

import '../../../../provider/loading_model.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/text_form_field.dart';
import '../../../widgets/video_play_item.dart';

class AddVideoScreen extends StatelessWidget {
  final File videoFile;
  final String videoPath;

  AddVideoScreen({Key? key, required this.videoFile, required this.videoPath})
    : super(key: key);

  final _addVideoFormKey = GlobalKey<FormState>();
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<LoadingModel>().isPushingVideo = false;
    return SafeArea(
      child: Scaffold(
        body: Consumer<LoadingModel>(
          builder: (_, isPushingVideo, __) {
            if (isPushingVideo.isPushingVideo) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  CustomText(
                    text: "Pushing Video ....",
                    fontsize: 25,
                    alignment: Alignment.center,
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      height: MediaQuery.of(context).size.height / 2,
                      child: VideoPlayerItem(videoUrl: videoPath),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _addVideoFormKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: CustomTextFormField(
                              controller: _songController,
                              text: 'Song Name',
                              hint: '',
                              validator: (value) {},
                              onSave: (value) {},
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: CustomTextFormField(
                              controller: _captionController,
                              text: 'Caption',
                              hint: '',
                              validator: (value) {},
                              onSave: (value) {},
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 60),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  context
                                      .read<LoadingModel>()
                                      .changePushingVideo();
                                  await StorageService.uploadVideo(
                                    videoPath,
                                    _songController.text,
                                    _captionController.text,
                                  );
                                  context.read<LoadingModel>().changePushingVideo();
                                  Navigator.pop(context);
                                },
                                child: const Text('Share'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
