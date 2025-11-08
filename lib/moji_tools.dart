library moji_tools;

/// 日本語テキスト/ASCII の全角・半角/カナ変換ユーティリティ
class MojiTools {
  // ===============================================================
  // =============== ASCII 幅変換（英数字・記号・空白） ===============
  // ===============================================================

  /// 半角ASCII(0x21-0x7E)と半角スペース(0x20)を全角へ
  static String toFullWidth(String text) {
    final out = StringBuffer();
    for (final r in text.runes) {
      // 半角ASCII記号・英数字
      if (r >= 0x21 && r <= 0x7E) {
        out.writeCharCode(r + 0xFEE0);
      }
      // 半角スペース -> 全角スペース
      else if (r == 0x20) {
        out.writeCharCode(0x3000);
      } else {
        out.writeCharCode(r);
      }
    }
    return out.toString();
  }

  /// 全角ASCII(0xFF01-0xFF5E)と全角スペース(0x3000)を半角へ
  static String toHalfWidth(String text) {
    final out = StringBuffer();
    for (final r in text.runes) {
      // 全角ASCII記号・英数字
      if (r >= 0xFF01 && r <= 0xFF5E) {
        out.writeCharCode(r - 0xFEE0);
      }
      // 全角スペース -> 半角スペース
      else if (r == 0x3000) {
        out.writeCharCode(0x20);
      } else {
        out.writeCharCode(r);
      }
    }
    return out.toString();
  }

  // ===============================================================
  // ===================== カナ変換（記号含む） ======================
  // ===============================================================
  // 半角の濁点/半濁点
  static const int _hwDakuten = 0xFF9E; // ﾞ
  static const int _hwHandakuten = 0xFF9F; // ﾟ

  // 半角カナ記号 -> 全角記号
  static const Map<int, int> _hwPunctToFw = {
    0xFF61: 0x3002, // ｡ -> 。
    0xFF62: 0x300C, // ｢ -> 「
    0xFF63: 0x300D, // ｣ -> 」
    0xFF64: 0x3001, // ､ -> 、
    0xFF65: 0x30FB, // ･ -> ・
  };

  // 逆（全角記号 -> 半角記号）
  static const Map<int, int> _fwPunctToHw = {
    0x3002: 0xFF61, // 。 -> ｡
    0x300C: 0xFF62, // 「 -> ｢
    0x300D: 0xFF63, // 」 -> ｣
    0x3001: 0xFF64, // 、 -> ､
    0x30FB: 0xFF65, // ・ -> ･
  };

