import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickimage() async {
  String? fileurl;
  ImagePicker image = ImagePicker();
      XFile? file = await image.pickImage(
          source: ImageSource.gallery);
      String unique = DateTime.now()
          .millisecondsSinceEpoch
          .toString();
      Reference refernceroot =
          FirebaseStorage.instance.ref();
      Reference referdirimages =
          refernceroot.child('images');
      Reference refertoupload =
          referdirimages.child(unique);
      try {
        await refertoupload.putFile(File(file!.path));
        fileurl =  await refertoupload.getDownloadURL();
      } catch (e) {
        print(e);
      }
  return fileurl!;
}