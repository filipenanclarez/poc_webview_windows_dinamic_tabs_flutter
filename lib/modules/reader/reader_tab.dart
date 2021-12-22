import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/reader_page.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/webview_all.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ReaderTab extends StatefulWidget {
  const ReaderTab({Key? key}) : super(key: key);

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<ReaderTab> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // List<memodu.Page> data = [memodu.Page()];

  List<ReaderPage> data = [ReaderPage(indexKey: '1')];

  int initPosition = 0;
  int keyCount = 1;

  // final webVieWallKey = GlobalKey<WebViewAllState>();

  static final _myTabbedPageKey = new GlobalKey<_CustomTabsState>();

  @override
  Widget build(BuildContext context) {
    // // return Container(child: Text('data'),);
    debugPrint(Theme.of(context).platform.toString());

    return CustomTabView(
      key: _myTabbedPageKey,
      initPosition: initPosition,
      itemCount: data.length,
      tabBuilder: (context, index) {
        if (index == 0) {
          return Container(
            child: Tab(icon: Icon(MaterialCommunityIcons.bookshelf)),
            padding: EdgeInsets.symmetric(horizontal: 10),
          );
        } else {
          return Container(
            child: Tab(
              child: Text('${data[index].key}'),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
          );
        }
      },
      pageBuilder: (context, index) {
        if (index == 0) {
          return Center(
            child: Container(
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  // debugPrint(Theme.of(context).platform.toString());

                  // debugPrint('apos abrir a aba');
                  // _myTabbedPageKey.currentState?.controller!.animateTo(1);

                  data.insert(
                      1,
                      ReaderPage(
                          key: Key(keyCount.toString()),
                          indexKey: keyCount.toString()));
                  keyCount++;
                  // initPosition = 1;
                  setState(() {});
                  _myTabbedPageKey.currentState?.afterLoad = (_){                    
                    _myTabbedPageKey.currentState?.controller!.animateTo(1);
                  };                                    
                },
              ),
            ),
          );
        } else {
          return data[index];
        }
      },
      onPositionChange: (index) {
        // print('current position: $index');
        debugPrint('onPositionChange');
        initPosition = index;
      },
    );

    // return NotificationListener<MyNotification>(
    //   child: WebViewAll(
    //     key: webVieWallKey,
    //     url: 'http://uol.com.br',
    //   ),
    //   onNotification: (notificationObj) { //aqui chega o evendo que vem das webviews
    //     debugPrint(notificationObj.mensagem);
    //     return false;
    //   },
    // );

    // return Scaffold(
    //   body: Container(
    //     child: Text('data'),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.textsms_sharp),
    //     backgroundColor: Colors.blue,
    //     onPressed: () {
    //       //do something on press
    //       debugPrint('alert ("teste2")');
    //       print('teste');
    //     },
    //   ),
    // );
  }
}

// classe customizada de notificação para receber o callback dos webviews com o notifylistener
class MyNotification extends Notification {
  String mensagem;

  MyNotification(this.mensagem);
}

// tabview customizada

class CustomTabView extends StatefulWidget {
  final int? itemCount;
  final IndexedWidgetBuilder? tabBuilder;
  final IndexedWidgetBuilder? pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  CustomTabView({
    Key? key,
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  }) : super(key: key);

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController? controller;
  int? _currentCount;
  int? _currentPosition;
   
  var afterLoad;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount!,
      vsync: this,
      initialIndex: _currentPosition!,
    );
    controller!.addListener(onPositionChange);
    //controller!.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    debugPrint(' _currentPosition: $_currentPosition');
    debugPrint(' _currentCount: $_currentCount');
    debugPrint(' widget.itemCount: ${widget.itemCount}');

    if (_currentCount != widget.itemCount) {
      debugPrint("DID UPDATE POSITION : 0");
      //print('_currentCount != widget.itemCount');
      //controller!.animation!.removeListener(onScroll);
      controller!.removeListener(onPositionChange);
      controller!.dispose();

      if (widget.initPosition != null) {
        print("DID UPDATE POSITION : 1");
        _currentPosition = widget.initPosition;
        WidgetsBinding.instance!.addPostFrameCallback(afterLoad);
        //   ((_) {
        //   debugPrint('atualizei a lista');
        //   print(widget.initPosition);
        //   print(_currentPosition);
        //   controller!.animateTo(1); 

        // });
      }

      if (_currentPosition! > widget.itemCount! - 1) {
        debugPrint("DID UPDATE POSITION : 2");

        _currentPosition = widget.itemCount! - 1;
        _currentPosition = _currentPosition! < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            debugPrint('addPostFrameCallback');
            if (mounted) {
              print("DID UPDATE POSITION : 4");
              widget.onPositionChange!(_currentPosition!);
            }
          });
        }
      }

      // controller!.animateTo(_currentPosition!);
      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount!,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller!.addListener(onPositionChange);
      });

      // if (_currentCount! < widget.itemCount!) {
      //   controller!.animation!.addStatusListener((status) {
      //     debugPrint('addStatusListener $status');
      //     if (status == AnimationStatus.completed) {
      //       debugPrint('completou a mudança');
      //     }
      //   });
      //   controller!.animation!.addListener(() {
      //     debugPrint('apos mudar a pagina ${controller!.indexIsChanging}');
      //   });

      //   debugPrint('mudando a pagina');
      //   // controller!.animateTo(1);
      //   // controller!.animateTo(_currentPosition!);
      // } else {
      //   debugPrint('não mudei a pagina');
      // }

      // //controller!.animation!.addListener(onScroll);

      // //controller!.animateTo(_currentPosition!);

      // // controller!.animateTo(widget.itemCount! - 1);
      // debugPrint('# _currentPosition: $_currentPosition');
      // debugPrint('# _currentCount: $_currentCount');
      // debugPrint('# widget.itemCount: ${widget.itemCount}');

      // setState(() {});
    } else if (widget.initPosition != null) {
      controller!.animateTo(widget.initPosition!);
      debugPrint('mudança de pagina inicial');
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    debugPrint('dispose do tab');
    // controller!.animation!.removeListener(onScroll);
    controller!.removeListener(onPositionChange);
    controller!.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount! < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: List.generate(
              widget.itemCount!,
              (index) => widget.pageBuilder!(context, index),
            ),
          ),
        ),
        Container(
          // color: Colors.blue,
          alignment: Alignment.centerLeft,
          child: Container(
            // color: Colors.grey,
            child: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 0),
              isScrollable: true,
              controller: controller,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              tabs: List.generate(
                widget.itemCount!,
                (index) => widget.tabBuilder!(context, index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller!.indexIsChanging) {
      _currentPosition = controller!.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition!);
      }
    }
  }
}