  // 半角カナ（ベース） -> 全角カナ
  static const Map<int, int> _hwKanaBaseToFw = {
    0xFF66: 0x30F2, // ｦ -> ヲ
    0xFF67: 0x30A1, // ｧ -> ァ
    0xFF68: 0x30A3, // ｨ -> ィ
    0xFF69: 0x30A5, // ｩ -> ゥ
    0xFF6A: 0x30A7, // ｪ -> ェ
    0xFF6B: 0x30A9, // ｫ -> ォ
    0xFF6C: 0x30E3, // ｬ -> ャ
    0xFF6D: 0x30E5, // ｭ -> ュ
    0xFF6E: 0x30E7, // ｮ -> ョ
    0xFF6F: 0x30C3, // ｯ -> ッ
    0xFF70: 0x30FC, // ｰ -> ー
    0xFF71: 0x30A2, // ｱ -> ア
    0xFF72: 0x30A4, // ｲ -> イ
    0xFF73: 0x30A6, // ｳ -> ウ
    0xFF74: 0x30A8, // ｴ -> エ
    0xFF75: 0x30AA, // ｵ -> オ
    0xFF76: 0x30AB, // ｶ -> カ
    0xFF77: 0x30AD, // ｷ -> キ
    0xFF78: 0x30AF, // ｸ -> ク
    0xFF79: 0x30B1, // ｹ -> ケ
    0xFF7A: 0x30B3, // ｺ -> コ
    0xFF7B: 0x30B5, // ｻ -> サ
    0xFF7C: 0x30B7, // ｼ -> シ
    0xFF7D: 0x30B9, // ｽ -> ス
    0xFF7E: 0x30BB, // ｾ -> セ
    0xFF7F: 0x30BD, // ｿ -> ソ
    0xFF80: 0x30BF, // ﾀ -> タ
    0xFF81: 0x30C1, // ﾁ -> チ
    0xFF82: 0x30C4, // ﾂ -> ツ
    0xFF83: 0x30C6, // ﾃ -> テ
    0xFF84: 0x30C8, // ﾄ -> ト
    0xFF85: 0x30CA, // ﾅ -> ナ
    0xFF86: 0x30CB, // ﾆ -> ニ
    0xFF87: 0x30CC, // ﾇ -> ヌ
    0xFF88: 0x30CD, // ﾈ -> ネ
    0xFF89: 0x30CE, // ﾉ -> ノ
    0xFF8A: 0x30CF, // ﾊ -> ハ
    0xFF8B: 0x30D2, // ﾋ -> ヒ
    0xFF8C: 0x30D5, // ﾌ -> フ
    0xFF8D: 0x30D8, // ﾍ -> ヘ
    0xFF8E: 0x30DB, // ﾎ -> ホ
    0xFF8F: 0x30DE, // ﾏ -> マ
    0xFF90: 0x30DF, // ﾐ -> ミ
    0xFF91: 0x30E0, // ﾑ -> ム
    0xFF92: 0x30E1, // ﾒ -> メ
    0xFF93: 0x30E2, // ﾓ -> モ
    0xFF94: 0x30E4, // ﾔ -> ヤ
    0xFF95: 0x30E6, // ﾕ -> ユ
    0xFF96: 0x30E8, // ﾖ -> ヨ
    0xFF97: 0x30E9, // ﾗ -> ラ
    0xFF98: 0x30EA, // ﾘ -> リ
    0xFF99: 0x30EB, // ﾙ -> ル
    0xFF9A: 0x30EC, // ﾚ -> レ
    0xFF9B: 0x30ED, // ﾛ -> ロ
    0xFF9C: 0x30EF, // ﾜ -> ワ
    0xFF9D: 0x30F3, // ﾝ -> ン
  };

  // 半角ベース + ﾞ/ﾟ -> 全角（合成結果）
  static const Map<int, int> _dakutenTarget = {
    0xFF73: 0x30F4, // ｳﾞ -> ヴ
    0xFF76: 0x30AC, // ｶﾞ
    0xFF77: 0x30AE, // ｷﾞ
    0xFF78: 0x30B0, // ｸﾞ
    0xFF79: 0x30B2, // ｹﾞ
    0xFF7A: 0x30B4, // ｺﾞ
    0xFF7B: 0x30B6, // ｻﾞ
    0xFF7C: 0x30B8, // ｼﾞ
    0xFF7D: 0x30BA, // ｽﾞ
    0xFF7E: 0x30BC, // ｾﾞ
    0xFF7F: 0x30BE, // ｿﾞ
    0xFF80: 0x30C0, // ﾀﾞ
    0xFF81: 0x30C2, // ﾁﾞ
    0xFF82: 0x30C5, // ﾂﾞ
    0xFF83: 0x30C7, // ﾃﾞ
    0xFF84: 0x30C9, // ﾄﾞ
    0xFF8A: 0x30D0, // ﾊﾞ
    0xFF8B: 0x30D3, // ﾋﾞ
    0xFF8C: 0x30D6, // ﾌﾞ
    0xFF8D: 0x30D9, // ﾍﾞ
    0xFF8E: 0x30DC, // ﾎﾞ
    // 拡張（希少）：ﾜﾞ/ｦﾞ
    0xFF9C: 0x30F7, // ﾜﾞ -> ヷ
    0xFF66: 0x30FA, // ｦﾞ -> ヺ
  };

  static const Map<int, int> _handakutenTarget = {
    0xFF8A: 0x30D1, // ﾊﾟ
    0xFF8B: 0x30D4, // ﾋﾟ
    0xFF8C: 0x30D7, // ﾌﾟ
    0xFF8D: 0x30DA, // ﾍﾟ
    0xFF8E: 0x30DD, // ﾎﾟ
  };

