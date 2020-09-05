class ARGB {
  static int alpha(int code) => (0xff000000 & code) >> 24;
  static int red(int code)  => (0x00ff0000 & code) >> 16;
  static int green(int code) => (0x0000ff00 & code) >> 8;
  static int blue(int code) => (0x000000ff & code) >> 0;
  static int argb(int a, int r, int g, int b) {
    return 0x00 |
        ((a << 24) & 0xff000000 )|  
        ((r << 16) & 0x00ff0000 )|  
        ((g << 8) & 0x0000ff00 )| 
        ((b << 0) & 0x000000ff );
  }
}
main() {
  print("${ARGB.argb(255,255,255,255)}");
}