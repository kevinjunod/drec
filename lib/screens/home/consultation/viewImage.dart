import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

class ViewImage extends StatelessWidget {
  final String path;
  final String name;
  final String time;
  const ViewImage(this.path, this.name, this.time, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                await ImageDownloader.downloadImage(path);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Success download file'),
                  backgroundColor: Colors.green,
                  elevation: 6,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                ));
              },
              icon: Icon(Icons.save_alt_outlined),
              tooltip: 'Download Image',
            )
          ],
        ),
      ),
      backgroundColor: Colors.black.withOpacity(.5),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 2,
          child: Image.network(path, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