  /// 半角カナ・半角カナ記号・半角スペースを **全角** に変換
  static String toZenkakuKana(String text) {
    final codepoints = text.runes.toList();
    final out = StringBuffer();

    for (int i = 0; i < codepoints.length; i++) {
      final cp = codepoints[i];

      // 半角スペース -> 全角スペース
      if (cp == 0x20) {
        out.writeCharCode(0x3000);
        continue;
      }

      // 半角カナ記号 -> 全角記号
      final punct = _hwPunctToFw[cp];
      if (punct != null) {
        out.writeCharCode(punct);
        continue;
      }

      // 半角カナ + 濁点/半濁点（合成）
      final base = _hwKanaBaseToFw[cp];
      if (base != null) {
        final isLast = i == codepoints.length - 1;
        if (!isLast) {
          final mark = codepoints[i + 1];
          if (mark == _hwDakuten) {
            final voiced = _dakutenTarget[cp];
            if (voiced != null) {
              out.writeCharCode(voiced);
              i++; // ﾞを消費
              continue;
            }
          } else if (mark == _hwHandakuten) {
            final pvoiced = _handakutenTarget[cp];
            if (pvoiced != null) {
              out.writeCharCode(pvoiced);
              i++; // ﾟを消費
              continue;
            }
          }
        }
        // 合成なし
        out.writeCharCode(base);
        continue;
      }

      // 単独の ﾞ/ﾟ -> ゛/゜
      if (cp == _hwDakuten) {
        out.writeCharCode(0x309B);
        continue;
      }
      if (cp == _hwHandakuten) {
        out.writeCharCode(0x309C);
        continue;
      }

      // その他はそのまま
      out.writeCharCode(cp);
    }

    return out.toString();
  }

  // 全角カナ（ベース） -> 半角カナ
  static const Map<int, int> _fwKanaToHwBase = {
    // 小書き
    0x30A1: 0xFF67, // ァ
    0x30A3: 0xFF68, // ィ
    0x30A5: 0xFF69, // ゥ
    0x30A7: 0xFF6A, // ェ
    0x30A9: 0xFF6B, // ォ
    0x30E3: 0xFF6C, // ャ
    0x30E5: 0xFF6D, // ュ
    0x30E7: 0xFF6E, // ョ
    0x30C3: 0xFF6F, // ッ
    0x30FC: 0xFF70, // ー
    // ベース
    0x30A2: 0xFF71, // ア
    0x30A4: 0xFF72, // イ
    0x30A6: 0xFF73, // ウ
    0x30A8: 0xFF74, // エ
    0x30AA: 0xFF75, // オ
    0x30AB: 0xFF76, // カ
    0x30AD: 0xFF77, // キ
    0x30AF: 0xFF78, // ク
    0x30B1: 0xFF79, // ケ
    0x30B3: 0xFF7A, // コ
    0x30B5: 0xFF7B, // サ
    0x30B7: 0xFF7C, // シ
    0x30B9: 0xFF7D, // ス
    0x30BB: 0xFF7E, // セ
    0x30BD: 0xFF7F, // ソ
    0x30BF: 0xFF80, // タ
    0x30C1: 0xFF81, // チ
    0x30C4: 0xFF82, // ツ
    0x30C6: 0xFF83, // テ
    0x30C8: 0xFF84, // ト
    0x30CA: 0xFF85, // ナ
    0x30CB: 0xFF86, // ニ
    0x30CC: 0xFF87, // ヌ
    0x30CD: 0xFF88, // ネ
    0x30CE: 0xFF89, // ノ
    0x30CF: 0xFF8A, // ハ
    0x30D2: 0xFF8B, // ヒ
    0x30D5: 0xFF8C, // フ
    0x30D8: 0xFF8D, // ヘ
    0x30DB: 0xFF8E, // ホ
    0x30DE: 0xFF8F, // マ
    0x30DF: 0xFF90, // ミ
    0x30E0: 0xFF91, // ム
    0x30E1: 0xFF92, // メ
    0x30E2: 0xFF93, // モ
    0x30E4: 0xFF94, // ヤ
    0x30E6: 0xFF95, // ユ
    0x30E8: 0xFF96, // ヨ
    0x30E9: 0xFF97, // ラ
    0x30EA: 0xFF98, // リ
    0x30EB: 0xFF99, // ル
    0x30EC: 0xFF9A, // レ
    0x30ED: 0xFF9B, // ロ
    0x30EF: 0xFF9C, // ワ
    0x30F2: 0xFF66, // ヲ
    0x30F3: 0xFF9D, // ン
  };

