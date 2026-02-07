import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget{
  final Widget body;
  final String? title;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showAppBar;

  const BackgroundWidget({
    super.key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.actions,
    this.floatingActionButton,
    this.showAppBar = true
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: showAppBar ? AppBar(
              title: title != null ? Text(title!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)) : null,
              backgroundColor: Colors.white.withOpacity(0.9), // Hơi trong suốt
              elevation: 0,
              centerTitle: true,
              actions: actions,
              iconTheme: const IconThemeData(color: Colors.blue),
      ) : null,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // 1. Layer background mờ
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                //Cách 1: Dùng ảnh
                image: DecorationImage(
                  image: AssetImage('assets/images/thumbnail.png'),
                  fit: BoxFit.cover,
                  opacity: 0.1, // Độ mờ 10%
                ),

                // Cách 2: Dùng Gradient
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF0F8FF), // AliceBlue (nhạt)
                    Color(0xFFE6F3FF), // Xanh rất nhạt
                  ],
                ),

              ),
            ),
          ),

          // 2. Layer nội dung chinhs
          SafeArea(
            top: !showAppBar, 
            child: body,
          )
        ],
      ),
    );
  }
}