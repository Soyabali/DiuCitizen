import 'package:flutter/material.dart';

import '../../app/generalFunction.dart';


import 'package:flutter/material.dart';

class FullScreenImages extends StatelessWidget {
  final String image;

  const FullScreenImages({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    debugPrint("---15-----image url---$image");

    return Scaffold(
      appBar: AppBar(
        title: const Text('IMAGES'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: image,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class FullScreenImages extends StatelessWidget {
//   final String image;
//
//   FullScreenImages({super.key, required this.image});
//
//
//   @override
//   Widget build(BuildContext context) {
//     var title = "Title";
//
//     print("---15-----image url---$image");
//     return Scaffold(
//       appBar: getAppBarBack(context, 'IMAGES'),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Hero(
//                   tag: image,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.5),
//                           blurRadius: 10.0,
//                           spreadRadius: 5.0,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20.0),
//                       child: Image.network(
//                         image,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Center(child: Text('Failed to load image'));
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               right: 10,
//               child: IconButton(
//                 icon: Icon(Icons.close, color: Colors.red),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
