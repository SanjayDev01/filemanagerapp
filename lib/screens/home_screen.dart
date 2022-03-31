import 'package:filemanagerapp/screens/folder.dart';
import 'package:filemanagerapp/screens/private_dir.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLocked = true;

  moveToDirectory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PrivateDirectory()));
  }

  enterPass(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderName,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // try {
                    //   // Create Folder
                    //   await FileManager.createFolder(
                    //       controller.getCurrentPath, folderName.text);
                    //   // Open Created Folder
                    //   controller.setCurrentPath =
                    //       controller.getCurrentPath + "/" + folderName.text;
                    //   print(controller.getCurrentPath);
                    // } catch (e) {
                    //   print(e);
                    // }

                    Navigator.pop(context);
                  },
                  child: const Text('Enter Password'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "File Manager",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Local Storage"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FolderScreen()));
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Private Directory"),
                  isLocked
                      ? const Icon(Icons.lock)
                      : const Icon(Icons.lock_open_outlined)
                ],
              ),
              onTap: () {
                isLocked ? enterPass(context) : moveToDirectory();
              },
            ),
          )
        ],
      ),
    );
  }
}
