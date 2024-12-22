import 'package:flutter/material.dart';

class ScalableDrawer extends StatefulWidget {
  final Widget child;

  const ScalableDrawer({super.key, required this.child});

  @override
  State<ScalableDrawer> createState() => _ScalableDrawerState();
}

class _ScalableDrawerState extends State<ScalableDrawer>
    with SingleTickerProviderStateMixin {
  late final double _maxSlide;
  late final AnimationController _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _maxSlide = MediaQuery.of(context).size.width * 0.6;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Drawer'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _toggle,
        ),
      ),
      body: GestureDetector(
        // onTap: _toggle,
        onHorizontalDragStart: (details) => _onDragStart(details),
        onHorizontalDragUpdate: (details) => _onDragUpdate(details),
        onHorizontalDragEnd: (details) => _onDragEnd(details),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // slide means the width of the drawer which equals to 70% of the screen width multiplied by the value of the animation controller
            // when the animation controller value is 0, the drawer is closed, and when the value is 1, the drawer is open
            final double slide = _maxSlide * _animationController.value;
            // scale means the scale of the main content which is 1 minus the value of the animation controller multiplied by 0.3
            // when the animation controller value is 0, the scale is 1, and when the value is 1, the scale is 0.7
            // we multiply by 0.3 to make the scale value between 0.7 and 1
            // 0:1 * 0.3 = 0:0.3
            final double scale = 1 - (_animationController.value * 0.3);
            return Stack(
              children: <Widget>[
                const DrawerBody(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: widget.child,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animationController.isDismissed && details.globalPosition.dx < 50;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > _maxSlide - 50;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / _maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _maxSlide;
      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}

class DrawerBody extends StatelessWidget {
  const DrawerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
