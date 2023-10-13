import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CenteredText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

class AnimatedAddButton extends StatefulWidget {
  final bool isExpanding;
  final Function onTap;

  const AnimatedAddButton(
      {super.key, required this.isExpanding, required this.onTap});

  @override
  AnimatedAddButtonState createState() => AnimatedAddButtonState();
}

class AnimatedAddButtonState extends State<AnimatedAddButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap as void Function()?,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        width:
            widget.isExpanding ? MediaQuery.of(context).size.width - 40 : 140,
        height: 50,
        decoration: BoxDecoration(
          color: widget.isExpanding ? Colors.white : Colors.black,
          border: widget.isExpanding ? Border.all(color: Colors.grey) : null,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: widget.isExpanding
            ? Row(
                children: [
                  const SizedBox(width: 15.0),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 5.0),
                  Text(
                    'Add item',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
