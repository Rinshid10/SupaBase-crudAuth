import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one/view/AddPage/addpage.dart';
import 'package:one/view/EditPage/editpage.dart';
import 'package:one/view/iamgeView/imageView.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';

class HompePage extends StatefulWidget {
  const HompePage({super.key});

  @override
  State<HompePage> createState() => _HompePageState();
}

class _HompePageState extends State<HompePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Userproivder>(context, listen: false).getalldat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ImageProviders>(context, listen: false).getImage();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Imageview()));
              },
              icon: Icon(Icons.delete))
        ],
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addpage()))),
      body: Consumer2<Userproivder, ImageProviders>(
        builder: (context, value, imagesProviders, child) {
          return ListView.builder(
            itemCount: value.listData.length,
            itemBuilder: (context, index) {
              final datas = value.listData[index];
              final images = imagesProviders.imagesAll[index];
              log('${datas.username}');
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Editpage(
                              password: datas.password,
                              username: datas.username,
                              id: datas.id,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Image.network(
                          images,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text('Failed to load image'),
                            );
                          },
                        ),
                      ),
                      title: Text(datas.username ?? 'no name found'),
                      subtitle: Text(datas.password ?? 'no password found'),
                      trailing: IconButton(
                          onPressed: () {
                            value.deleteData(datas.id!);
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
