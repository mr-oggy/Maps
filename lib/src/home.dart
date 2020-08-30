import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maps/models/post_model.dart';

import 'package:share/share.dart';

import 'bloc.dart';
import 'my_maps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Bloc _bloc = Bloc();

  @override
  void initState() {
    super.initState();
    _bloc.init();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SwipListView'),
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: _bloc.posts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, index) {
              return Slidable(
                key: UniqueKey(),
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: [
                  IconSlideAction(
                    color: Colors.blue.shade300,
                    iconWidget: Icon(Icons.thumb_up, color: Colors.white),
                    closeOnTap: false,
                    onTap: () {
                      Share.share(
                        '${snapshot.data[index].title}',
                      );
                    },
                  ),
                  IconSlideAction(
                    color: Colors.red.shade300,
                    iconWidget: Icon(Icons.delete, color: Colors.white),
                    closeOnTap: true,
                    onTap: () {
                      _bloc.removeData(index);
                    },
                  ),
                ],
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (SlideActionType type) {
                    if (type == SlideActionType.secondary) {
                      _bloc.removeData(index);
                    }
                  },
                ),
                child: ListTile(
                  title: Text(
                    snapshot.data[index].title,
                    style: TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyMaps(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
