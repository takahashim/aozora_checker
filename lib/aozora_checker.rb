require "aozora_checker/version"
require "aozora_checker/char"
require "yaml"

class AozoraChecker

  ##########
  # 1-15-8,唖　1-15-80〜1-15-89に対しては、チェックを行わない。
  # 1-94-3,顛　1-94-30〜1-94-39に対しては、チェックを行わない。
  # 1-87-9,溌　1-87-90〜1-87-99に対しては、チェックを行わない。
  # 1-91-6,莱　1-91-60〜1-91-69に対しては、チェックを行わない。
  # 1-85-6,攅　1-85-60〜1-85-69に対しては、チェックを行わない。
  # 1-84-8,巣　1-84-80〜1-84-89に対しては、チェックを行わない。
  # 1-85-2,撃　1-85-20〜1-85-29に対しては、チェックを行わない。
  # 1-85-8,敏　1-85-80〜1-85-89に対しては、チェックを行わない。
  # 1-86-4,概　1-86-40〜1-86-49に対しては、チェックを行わない。
  # 1-87-5,漢　1-87-50〜1-87-59に対しては、チェックを行わない。
  # 1-88-5,琢　1-88-50〜1-88-59に対しては、チェックを行わない。
  # 1-89-3,研　1-89-30〜1-89-39に対しては、チェックを行わない。
  # 1-89-7,碑　1-89-70〜1-89-79に対しては、チェックを行わない。
  # 1-90-8,緑　1-90-80〜1-90-89に対しては、チェックを行わない。
  # 1-91-7,著　1-91-70〜1-91-79に対しては、チェックを行わない。
  # 1-94-4,類　1-94-40〜1-94-49に対しては、チェックを行わない。

  ### -----------------------------------------------------------------------

  attr_accessor :option

  def initialize(option = nil)
    if option
      @option = option
    else
      @option = {
        hosetsu78_tekiyo: true,
        hosetsu_tekiyo: true,
        gaiji: true,
        compat78: true,
        jyogai: true,
        gonin1: true,
        gonin2: true,
        gonin3: true,
      }
    end
    load_table(File.dirname(__FILE__)+"/chartable.json")
  end

  def load_table(path = "./checker.json")
    @table = YAML.load_file(path)
  end

  # JIS外字なら1を返す。引数は文字コード（シフトJIS）。
  def gaiji?(val)
    (0x81AD <= val && val <= 0x81B7 ||
     0x81C0 <= val && val <= 0x81C7 ||
     0x81CF <= val && val <= 0x81D9 ||
     0x81E9 <= val && val <= 0x81EF ||
     0x81F8 <= val && val <= 0x81FB ||
     0x8240 <= val && val <= 0x824E ||
     0x8259 <= val && val <= 0x825F ||
     0x827A <= val && val <= 0x8280 ||
     0x829B <= val && val <= 0x829E ||
     0x82F2 <= val && val <= 0x82FC ||
     0x8397 <= val && val <= 0x839E ||
     0x83B7 <= val && val <= 0x83BE ||
     0x83D7 <= val && val <= 0x83FC ||
     0x8461 <= val && val <= 0x846F ||
     0x8492 <= val && val <= 0x849E ||
     0x84BF <= val && val <= 0x84FC ||
     0x8540 <= val && val <= 0x859E ||
     0x859F <= val && val <= 0x85FC ||
     0x8640 <= val && val <= 0x869E ||
     0x869F <= val && val <= 0x86FC ||
     0x8740 <= val && val <= 0x879E ||
     0x879F <= val && val <= 0x87FC ||
     0x8840 <= val && val <= 0x889E ||
     0x9873 <= val && val <= 0x989E ||
     0xEAA5 <= val && val <= 0xEAFC ||
     0xEB40 <= val && val <= 0xEB9E ||
     0xEB9F <= val && val <= 0xEBFC ||
     0xEC40 <= val && val <= 0xEC9E ||
     0xEC9F <= val && val <= 0xECFC ||
     0xED40 <= val && val <= 0xED9E ||
     0xED9F <= val && val <= 0xEDFC ||
     0xEE40 <= val && val <= 0xEE9E ||
     0xEE9F <= val && val <= 0xEEFC ||
     0xEF40 <= val && val <= 0xEF9E ||
     0xEF9F <= val && val <= 0xEFFC || 
     0xF040 <= val && val <= 0xFCFC            # Extra
     )
  end

  SYMBOL_CHAR = "，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪†‡¶◯"
  FULLWIDTH_SPACE_CHAR = "　"
  FULLWIDTH_CHAR = "０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん"
  FULLWIDTH_KATAKANA_CHAR = "ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ"

  # ［＃「口＋亞」、第3水準1-15-8、144-上-9］
  # ↓
  # ［＃「口＋亞」、第3水準1-15-8、144-上-9］→[78hosetsu_tekiyo]【唖】
  #
  #［＃「にんべん＋曾」、第3水準1-14-41、144-上-9］
  # ↓
  #［＃「にんべん＋曾」、第3水準1-14-41、144-上-9］→[hosetsu_tekiyo]【僧】
  #
  # $bytesrefはテキストのバイト列へのリファレンス
  # $indexは'※'ではなく'［'の位置
  # 戻り値は (置換文字列, 使ったバイト数)
  def check_hosetsu_tekiyo(bytes, index)
    replace = nil
    s = make_utf8_string(bytes, index, 80)
    # print "1($s)\n";
    if /\A［＃.*?水準(\d+\-\d+\-\d+).*?］/ =~ s
      kutenmen = $1
      match = $&
      # print "2($kutenmen)\n";
      # print "2($match)\n";
      if @table["KUTENMEN_78HOSETSU_TEKIYO"][kutenmen]
        replace = Subsumption78Char.new(match,
                                        @table["KUTENMEN_78HOSETSU_TEKIYO"][kutenmen])
        # print "3($replace)\n";
      elsif @table["KUTENMEN_HOSETSU_TEKIYO"][kutenmen]
        replace = SubsumptionChar.new(match,
                                      @table["KUTENMEN_HOSETSU_TEKIYO"][kutenmen])
      end
    end
    replace
  end

  # チェッカ
  def do_check(text)
    # チェック結果を格納
    result = []

    if @option[:utf8]
      bytes = text.encode("cp932")
    else
      bytes = text
    end

    # 文字単位のループ
    size = bytes.bytesize
    i = 0
    while i < size
      # chとdhは文字（バイト単位）で、cとdは文字コード（数値）。
      c = bytes.getbyte(i)
      ch = c.chr
      if c == 0x0D || c == 0x0A       # 改行
        result << NormalChar.new(ch)
      elsif 0x00 <= c && c < 0x20     # コントロール文字(invalid)
        result << ControlChar.new(ch);
      elsif 0x20 <= c && c < 0x7F     # ASCII
        if ch == ' '
          result << SpaceChar.new(ch)
        elsif ch == '(' || ch == ')'
          result << ParChar.new(ch)
        else
          result << AsciiChar.new(ch)
        end
      elsif 0x7F <= c && c < 0x81     # invalid
        result << InvalidChar.new(ch)
      elsif 0xA0 <= c && c < 0xe0     # 半角カナ
        result << KanaChar.new(ch)
      elsif 0xfd <= c                 # invalid
        result << InvalidChar.new(ch)
      else
        i += 1
        d = bytes.getbyte(i)
        val = c * 256 + d
        chdh = val.chr("cp932").encode("utf-8")

        # [78hosetsu_tekiyo]
        if (@option[:hosetsu78_tekiyo] || @option[:hosetsu_tekiyo]) and chdh == '※'
          # print "(10)here";
          replace = check_hosetsu_tekiyo(bytes, i + 1)
          if replace && ((@option[:hosetsu78_tekiyo] and replace.kind_of?(Subsumption78Char)) ||
                         (@option[:hosetsu_tekiyo] and replace.kind_of?(SubsumptionChar)))
            result << replace
            i += replace.len
            next
          end
        end
        # NOT else

        if @option[:gaiji] and gaiji?(val)
          # JIS外字
          result << GaijiChar.new(chdh)
        ##elsif val == 0x8140
        elsif chdh == FULLWIDTH_SPACE_CHAR
          # 全角スペース
          result << FullWidthSpaceChar.new(chdh)
        ##elsif 0x8143 <= val && val < 0x824F
        elsif /[#{SYMBOL_CHAR}]/ =~ chdh
          # 記号
          result << SymbolChar.new(chdh)
        elsif @option[:compat78] and @table["J78"][chdh]
          # 78互換
          result << Compat78Char.new(chdh, @table["J78"][chdh])
        elsif @option[:jyogai] and @table["JYOGAI"][chdh]
          # 適用除外
          result << JyogaiChar.new(chdh, @table["JYOGAI"][chdh])
        elsif @option[:gonin1] and @table["GONIN1"][chdh]
          # 誤認(1)
          result << Gonin1Char.new(chdh, @table["GONIN1"][chdh])
        elsif @option[:gonin2] and @table["GONIN2"][chdh]
          # 誤認(2)
          result << Gonin2Char.new(chdh, @table["GONIN2"][chdh])
        elsif @option[:gonin3] and @table["GONIN3"][chdh]
          # 誤認(3)
          result << Gonin3Char.new(chdh, @table["GONIN3"][chdh])
        elsif /[#{FULLWIDTH_CHAR}]/ =~ chdh
          # 通常
          result << NormalChar.new(chdh)
        ##elsif 0x8340 <= val && val < 0x8397
        elsif /[#{FULLWIDTH_KATAKANA_CHAR}]/ =~ chdh
          # カタカナ
          result << KatakanaChar.new(chdh)
        else
          # 通常
          result << NormalChar.new(chdh)
        end
      end

      i += 1
    end
    result
  end

  def make_utf8_string(bytes, index, len)
    bytes.byteslice(index, len).encode("utf-8")
  end
end
