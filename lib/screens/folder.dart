import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FileManagerController controller = FileManagerController();

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              FileManager.formatBytes(size),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return const Text("");
        }
      },
    );
  }

  _showPopupMenu(
      BuildContext context, Offset offset, FileSystemEntity entity) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
            child: const Text('Rename'),
            value: 'rename',
            onTap: () {
              Future.delayed(const Duration(seconds: 1),
                  () => renameFolder(context, entity));
            }),
        PopupMenuItem<String>(
          child: const Text('Delete'),
          value: 'delete',
          onTap: () async {
            await entity.delete(recursive: true);
            setState(() {});
          },
        ),
        PopupMenuItem<String>(
          child: const Text('Upload'),
          value: 'upload',
          onTap: () {},
        ),
      ],
      elevation: 8.0,
    );
  }

  renameFolder(BuildContext context, FileSystemEntity entity) async {
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
                    // print(entity.path.re);
                    await entity.rename(
                        entity.path.replaceRange(20, null, folderName.text));

                    setState(() {});

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
                  child: const Text(
                    'Rename Folder',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  createFolder(BuildContext context) async {
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
                    try {
                      // Create Folder
                      await FileManager.createFolder(
                          controller.getCurrentPath, folderName.text);
                      // Open Created Folder
                      controller.setCurrentPath =
                          controller.getCurrentPath + "/" + folderName.text;
                      print(controller.getCurrentPath);
                    } catch (e) {
                      print(e);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Create Folder',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: const Text("Name"),
                  onTap: () {
                    controller.getSortedBy.name;
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "File Manager",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        actions: [
          IconButton(
            onPressed: () => sort(context),
            icon: const Icon(
              Icons.sort_rounded,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = snapshot;
            return ListView.builder(
              itemCount: entities.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = entities[index];
                return Card(
                  child: ListTile(
                    leading: FileManager.isFile(entity)
                        ? const Icon(Icons.feed_outlined)
                        : const Icon(Icons.folder),
                    title: Text(FileManager.basename(entity)),
                    subtitle: subtitle(entity),
                    onTap: () async {
                      if (FileManager.isDirectory(entity)) {
                        // open the folder
                        controller.openDirectory(entity);

                        // Directory("/storage/emulated/0/Sanju123")
                        //     .delete()
                        //     .then((value) {
                        //   print("Deleted");
                        // });

                        // delete a folder
                        // await entity.delete(recursive: true);

                        // rename a folder
                        // await entity.rename("newPath");

                        // Check weather folder exists
                        // entity.exists();

                        // get date of file
                        // DateTime date = (await entity.stat()).modified;
                      } else {
                        // delete a file
                        // await entity.delete();

                        // rename a file
                        // await entity.rename("newPath");

                        // Check weather file exists
                        // entity.exists();

                        // get date of file
                        // DateTime date = (await entity.stat()).modified;

                        // get the size of the file
                        // int size = (await entity.stat()).size;
                      }
                    },
                    trailing: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _showPopupMenu(context, details.globalPosition, entity);
                      },
                      child: const Icon(
                        Icons.arrow_drop_down_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        child: IconButton(
          onPressed: () => createFolder(context),
          icon:
              const Icon(Icons.create_new_folder_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
