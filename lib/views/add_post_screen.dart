import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/firebases/firestore_method.dart';
import 'package:flutter17_instagram_clone/providers/user_provider.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/picker_image.dart';
import 'package:flutter17_instagram_clone/widgets/show_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>{
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(
                      () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(
                      () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      isLoading = true;
    });

    try {
      String result = await FirestoreMethod().uploadPost(
        _captionController.text,
        _file!,
        uid,
        username,
        profileImage,
      );
      if (result == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Your post was uploaded!');
        clearImage();
      } else {
        showSnackBar(context, result);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (_file == null) {
        showSnackBar(context, 'Please add a Picture');
      } else {
        showSnackBar(context, e.toString());
      }
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
      _captionController.text = '';
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () => clearImage(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Add Post'),
        actions: [
          TextButton(
            onPressed: () {
              // _file==null?:
              postImage(
                userProvider.user!.uid,
                userProvider.user!.username,
                userProvider.user!.photoUrl,
              );
            },
            child: const Text(
              'Post',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          isLoading
              ? const LinearProgressIndicator()
              : const Padding(
            padding: EdgeInsets.only(top: 0),
          ),
          const Divider(),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userProvider.user!.photoUrl,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption.......',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectImage(context),
                    child: _file == null
                        ? Image.asset(
                      'assets/images/default_image.png',
                      width: 45,
                      height: 45,
                    )
                        : Image.memory(
                      _file!,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
