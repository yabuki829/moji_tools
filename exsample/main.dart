import 'package:moji_tools/moji_tools.dart';

void main() {
  print(MojiTools.toFullWidth('Hello World! 123'));
  print(MojiTools.toHalfWidth('Ｈｅｌｌｏ　Ｗｏｒｌｄ！　１２３'));
  print(MojiTools.toZenkakuKana('ｶﾀｶﾅ ﾃｽﾄ'));
  print(MojiTools.toHankakuKana('カタカナ　テスト'));
}
