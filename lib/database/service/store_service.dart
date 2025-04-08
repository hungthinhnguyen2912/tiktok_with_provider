import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiktokclone/database.dart';
import 'package:tiktokclone/database/model/video_model.dart';
import 'package:video_compress/video_compress.dart';

class StorageService {
  static String api_key = "569974434653456";
  static String api_secret = "X8B2oAXi3OwzX4aFAMH3562HSY8";
  static String cloud_name = "dtbwbqwah";

  static final Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: api_key,
    apiSecret: api_secret,
    cloudName: cloud_name,
  );

  static upLoadVideoToStorage(String uidVideo, String videoPath) async {
    try {
      String userUid = FirebaseAuth.instance.currentUser!.uid;

      final response = await cloudinary.upload(
        file: videoPath,
        resourceType: CloudinaryResourceType.video,
        folder: 'videos/$userUid',
        fileName: 'video_$uidVideo',
      );

      if (response.isSuccessful) {
        return response.secureUrl;
        print(response.secureUrl);
      } else {
        print('Upload failed: ${response.error}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static getThumbNail(String videoPath) async {
    final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbNail;
  }

  static Future<String?> uploadThumbnailToCloudinary(
    String videoId,
    File thumbNailFile,
  ) async {
    try {
      String userUid = FirebaseAuth.instance.currentUser!.uid;
      final response = await cloudinary.upload(
        file: thumbNailFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'thumbnails/$userUid',
        fileName: 'thumb_$videoId',
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        print('Thumbnail upload failed: ${response.error}');
        return null;
      }
    } catch (e) {
      print('Thumbnail upload error: $e');
      return null;
    }
  }

  static uploadVideo(String videoPath, String songName, String caption) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot docs =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      String videoId = FirebaseFirestore.instance.collection("videos").doc().id;

      String? videoUrl = await upLoadVideoToStorage(videoId, videoPath);
      if (videoUrl == null) return;

      File thumbNailFile = await getThumbNail(videoPath);
      String? thumbUrl = await uploadThumbnailToCloudinary(
        videoId,
        thumbNailFile,
      );
      if (thumbUrl == null) return;

      Video video = Video(
        username: (docs.data()! as Map<String, dynamic>)['fullname'],
        uidUser: uid,
        idVideo: videoId,
        likes: [],
        comments: [],
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (docs.data()! as Map<String, dynamic>)['avatarURL'],
        thumbnail: thumbUrl,
      );

      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoId)
          .set(video.toJson());
    } catch (e) {
      print("Upload Failed: ${e.toString()}");
    }
  }

  static uploadImage(String filePath) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final response = await cloudinary.upload(
      resourceType: CloudinaryResourceType.image,
      file: filePath,
      folder: "Avatar",
      fileName: "Avatar/$currentUser",
    );
    try {
      if (response.isSuccessful) {
        print("response: $response");
        return response.secureUrl;
      } else {
        print("Upload failed");
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
    }
  }
}
