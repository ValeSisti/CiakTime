import 'package:ciak_time/constants.dart';

double heightCarouselContainer() {
  double heightCarouselContainer;
  if (isPortrait) {
    heightCarouselContainer = 410.0;
  } else {
    heightCarouselContainer = 290;
  }
  return heightCarouselContainer;
}

double heightCarousel() {
  double heightCarousel;
  if (isPortrait) {
    heightCarousel = 300;
  } else {
    heightCarousel = 300;
  }
  return heightCarousel;
}

double widthCarousel() {
  double widthCarousel;
  if (isPortrait) {
    widthCarousel = 300;
  } else {
    widthCarousel = 400;
  }
  return widthCarousel;
}

double heightSizedBox1() {
  double heightSizedBox;
  if (isPortrait) {
    heightSizedBox = 30;
  } else {
    heightSizedBox = 5;
  }
  return heightSizedBox;
}

double heightSizedBox2() {
  double heightSizedBox;
  if (isPortrait) {
    heightSizedBox = 300;
  } else {
    heightSizedBox = 200;
  }
  return heightSizedBox;
}

double setRatio() {
  double ratio;
  if (isPortrait) {
    ratio = 0.85;
  } else {
    ratio = 0.7;
  }
  return ratio;
}

double setViewportFraction() {
  double viewportFraction;
  if (isPortrait) {
    viewportFraction = 0.8;
  } else {
    viewportFraction = 0.6;
  }
  return viewportFraction;
}

double heightBoxDecoration() {
  double heightBoxDecoration;
  if (isPortrait) {
    heightBoxDecoration = 100;
  } else {
    heightBoxDecoration = 70;
  }
  return heightBoxDecoration;
}
