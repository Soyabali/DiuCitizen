import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';

class FullScreenImagesComplaintList extends StatelessWidget {

  final String image, sResolvePhoto;

  FullScreenImagesComplaintList({
    super.key,
    required this.image,
    required this.sResolvePhoto,
  });

  @override
  Widget build(BuildContext context) {
    // Build the list of images
    List<String> imageList = [image];
    if (sResolvePhoto.isNotEmpty) {
      imageList.add(sResolvePhoto);
    }

    return Scaffold(
      appBar: getAppBarBack(context, 'IMAGES'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // PageView for images
            Positioned.fill(
              child: PageView.builder(
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  final currentImage = imageList[index];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Hero(
                      tag: currentImage,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            currentImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text('Failed to load image'),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Close icon
            Positioned(
              top: 20,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
