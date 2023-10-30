import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "dart:io";
import "package:fluttertoast/fluttertoast.dart";
import "package:path/path.dart" as path;
import "package:taletime/internationalization/localizations_ext.dart";
import "package:url_launcher/url_launcher.dart";

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  late String _localPath; // Variable to store the local path

  @override
  void initState() {
    super.initState();
    _initializeLocalPath(); // Initialize the local path once at the beginning
  }

  Future<void> _initializeLocalPath() async {
    _localPath = await getLocalPath();
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body: FutureBuilder<List<String>>(
        future: _getDownloadedFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final downloadedFiles = snapshot.data!;
            return ListView.builder(
              itemCount: downloadedFiles.length,
              itemBuilder: (context, index) {
                final filePath = path.join(_localPath, downloadedFiles[index]);

                return ListTile(
                  title: Text(downloadedFiles[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.folder_open),
                        onPressed: () {
                          _openFileLocation(filePath);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteStory(context, downloadedFiles[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.noDownloadedStories));
          }
        },
      ),
    );
  }

  Future<List<String>> _getDownloadedFiles() async {
    final localPath = await getLocalPath();
    final directory = Directory(localPath);
    final List<String> downloadedFiles = [];

    if (await directory.exists()) {
      final files = directory.listSync();
      for (var file in files) {
        if (file is File) {
          downloadedFiles.add(path.basename(file.path));
        }
      }
    }

    return downloadedFiles;
  }

  void _openFileLocation(String filePath) async {
    if (await File(filePath).exists()) {
      final directoryPath = path.dirname(filePath);
      final directory = Directory(directoryPath);
      print(directory);
      if (await directory.exists()) {
        try {
          await launchUrl(Uri.parse(directoryPath));
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Failed to open directory",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Directory not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "File not found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _deleteStory(BuildContext context, String fileName) async {
    final localPath = await getLocalPath();
    final filePath = path.join(localPath, fileName);

    try {
      if (await File(filePath).exists()) {
        await File(filePath).delete();
        Fluttertoast.showToast(
          msg: "File deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Story deleted successfully"),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {}); //trigger update
      } else {
        Fluttertoast.showToast(
          msg: "File not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to delete story: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
