import 'package:image/image.dart' as img;

img.Image rotate({img.Image image,int angle}){
  img.Image ima = img.copyRotate(image, angle);
  return ima;
}