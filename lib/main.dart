import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_1/data/model/album_model.dart';
import 'package:flutter_layout_1/data/service/album_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Crud',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  final TextEditingController _controller = TextEditingController();
  late Future<Album>? _futureAlbum;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter CRUD"),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(
                iconData: Icons.home,
                title: "Get Album",
                onclick: () {
                  final FancyBottomNavigationState fState = bottomNavigationKey
                      .currentState as FancyBottomNavigationState;
                  fState.setPage(0);
                }),
            TabData(
                iconData: Icons.add,
                title: "Add Album",
                onclick: () {
                  final FancyBottomNavigationState fState = bottomNavigationKey
                      .currentState as FancyBottomNavigationState;
                  fState.setPage(1);
                }),
            TabData(
                iconData: Icons.update,
                title: "Update Album",
                onclick: () {
                  final FancyBottomNavigationState fState = bottomNavigationKey
                      .currentState as FancyBottomNavigationState;
                  fState.setPage(2);
                }),
            TabData(
                iconData: Icons.delete,
                title: "Delete Album",
                onclick: () {
                  final FancyBottomNavigationState fState = bottomNavigationKey
                      .currentState as FancyBottomNavigationState;
                  fState.setPage(3);
                }),
          ],
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ));
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return getAlbumSection();
      case 1:
        return addAlbumSection();
      case 2:
        return updateAlbumSection();
      case 3:
        return deleteAlbumSection();
      default:
        return const Center(
          child: Text("Nothing to display, sorry !"),
        );
    }
  }

  FutureBuilder<Album> getAlbumSection() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data?.title ?? 'Album deleted');
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  FutureBuilder<Album> deleteAlbumSection() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        // If the connection is done,
        // check for response data or an error.
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(snapshot.data?.title ?? 'Album deleted'),
                ElevatedButton(
                  child: const Text('Delete album'),
                  onPressed: () {
                    setState(() {
                      _futureAlbum = deleteAlbum(snapshot.data!.id.toString());
                    });
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Padding addAlbumSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter Title'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _futureAlbum = createAlbum(_controller.text);
              });
            },
            child: const Text('Create album'),
          ),
        ],
      ),
    );
  }

  Padding updateAlbumSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Album>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data?.title ?? 'Enter new title'),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureAlbum = updateAlbum(_controller.text);
                        });
                      },
                      child: const Text('Update Data'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
