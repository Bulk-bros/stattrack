import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:stattrack/styles/palette.dart';

/// A custom body that contains a header and a body, places the header within a theme box
/// and the body is placed in a ColumnSuper overlapping the theme box
/// [header] A widget to be placed on top of the body, acting as a header
/// [bodyWidgets] A list of widgets that is to be placed in the body (ColumnSuper
/// )
class CustomBody extends StatelessWidget {
  CustomBody({Key? key, required this.header, required this.bodyWidgets})
      : super(key: key);

  Widget header;
  List<Widget> bodyWidgets;

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(
      height: 20,
    );
    return SingleChildScrollView(
      child: ColumnSuper(
        innerDistance: -55,
        children: [
          _buildBodyHeader(header),
          spacing,
          _buildBodyContent([...bodyWidgets])
        ],
      ),
    );
  }

  Widget _buildBodyContent(List<Widget> bodyWidgets) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...bodyWidgets],
      ),
    );
  }

  //Theme box
  //Takes a widget parameter which is the body to be displayed on top
  //Widget makes sure the body has a padding
  Widget _buildBodyHeader(Widget body) {
    return Container(
      height: 320,
      width: 1000,
      decoration: BoxDecoration(
        color: Palette.accent[400],
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: body,
      ),
    );
  }
}
