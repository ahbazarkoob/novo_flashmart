import 'package:flutter/material.dart';
import 'package:novo_instamart/util/dimensions.dart';
import 'package:novo_instamart/util/styles.dart';

class MinMaxTimePickerWidget extends StatefulWidget {
  final List<String> times;
  final Function(int index) onChanged;
  final int initialPosition;
  const MinMaxTimePickerWidget(
      {super.key,
      required this.times,
      required this.onChanged,
      required this.initialPosition});

  @override
  State<MinMaxTimePickerWidget> createState() => _MinMaxTimePickerWidgetState();
}

class _MinMaxTimePickerWidgetState extends State<MinMaxTimePickerWidget> {
  int selectedIndex = 10;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.3,
      initialPage: widget.initialPosition,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 70,
        height: 100,
        decoration: BoxDecoration(
          border:
              Border.all(color: Theme.of(context).disabledColor, width: 0.5),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.times.length,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
            widget.onChanged(index);
          },
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Center(
                  child: Text(
                widget.times[index].toString(),
                style: selectedIndex == index
                    ? figTreeBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge)
                    : figTreeRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
              )),
            );
          },
        ));
  }
}