  // 濁音/半濁音は分解して ﾍﾞｰｽ + ﾞ/ﾟ にする
  static const Map<int, List<int>> _fwVoicedToHwPair = {
    0x30F4: [0xFF73, 0xFF9E], // ヴ -> ｳﾞ
    0x30AC: [0xFF76, 0xFF9E], // ガ
    0x30AE: [0xFF77, 0xFF9E], // ギ
    0x30B0: [0xFF78, 0xFF9E], // グ
    0x30B2: [0xFF79, 0xFF9E], // ゲ
    0x30B4: [0xFF7A, 0xFF9E], // ゴ
    0x30B6: [0xFF7B, 0xFF9E], // ザ
    0x30B8: [0xFF7C, 0xFF9E], // ジ
    0x30BA: [0xFF7D, 0xFF9E], // ズ
    0x30BC: [0xFF7E, 0xFF9E], // ゼ
    0x30BE: [0xFF7F, 0xFF9E], // ゾ
    0x30C0: [0xFF80, 0xFF9E], // ダ
    0x30C2: [0xFF81, 0xFF9E], // ヂ
    0x30C5: [0xFF82, 0xFF9E], // ヅ
    0x30C7: [0xFF83, 0xFF9E], // デ
    0x30C9: [0xFF84, 0xFF9E], // ド
    0x30D0: [0xFF8A, 0xFF9E], // バ
    0x30D3: [0xFF8B, 0xFF9E], // ビ
    0x30D6: [0xFF8C, 0xFF9E], // ブ
    0x30D9: [0xFF8D, 0xFF9E], // ベ
    0x30DC: [0xFF8E, 0xFF9E], // ボ
    0x30D1: [0xFF8A, 0xFF9F], // パ
    0x30D4: [0xFF8B, 0xFF9F], // ピ
    0x30D7: [0xFF8C, 0xFF9F], // プ
    0x30DA: [0xFF8D, 0xFF9F], // ペ
    0x30DD: [0xFF8E, 0xFF9F], // ポ
    // 希少：ヷ/ヺ
    0x30F7: [0xFF9C, 0xFF9E], // ヷ -> ﾜﾞ
    0x30FA: [0xFF66, 0xFF9E], // ヺ -> ｦﾞ
  };

  /// 全角カナ・全角記号・全角スペースを **半角** に変換
  /// - 濁音/半濁音はﾍﾞｰｽ+ﾞ/ﾟに分解
  static String toHankakuKana(String text) {
    final out = StringBuffer();
    for (final cp in text.runes) {
      // 全角スペース -> 半角スペース
      if (cp == 0x3000) {
        out.writeCharCode(0x20);
        continue;
      }

      // 全角記号 -> 半角記号
      final hp = _fwPunctToHw[cp];
      if (hp != null) {
        out.writeCharCode(hp);
        continue;
      }

      // 濁音/半濁音を分解
      final pair = _fwVoicedToHwPair[cp];
      if (pair != null) {
        out.writeCharCode(pair[0]);
        out.writeCharCode(pair[1]);
        continue;
      }

      // ベース（小書き含む）を単体変換
      final hw = _fwKanaToHwBase[cp];
      if (hw != null) {
        out.writeCharCode(hw);
        continue;
      }

      // 発音記号 ゛/゜ -> ﾞ/ﾟ
      if (cp == 0x309B) {
        out.writeCharCode(_hwDakuten);
        continue;
      }
      if (cp == 0x309C) {
        out.writeCharCode(_hwHandakuten);
        continue;
      }

      // その他はそのまま
      out.writeCharCode(cp);
    }
    return out.toString();
  }
}
