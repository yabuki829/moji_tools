import 'package:flutter_test/flutter_test.dart';
import 'package:moji_tools/moji_tools.dart';

void main() {
  group('MojiTools basic width conversion', () {
    test('toFullWidth converts ASCII to full-width', () {
      expect(MojiTools.toFullWidth('abc123!?'), 'ａｂｃ１２３！？');
      expect(MojiTools.toFullWidth('Hello World! 123'), 'Ｈｅｌｌｏ　Ｗｏｒｌｄ！　１２３');
    });

    test('toHalfWidth converts full-width ASCII to half-width', () {
      expect(MojiTools.toHalfWidth('ａｂｃ１２３！？'), 'abc123!?');
      expect(MojiTools.toHalfWidth('Ｈｅｌｌｏ　Ｗｏｒｌｄ！　１２３'), 'Hello World! 123');
    });
  });

  group('MojiTools Kana conversion', () {
    test('toZenkakuKana converts half-width Kana to full-width', () {
      expect(MojiTools.toZenkakuKana('ｶﾀｶﾅ ﾃｽﾄ'), 'カタカナ　テスト');
      expect(MojiTools.toZenkakuKana('ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ'), 'パピプペポ');
      expect(MojiTools.toZenkakuKana('ｳﾞｧｲｪｰｲ｡､｢｣'), 'ヴァイェーイ。、「」');
    });

    test('toHankakuKana converts full-width Kana to half-width', () {
      expect(MojiTools.toHankakuKana('カタカナ　テスト'), 'ｶﾀｶﾅ ﾃｽﾄ');
      expect(MojiTools.toHankakuKana('パピプペポ'), 'ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ');
      expect(MojiTools.toHankakuKana('ヴァイェーイ。、「」'), 'ｳﾞｧｲｪｰｲ｡､｢｣');
    });
  });
}
