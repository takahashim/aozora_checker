class AozoraChecker
  class Char
    attr_reader :char

    def initialize(char)
      @char = char
    end

    def prefix
      ""
    end

    def postfix
      ""
    end

    def to_s
      prefix + @char + postfix
    end

    def ==(other)
      self.class == other.class && self.char == other.char
    end
  end

  class NormalChar < Char
  end

  class ControlChar < Char
    def prefix
      '<span class="red"> [ '
    end
    def postfix
      ' ] </span>'
    end
    def to_s
      prefix + sprintf("0x%x", @char.ord) + postfix
    end
  end

  class SpaceChar < Char
    def prefix
      '<span class="sp">'
    end
    def postfix
      '</span>'
    end
  end

  class ParChar < Char
    def prefix
      '<span class="par">'
    end
    def postfix
      '</span>'
    end
  end

  class AsciiChar < Char
    def prefix
      '<span class="ascii">'
    end
    def postfix
      '</span>'
    end
  end

  class InvalidChar < Char
    def prefix
      '<span class="invalid"> [ '
    end
    def postfix
      ' ] </span>'
    end
    def to_s
      prefix + sprintf("0x%x", @char.ord) + postfix
    end
  end

  class KanaChar < Char
    def prefix
      '<span class="kana">【'
    end
    def postfix
      '】（半角カナ）</span>'
    end
  end

  class KanaChar < Char
    def prefix
      '<span class="kana">【'
    end
    def postfix
      '】（半角カナ）</span>'
    end
  end

  class GaijiChar < Char
    def prefix
      '<span class="gaiji">[gaiji]【'
    end
    def postfix
      '】</span>'
    end
  end

  class FullWidthSpaceChar < Char
    def prefix
      '<span class="zsp">【'
    end
    def postfix
      '】（全角スペース）</span>'
    end
  end

  class SymbolChar < Char
    def prefix
      '<span class="symbol">'
    end
    def postfix
      '</span>'
    end
  end

  class Compat78Char < Char
    def prefix
      '<span class="compat78">[78]【'
    end
    def postfix
      '】（'+J78_HASH[@char] +'）</span>'
    end
  end

  class JyogaiChar < Char
    def prefix
      '<span class="jyogai">[jogai]【'
    end
    def postfix
      '】</span>'
    end
  end

  class Gonin1Char < Char
    def prefix
      '<span class="gonin">[gonin1]【'
    end
    def postfix
      '】（'+GONIN1_HASH[@char] +'）</span>'
    end
  end

  class Gonin2Char < Char
    def prefix
      '<span class="gonin">[gonin2]【'
    end
    def postfix
      '】（'+GONIN2_HASH[@char] +'）</span>'
    end
  end

  class Gonin3Char < Char
    def prefix
      '<span class="gonin">[gonin3]【'
    end
    def postfix
      '】（'+GONIN3_HASH[@char] +'）</span>'
    end
  end

  class KatakanaChar < Char
    def prefix
      '<span class="katakana">'
    end
    def postfix
      '</span>'
    end
  end

  class SubsumptionChar < Char
    def initialize(char, kutenmen)
      @char = char
      @kutenmen = kutenmen
    end
    def prefix
      '<span class="hosetsu">'
    end
    def postfix
      '→[hosetsu_tekiyo]【' + KUTENMEN_HOSETSU_TEKIYO[@kutenmen] + '】</span>'
    end
    def len
      @char.bytesize
    end
  end

  class Subsumption78Char < SubsumptionChar
    def postfix
      '→[78hosetsu_tekiyo]【' + KUTENMEN_78HOSETSU_TEKIYO[@kutenmen] + '】</span>'
    end
  end

end

