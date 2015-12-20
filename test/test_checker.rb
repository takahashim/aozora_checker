# encoding: utf-8
require 'test_helper'
require 'aozora_checker'

class AozoraCheckerTest < Test::Unit::TestCase
  def setup
    @checker = AozoraChecker.new
  end

  def test_gaiji_p
    assert_equal true, @checker.gaiji?(0x81AD)
    assert_equal false, @checker.gaiji?(0x81AC)
    assert_equal false, @checker.gaiji?("あ".encode("shift_jis").ord)
  end

  def test_check_hosetsu_tekiyo_ascii
    char = @checker.check_hosetsu_tekiyo("abc", 0)
    assert_equal nil, char
  end

  def test_make_utf8_string
    char = @checker.make_utf8_string("あいうえお".encode("cp932"), 2, 2)
    assert_equal "い", char.encode("utf-8")
    char = @checker.make_utf8_string("あいうえお".encode("cp932"), 2, 4)
    assert_equal "いう", char.encode("utf-8")
  end

  def test_check_hosetsu_tekiyo_kanji
    char = @checker.check_hosetsu_tekiyo("漢字".encode("cp932"), 0)
    assert_equal nil, char
  end

  def test_check_hosetsu_tekiyo_compat78
    char = @checker.check_hosetsu_tekiyo("※［＃「口＋亞」、第3水準1-15-8、144-上-9］".encode("cp932"), 2)
    assert_equal("<span class=\"hosetsu\">［＃「口＋亞」、第3水準1-15-8、144-上-9］→[78hosetsu_tekiyo]【唖】</span>",
                 char.to_html)
    assert_equal 55, char.len
  end

  def test_check_hosetsu_tekiyo_compat
    char = @checker.check_hosetsu_tekiyo("※［＃「にんべん＋曾」、第3水準1-14-41、144-上-9］".encode("cp932"), 2)
    assert_equal("<span class=\"hosetsu\">［＃「にんべん＋曾」、第3水準1-14-41、144-上-9］→[hosetsu_tekiyo]【僧】</span>",
                 char.to_html)
    assert_equal 65, char.len
  end

  def test_do_check
    @checker.option[:utf8] = true
    result = @checker.do_check("テスト A　z")
    expected = [AozoraChecker::KatakanaChar.new("テ"),
                AozoraChecker::KatakanaChar.new("ス"),
                AozoraChecker::Gonin1Char.new("ト"),
                AozoraChecker::SpaceChar.new(" "),
                AozoraChecker::AsciiChar.new("A"),
                AozoraChecker::FullWidthSpaceChar.new("　"),
                AozoraChecker::AsciiChar.new("z")
             ]
    assert_equal expected, result
  end

  def test_do_check_str
    @checker.option[:utf8] = true
    result = @checker.do_check("テスト A　z").map{|ch| ch.to_html}.join("")
    expected = "<span class=\"katakana\">テ</span><span class=\"katakana\">ス</span><span class=\"gonin\">[gonin1]【ト】（カタカナ）</span><span class=\"sp\"> </span><span class=\"ascii\">A</span><span class=\"zsp\">【　】（全角スペース）</span><span class=\"ascii\">z</span>"
    assert_equal expected, result
  end
end
