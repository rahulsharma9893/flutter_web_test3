import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController imageUrlController = TextEditingController();
  String imageUrl = "https://via.placeholder.com/300";
  String viewType = "html-image-${DateTime.now().millisecondsSinceEpoch}";

  final GlobalKey _fabKey = GlobalKey();

  void _updateImage() {
    setState(() {
      imageUrl = imageUrlController.text.trim();
      viewType = "html-image-${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  bool isFullScreen = false; // Track fullscreen state

  // Function to toggle fullscreen mode
  void toggleFullScreen() {
    if (isFullScreen) {
      // Exit Fullscreen
      html.document.exitFullscreen();
    } else {
      // Enter Fullscreen
      html.document.documentElement?.requestFullscreen();
    }
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final imageElement = html.ImageElement()
        ..src = imageUrl
        ..style.width = "300px"
        ..style.height = "auto";
      return imageElement;
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center
          ,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                      imageUrlController.text.isEmpty?
                      Colors.grey:Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: InkWell(
                        onDoubleTap: (){
                          html.document.documentElement?.requestFullscreen();
                          // Navigator.pop(context);
                        },
                        child: Center(child: HtmlElementView(viewType: viewType))),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imageUrlController,
//                     onChanged: (value) {
//                      setState(() {
//                        imageUrl=value;
//                      });
//                     },
                    decoration: InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _updateImage,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        key: _fabKey,
          onPressed: (){
            final RenderBox fabRenderBox =
            _fabKey.currentContext!.findRenderObject() as RenderBox;
            final Offset fabPosition = fabRenderBox.localToGlobal(Offset.zero);

            showDialog(
              context: context,
              barrierDismissible: true, // Close dialog when tapping outside
              builder: (context) {
                return Column(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Container(
                         width: 200,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.fullscreen),
                              title: const Text("Enter FullScreen"),
                              onTap: () {
                                html.document.documentElement?.requestFullscreen();
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.fullscreen_exit),
                              title: const Text("Exit FullScreen"),
                              onTap: () {
                                html.document.exitFullscreen();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: fabRenderBox.size.height+20,)
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
      ),
    );
  }


}

