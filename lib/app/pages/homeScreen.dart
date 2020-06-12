import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var parser = EmojiParser();
  double maxheight = 200;

  TextEditingController readOnly = TextEditingController();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            if (boxConstraints.maxWidth < 900) {
              return Center(
                child: Text("Screen size is too small, please try in bigger screen"),
              );
            } else {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // * title name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Emoji Translator",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      // * text to emoji converter
                      buildEditor(context),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Center buildEditor(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.4,
          height: maxheight,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              _textToEmojiEditor(),
              Container(
                height: maxheight,
                width: 0.2,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.grey.shade400),
              ),
              _textToEmojiResult(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _textToEmojiResult() {
    return Expanded(
      child: Stack(
        children: [
          TextField(
            controller: readOnly,
            readOnly: true,
            maxLines: 25,
            decoration: InputDecoration(
                hintText: "I ❤ you",
                border: InputBorder.none,
                fillColor: Colors.grey.shade100,
                filled: true),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: FlatButton.icon(
              color: Theme.of(context).primaryColor,
              onPressed: readOnly.text == ""
                  ? null
                  : () => fetchClipboard(value: readOnly),
              icon: Icon(Icons.bookmark, color: Colors.white),
              label: Text(
                "Copy",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _textToEmojiEditor() {
    return Expanded(
      child: TextField(
        onChanged: (String value) {
          setState(() {
            readOnly.text = parser.emojify(value);
          });
        },
        maxLines: 25,
        decoration: InputDecoration(
            hintText: "I :heart: you", border: InputBorder.none),
      ),
    );
  }

  void showSnackbar() {
    _key.currentState.showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
          content: Text("Copid to clipboard",
              style: TextStyle(
                color: Colors.white,
              ))),
    );
  }

  Future<void> fetchClipboard({TextEditingController value}) async {
    await Clipboard.setData(ClipboardData(text: value.text));
    showSnackbar();
  }
}
