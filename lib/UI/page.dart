import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

/// This is the class which contains the Page UI.
class Page extends StatelessWidget {
  ///page details
  final PageViewModel pageViewModel;

  ///percent visible of page
  final double percentVisible;

  /// [MainAxisAligment]
  final MainAxisAlignment columnMainAxisAlignment;

  final VoidCallback? onPressedDoneButton; //Callback for Done Button
  final bool last;

  //Constructor
  Page({
    required this.pageViewModel,
    this.percentVisible = 1.0,
    this.columnMainAxisAlignment = MainAxisAlignment.spaceAround,
    this.onPressedDoneButton,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: pageViewModel.type == PageType.imageOnly
          ? const EdgeInsets.symmetric(vertical: 8.0)
          : pageViewModel.type == PageType.fullscreen
              ? const EdgeInsets.all(0.0)
              : const EdgeInsets.all(8.0),
      //width: double.infinity,
      color: pageViewModel.pageColor,
      child: new Opacity(
        //Opacity is used to create fade in effect
        opacity: percentVisible,
        child: new OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitPage()
              : __buildLandscapePage();
        }), //OrientationBuilder
      ),
    );
  }

  /// when device is Portrait place title, image and body in a column
  Widget _buildPortraitPage() {
    switch (pageViewModel.type) {
      case PageType.imageOnly:
        return Center(
          child: _ImagePageTransform(
            percentVisible: percentVisible,
            pageViewModel: pageViewModel,
          ),
        );

      case PageType.fullscreen:
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                _ImagePageTransform(
                  percentVisible: percentVisible,
                  pageViewModel: pageViewModel,
                ),
                Positioned(
                  left: 32.0,
                  width: constraints.maxWidth * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _TitlePageTransform(
                        percentVisible: percentVisible,
                        pageViewModel: pageViewModel,
                      ),
                      const SizedBox(height: 32.0),
                      _BodyPageTransform(
                        percentVisible: percentVisible,
                        pageViewModel: pageViewModel,
                      ),
                      const SizedBox(height: 32.0),
                      last
                          ? _ButtonPageTransform(
                              percentVisible: percentVisible,
                              pageViewModel: pageViewModel,
                              onPressed: onPressedDoneButton,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            );
          },
        );

      case PageType.normal:
        return Column(
          mainAxisAlignment: columnMainAxisAlignment,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Flexible(
              flex: 4,
              child: new _ImagePageTransform(
                percentVisible: percentVisible,
                pageViewModel: pageViewModel,
              ),
            ), //Transform
            Flexible(
              flex: 2,
              child: new _TitlePageTransform(
                percentVisible: percentVisible,
                pageViewModel: pageViewModel,
              ),
            ),
            Flexible(
              flex: 2,
              child: new _BodyPageTransform(
                percentVisible: percentVisible,
                pageViewModel: pageViewModel,
              ),
            ), //Transform
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Container(
              height: 75,
            ),
          ],
        );
    }
  }

  /// if Device is Landscape reorder with row and column
  Widget __buildLandscapePage() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: _ImagePageTransform(
            percentVisible: percentVisible,
            pageViewModel: pageViewModel,
          ),
        ), //Transform
        Flexible(
          child: Column(
            mainAxisAlignment: columnMainAxisAlignment,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _TitlePageTransform(
                percentVisible: percentVisible,
                pageViewModel: pageViewModel,
              ),
              _BodyPageTransform(
                percentVisible: percentVisible,
                pageViewModel: pageViewModel,
              ), //Transform
            ],
          ), // Column
        ),
      ],
    );
  }
}

class _ButtonPageTransform extends StatelessWidget {
  final double percentVisible;
  final PageViewModel pageViewModel;
  final VoidCallback? onPressed;

  const _ButtonPageTransform({
    Key? key,
    required this.percentVisible,
    required this.pageViewModel,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform:
          new Matrix4.translationValues(0.0, 30.0 * (1 - percentVisible), 0.0),
      child: TextButton(
        onPressed: onPressed ?? () {},
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            backgroundColor: pageViewModel.buttonColor != null
                ? MaterialStateProperty.all<Color>(pageViewModel.buttonColor!)
                : null),
        child: pageViewModel.buttonText,
      ),
    );
  }
}

/// Body for the Page.
class _BodyPageTransform extends StatelessWidget {
  final double percentVisible;

  final PageViewModel pageViewModel;

  const _BodyPageTransform({
    Key? key,
    required this.percentVisible,
    required this.pageViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Transform(
      //Used for vertical transformation
      transform:
          new Matrix4.translationValues(0.0, 30.0 * (1 - percentVisible), 0.0),
      child: pageViewModel.type == PageType.normal
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: DefaultTextStyle.merge(
                style: pageViewModel.bodyTextStyle,
                textAlign: TextAlign.center,
                child: pageViewModel.body,
              ),
            )
          : DefaultTextStyle.merge(
              style: pageViewModel.bodyTextStyle,
              child: pageViewModel.body,
            ),
    );
  }
}

/// Main Image of the Page
class _ImagePageTransform extends StatelessWidget {
  final double percentVisible;

  final PageViewModel pageViewModel;

  const _ImagePageTransform({
    Key? key,
    required this.percentVisible,
    required this.pageViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Transform(
      //Used for vertical transformation
      transform:
          new Matrix4.translationValues(0.0, 50.0 * (1 - percentVisible), 0.0),
      child: pageViewModel.type == PageType.normal
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: pageViewModel.mainImage,
            ) //Loading main
          : pageViewModel.mainImage,
    );
  }
}

/// Title for the Page
class _TitlePageTransform extends StatelessWidget {
  final double percentVisible;

  final PageViewModel pageViewModel;

  const _TitlePageTransform({
    Key? key,
    required this.percentVisible,
    required this.pageViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Transform(
      //Used for vertical transformation
      transform:
          new Matrix4.translationValues(0.0, 30.0 * (1 - percentVisible), 0.0),
      child: DefaultTextStyle.merge(
        style: pageViewModel.titleTextStyle,
        child: pageViewModel.title,
      ), //Padding
    );
  }
}
