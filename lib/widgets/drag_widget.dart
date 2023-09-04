import 'package:dating_app/widgets/cards_stack_widget.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/model/profile.dart';
import 'package:dating_app/widgets/profile_card.dart';
import 'package:dating_app/widgets/tag_widget.dart';
import 'package:dating_app/main.dart';

class DragWidget extends StatefulWidget {
  const DragWidget({
    Key? key,
    required this.profile,
    required this.index,
    required this.swipeNotifier,
    this.isLastCard = false,
  }) : super(key: key);

  final Profile profile;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;
  final bool isLastCard;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Draggable<int>(
        // Data is the value this Draggable stores.
        data: widget.index,
        feedback: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder(
            valueListenable: widget.swipeNotifier,
            builder: (context, swipe, _) {
              return RotationTransition(
                turns: widget.swipeNotifier.value != Swipe.none
                    ? widget.swipeNotifier.value == Swipe.left
                        ? const AlwaysStoppedAnimation(-15 / 360)
                        : widget.swipeNotifier.value == Swipe.right
                            ? const AlwaysStoppedAnimation(15 / 360)
                            : const AlwaysStoppedAnimation(0)
                    : const AlwaysStoppedAnimation(0),
                child: Stack(
                  children: [
                    ProfileCard(profile: widget.profile),
                    widget.swipeNotifier.value != Swipe.none
                        ? swipe == Swipe.right
                            ? Positioned(
                                top: 40,
                                left: 20,
                                child: Transform.rotate(
                                  angle: 12,
                                  child: TagWidget(
                                    text: 'LIKE',
                                    color: Colors.green[400]!,
                                  ),
                                ),
                              )
                            : swipe == Swipe.left
                                ? Positioned(
                                    top: 50,
                                    right: 24,
                                    child: Transform.rotate(
                                      angle: -12,
                                      child: TagWidget(
                                        text: 'DISLIKE',
                                        color: Colors.red[400]!,
                                      ),
                                    ),
                                  )
                                : swipe == Swipe.top
                                    ? Positioned(
                                        top: 0,
                                        left: 0,
                                        child: TagWidget(
                                          text: 'TOP',
                                          color: Colors.blue[400]!,
                                        ),
                                      )
                                    : Positioned(
                                        top: 0,
                                        left: 0,
                                        child: TagWidget(
                                          text: 'BOTTOM',
                                          color: Colors.orange[400]!,
                                        ),
                                      )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
        onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          if (dragUpdateDetails.delta.dx > 0 &&
              dragUpdateDetails.globalPosition.dx >
                  MediaQuery.of(context).size.width / 2) {
            widget.swipeNotifier.value = Swipe.right;
          }
          if (dragUpdateDetails.delta.dx < 0 &&
              dragUpdateDetails.globalPosition.dx <
                  MediaQuery.of(context).size.width / 2) {
            widget.swipeNotifier.value = Swipe.left;
          }
          if (dragUpdateDetails.delta.dy < 0 &&
              dragUpdateDetails.globalPosition.dy <
                  MediaQuery.of(context).size.height / 2) {
            widget.swipeNotifier.value = Swipe.top;
          }
          if (dragUpdateDetails.delta.dy > 0 &&
              dragUpdateDetails.globalPosition.dy >
                  MediaQuery.of(context).size.height / 2) {
            widget.swipeNotifier.value = Swipe.bottom;
          }
        },
        onDragEnd: (drag) {
          widget.swipeNotifier.value = Swipe.none;
        },

        childWhenDragging: Container(
          color: Colors.transparent,
        ),

        // This will be visible when we press action button
        child: ValueListenableBuilder(
          valueListenable: widget.swipeNotifier,
          builder: (BuildContext context, Swipe swipe, Widget? child) {
            return Stack(
              children: [
                ProfileCard(profile: widget.profile),
                // Check if this is the last card and Swipe is not equal to Swipe.none
                swipe != Swipe.none && widget.isLastCard
                    ? swipe == Swipe.right
                        ? Positioned(
                            top: 40,
                            left: 20,
                            child: Transform.rotate(
                              angle: 12,
                              child: TagWidget(
                                text: 'LIKE',
                                color: Colors.green[400]!,
                              ),
                            ),
                          )
                        : swipe == Swipe.left
                            ? Positioned(
                                top: 50,
                                right: 24,
                                child: Transform.rotate(
                                  angle: -12,
                                  child: TagWidget(
                                    text: 'DISLIKE',
                                    color: Colors.red[400]!,
                                  ),
                                ),
                              )
                            : swipe == Swipe.top
                                ? Positioned(
                                    top: 0,
                                    left: 0,
                                    child: TagWidget(
                                      text: 'TOP',
                                      color: Colors.blue[400]!,
                                    ),
                                  )
                                : Positioned(
                                    top: 0,
                                    left: 0,
                                    child: TagWidget(
                                      text: 'BOTTOM',
                                      color: Colors.orange[400]!,
                                    ),
                                  )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
