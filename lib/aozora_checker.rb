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

  # [78hosetsu_tekiyo]78互換包摂の対象となる不要な外字注記をチェックする
  KUTENMEN_78HOSETSU_TEKIYO = {
    '1-15-8' => '唖',
    '1-87-49' => '焔',
    '1-94-69' => '鴎',
    '1-15-26' => '噛',
    '1-14-26' => '侠',
    '1-92-42' => '躯',
    '1-94-74' => '鹸',
    '1-94-79' => '麹',
    '1-47-64' => '屡',
    '1-90-22' => '繍',
    '1-91-22' => '蒋',
    '1-92-89' => '醤',
    '1-91-66' => '蝉',
    '1-84-86' => '掻',
    '1-94-20' => '騨',
    '1-89-73' => '箪',     # 二バイト目が \ 
    '1-84-89' => '掴',
    '1-15-56' => '填',
    '1-94-3' => '顛',
    '1-89-35' => '祷',
    '1-87-29' => '涜',
    '1-15-32' => '嚢',
    '1-87-9' => '溌',
    '1-92-90' => '醗',
    '1-93-90' => '頬',
    '1-94-80' => '麺',
    '1-91-6' => '莱',
    '1-91-71' => '蝋',
    '1-85-6' => '攅'
  }

  # [hosetsu_tekiyo]包摂の対象となる不要な外字注記をチェックする
  KUTENMEN_HOSETSU_TEKIYO = {
    '1-14-24' => '侮',
    '1-14-28' => '併',
    '1-14-41' => '僧',
    '1-14-48' => '免',
    '1-14-67' => '勉',
    '1-14-72' => '勤',
    '1-14-78' => '卑',
    '1-14-81' => '即',
    '1-15-12' => '喝',
    '1-15-15' => '嘆',
    '1-15-22' => '器',
    '1-15-55' => '塚',
    '1-15-58' => '塀',
    '1-15-61' => '増',
    '1-15-62' => '墨',
    '1-47-58' => '寛',
    '1-47-65' => '層',
    '1-84-8' => '巣',
    '1-84-14' => '廊',
    '1-84-36' => '徴',
    '1-84-37' => '徳',
    '1-84-48' => '悔',
    '1-84-60' => '慨',
    '1-84-62' => '憎',
    '1-84-65' => '懲',
    '1-84-67' => '戻',
    '1-84-83' => '掲',
    '1-85-2' => '撃',
    '1-85-8' => '敏',
    '1-85-11' => '既',
    '1-85-28' => '晩',
    '1-85-35' => '暑',
    '1-85-39' => '暦',
    '1-85-46' => '朗',
    '1-85-69' => '梅',
    '1-86-4' => '概',
    '1-86-16' => '横',
    '1-86-27' => '欄',
    '1-86-35' => '歩',
    '1-86-37' => '歴',
    '1-86-41' => '殺',
    '1-86-42' => '毎',
    '1-86-73' => '海',
    '1-86-76' => '渉',
    '1-86-83' => '涙',
    '1-86-87' => '渚',
    '1-86-88' => '渇',
    '1-86-92' => '温',
    '1-87-5' => '漢',
    '1-87-30' => '瀬',
    '1-87-53' => '煮',
    '1-87-74' => '状',
    '1-87-79' => '猪',
    '1-88-5' => '琢',
    '1-88-39' => '瓶',
    '1-89-3' => '研',
    '1-89-7' => '碑',
    '1-89-19' => '社',
    '1-89-20' => '祉',
    '1-89-23' => '祈',
    '1-89-24' => '祐',
    '1-89-25' => '祖',
    '1-89-27' => '祝',
    '1-89-28' => '神',
    '1-89-29' => '祥',
    '1-89-31' => '禍',
    '1-89-32' => '禎',
    '1-89-33' => '福',
    '1-89-45' => '穀',
    '1-89-49' => '突',
    '1-89-68' => '節',
    '1-90-8' => '緑',
    '1-90-12' => '緒',
    '1-90-13' => '縁',
    '1-90-14' => '練',
    '1-90-19' => '繁',
    '1-90-26' => '署',
    '1-90-36' => '者',
    '1-90-56' => '臭',
    '1-91-7' => '著',
    '1-91-32' => '薫',
    '1-91-46' => '虚',
    '1-91-47' => '虜',
    '1-91-79' => '褐',
    '1-91-89' => '視',
    '1-92-14' => '諸',
    '1-92-15' => '謁',
    '1-92-16' => '謹',
    '1-92-24' => '賓',
    '1-92-26' => '頼',
    '1-92-29' => '贈',
    '1-92-57' => '逸',
    '1-92-71' => '郎',
    '1-92-74' => '都',
    '1-92-76' => '郷',
    '1-93-21' => '録',
    '1-93-27' => '錬',
    '1-93-61' => '隆',
    '1-93-67' => '難',
    '1-93-86' => '響',
    '1-93-91' => '頻',
    '1-94-4' => '類',
    '1-94-81' => '黄',
    '1-94-82' => '黒',
  }

  # 新JIS漢字で包摂規準の適用除外となる104字
  JYOGAI_HASH = {
    '侮'=>1,
    '併'=>1,
    '僧'=>1,
    '免'=>1,
    '勉'=>1,
    '勤'=>1,
    '卑'=>1,
    '即'=>1,
    '喝'=>1,
    '嘆'=>1,
    '器'=>1,
    '塚'=>1,
    '塀'=>1,
    '増'=>1,
    '墨'=>1,
    '寛'=>1,
    '層'=>1,
    '巣'=>1,
    '廊'=>1,
    '徴'=>1,
    '徳'=>1,
    '悔'=>1,
    '慨'=>1,
    '憎'=>1,
    '懲'=>1,
    '戻'=>1,
    '掲'=>1,
    '撃'=>1,
    '敏'=>1,
    '既'=>1,
    '晩'=>1,
    '暑'=>1,
    '暦'=>1,
    '朗'=>1,
    '梅'=>1,
    '概'=>1,
    '横'=>1,
    '欄'=>1,
    '歩'=>1,
    '歴'=>1,
    '殺'=>1,
    '毎'=>1,
    '海'=>1,
    '渉'=>1,
    '涙'=>1,
    '渚'=>1,
    '渇'=>1,
    '温'=>1,
    '漢'=>1,
    '瀬'=>1,
    '煮'=>1,
    '状'=>1,
    '猪'=>1,
    '琢'=>1,
    '瓶'=>1,
    '研'=>1,
    '碑'=>1,
    '社'=>1,
    '祉'=>1,
    '祈'=>1,
    '祐'=>1,
    '祖'=>1,
    '祝'=>1,
    '神'=>1,
    '祥'=>1,
    '禍'=>1,
    '禎'=>1,
    '福'=>1,
    '穀'=>1,
    '突'=>1,
    '節'=>1,
    '緑'=>1,
    '緒'=>1,
    '縁'=>1,
    '練'=>1,
    '繁'=>1,
    '署'=>1,
    '者'=>1,
    '臭'=>1,
    '著'=>1,
    '薫'=>1,
    '虚'=>1,
    '虜'=>1,
    '褐'=>1,
    '視'=>1,
    '諸'=>1,
    '謁'=>1,
    '謹'=>1,
    '賓'=>1,
    '頼'=>1,
    '贈'=>1,
    '逸'=>1,
    '郎'=>1,
    '都'=>1,
    '郷'=>1,
    '録'=>1,
    '錬'=>1,
    '隆'=>1,
    '難'=>1,
    '響'=>1,
    '頻'=>1,
    '類'=>1,
    '黄'=>1,
    '黒'=>1,
  }

  # 78互換文字
  J78_HASH = {
    '唖' => '第三水準1-15-8に',
    '焔' => '第三水準1-87-49に',
    '鴎' => '第三水準1-94-69に',
    '噛' => '第三水準1-15-26に',
    '侠' => '第三水準1-14-26に',
    '躯' => '第三水準1-92-42に',
    '鹸' => '第三水準1-94-74に',
    '麹' => '第三水準1-94-79に',
    '屡' => '第三水準1-47-64に',
    '繍' => '第三水準1-90-22に',
    '蒋' => '第三水準1-91-22に',
    '醤' => '第三水準1-92-89に',
    '蝉' => '第三水準1-91-66に',
    '掻' => '第三水準1-84-86に',
    '騨' => '第三水準1-94-20に',
    '箪' => '第三水準1-89-73に',
    '掴' => '第三水準1-84-89に',
    '填' => '第三水準1-15-56に',
    '顛' => '第三水準1-94-3に',
    '祷' => '第三水準1-89-35に',
    '涜' => '第三水準1-87-29に',
    '嚢' => '第三水準1-15-32に',
    '溌' => '第三水準1-87-9に',
    '醗' => '第三水準1-92-90に',
    '頬' => '第三水準1-93-90に',
    '麺' => '第三水準1-94-80に',
    '莱' => '第三水準1-91-6に',
    '蝋' => '第三水準1-91-71に',
    '攅' => '第三水準1-85-6に',
  }

  # 間違えやすい文字
  # かとうかおりさんの「誤認識されやすい文字リスト」から
  # http://plaza.users.to/katokao/digipr/digipr_charlist.html
  GONIN1_HASH = {
    'へ'=>'ひらがな',
    'べ'=>'ひらがなに濁点',
    'ぺ'=>'ひらがなに半濁点',
    'ヘ'=>'カタカナ',
    'ベ'=>'カタカナに濁点',
    'ペ'=>'カタカナに半濁点',
    'り'=>'ひらがな',
    'リ'=>'カタカナ',
    'タ'=>'カタカナ',
    '夕'=>'漢字の「ゆう」',
    'ニ'=>'カタカナ',
    '二'=>'漢字の「２」',
    'ト'=>'カタカナ',
    '卜'=>'漢字',
    'ー'=>'音引き',
    '−'=>'マイナス、全角ハイフン',
    '—'=>'ダーシ',
    '一'=>'漢字',
    '減'=>'ゲン・へ-る',
    '滅'=>'メツ・ほろ-ぶ）',
    '社'=>'シャ',
    '杜'=>'もり',
    '礼'=>'レイ',
    '札'=>'サツ',
    '刺'=>'シ・さ-す',
    '剌'=>'ラツ',
    '続'=>'ゾク',
    '統'=>'トウ',
    '持'=>'も-つ',
    '待'=>'ま-つ',
    '話'=>'はな-す',
    '語'=>'かた-る',
    '貧'=>'ヒン',
    '貪'=>'ドン',
    '崇'=>'あが-める',
    '祟'=>'たた-る',
    '撤'=>'テツ',
    '撒'=>'サン',
    '藉'=>'くさかんむり',
    '籍'=>'たけかんむり',
    '壺'=>'壷とは違う',
    '壷'=>'壺とは違う',
    '殻'=>'殼とは違う',
    '殼'=>'殻とは違う',
    '屋'=>'おく',
    '星'=>'ほし',
    '昔'=>'むかし',
    '音'=>'おと',
    '洒'=>'シャ',
    '酒'=>'さけ',
    '鳥'=>'とり',
    '烏'=>'からす',
    '鳴'=>'右側が「とり」',
    '嗚'=>'右側が「からす」',
    '日'=>'中にあるのは横棒一本',
    '目'=>'中にあるのは横棒二本',
    '白'=>'中にあるのは横棒一本',
    '自'=>'中にあるのは横棒二本',
    '問'=>'中にあるのは「くち」',
    '間'=>'中にあるのは「にち」',
    '句'=>'中にあるのは「くち」',
    '旬'=>'中にあるのは「にち」',
    '曖'=>'左側が「日」',
    '瞹'=>'左側が「目」',
    '味'=>'左側が「口」',
    '昧'=>'左側が「日」',
    '哂'=>'わら-う',
    '晒'=>'さら-す',
    '咋'=>'左側が「口」',
    '昨'=>'左側が「日」',
    '候'=>'「たてぼう」あり',
    '侯'=>'「たてぼう」なし',
    '治'=>'左側が「さんずい」',
    '冶'=>'左側が「にすい」',
  }

  # 誤認2
  GONIN2_HASH = {
    '冲'=>'にすい',
    '沖'=>'さんずい',
    '凉'=>'にすい',
    '涼'=>'さんずい',
    '冱'=>'にすい',
    '沍'=>'さんずい',
    '况'=>'にすい',
    '況'=>'さんずい',
    '凖'=>'にすい',
    '準'=>'さんずい',
    '凄'=>'にすい',
    '淒'=>'さんずい',
    '棉'=>'きへん',
    '綿'=>'いとへん',
    '篏'=>'嵌とは違う',
    '嵌'=>'篏とは違う',
    '戛'=>'戞とは違う',
    '戞'=>'戛とは違う',
    '厰'=>'廠とは違う',
    '廠'=>'厰とは違う',
    '圏'=>'圈とは違う',
    '圈'=>'圏とは違う',
    '富'=>'冨とは違う',
    '冨'=>'富とは違う',
    '曳'=>'曵とは違う',
    '曵'=>'曳とは違う',
    '奥'=>'奧とは違う',
    '奧'=>'奥とは違う',
    '稟'=>'禀とは違う',
    '禀'=>'稟とは違う',
    '凛'=>'凜とは違う',
    '凜'=>'凛とは違う',
    '穎'=>'頴とは違う',
    '頴'=>'穎とは違う',
    '達'=>'逹とは違う',
    '逹'=>'達とは違う',
    '冩'=>'寫とは違う',
    '寫'=>'冩とは違う',
    '舎'=>'舍とは違う',
    '舍'=>'舎とは違う',
    '抜'=>'拔とは違う',
    '拔'=>'抜とは違う',
    '腸'=>'膓とは違う',
    '膓'=>'腸とは違う',
    '恵'=>'惠とは違う',
    '惠'=>'恵とは違う',
    '専'=>'專とは違う',
    '專'=>'専とは違う',
    '穂'=>'穗とは違う',
    '穗'=>'穂とは違う',
    '苺'=>'莓とは違う',
    '莓'=>'苺とは違う',
    '銭'=>'錢とは違う',
    '錢'=>'銭とは違う',
    '賎'=>'賤とは違う',
    '賤'=>'賎とは違う',
    '妊'=>'姙とは違う',
    '姙'=>'妊とは違う',
    '俎'=>'爼とは違う',
    '爼'=>'俎とは違う',
    '戊'=>'戉とは違う',
    '戉'=>'戊とは違う',
    '戍'=>'戌とは違う',
    '戌'=>'戍とは違う',
    '参'=>'參とは違う',
    '參'=>'参とは違う',
    '惨'=>'慘とは違う',
    '慘'=>'惨とは違う',
    '憩'=>'憇とは違う',
    '憇'=>'憩とは違う',
    '剱'=>'劔や劒とは違う',
    '劔'=>'剱や劒とは違う',
    '劒'=>'剱や劔とは違う',
    '兎'=>'兔とは違う',
    '兔'=>'兎とは違う',
    '壌'=>'壤とは違う',
    '壤'=>'壌とは違う',
    '羮'=>'羹とは違う',
    '羹'=>'羮とは違う',
    '犠'=>'犧とは違う',
    '犧'=>'犠とは違う',
    '顔'=>'顏とは違う',
    '顏'=>'顔とは違う',
    '巌'=>'巖とは違う',
    '巖'=>'巌とは違う',
    '字'=>'宇とは違う',
    '宇'=>'字とは違う',
    '黙'=>'默とは違う',
    '默'=>'黙とは違う',
    '勲'=>'勳とは違う',
    '勳'=>'勲とは違う',
    '餅'=>'餠とは違う',
    '餠'=>'餅とは違う',
    '埒'=>'埓とは違う',
    '埓'=>'埒とは違う',
    '萌'=>'萠とは違う',
    '萠'=>'萌とは違う',
    '縦'=>'縱とは違う',
    '縱'=>'縦とは違う',
    '諌'=>'諫とは違う',
    '諫'=>'諌とは違う',
    '騒'=>'騷とは違う',
    '騷'=>'騒とは違う',
    '捜'=>'搜とは違う',
    '搜'=>'捜とは違う',
    '箆'=>'篦とは違う',
    '篦'=>'箆とは違う',
    '鴬'=>'鶯とは違う',
    '鶯'=>'鴬とは違う',
    '蛍'=>'螢とは違う',
    '螢'=>'蛍とは違う',
    '冊'=>'册とは違う',
    '册'=>'冊とは違う',
    '遥'=>'遙とは違う',
    '遙'=>'遥とは違う',
    '賛'=>'贊とは違う',
    '贊'=>'賛とは違う',
    '闘'=>'鬪とは違う',
    '鬪'=>'闘とは違う',
    '蓋'=>'葢とは違う',
    '葢'=>'蓋とは違う',
    '覇'=>'霸とは違う',
    '霸'=>'覇とは違う',
    '嘗'=>'甞とは違う',
    '甞'=>'嘗とは違う',
    '遡'=>'溯とは違う',
    '溯'=>'遡とは違う',
    '纖'=>'纎とは違う',
    '纎'=>'纖とは違う',
    '廏'=>'厩とは違う',
    '厩'=>'廏とは違う',
    '様'=>'樣とは違う',
    '樣'=>'様とは違う',
    '翻'=>'飜とは違う',
    '飜'=>'翻とは違う',
    '髄'=>'髓とは違う',
    '髓'=>'髄とは違う',
    '做'=>'傚とは違う',
    '傚'=>'做とは違う',
    '萩'=>'荻とは違う',
    '荻'=>'萩とは違う',
    '綱'=>'網とは違う',
    '網'=>'綱とは違う',
    '藤'=>'籐とは違う',
    '籐'=>'藤とは違う',
    '遺'=>'遣とは違う',
    '遣'=>'遺とは違う',
    '階'=>'楷とは違う',
    '楷'=>'階とは違う',
    '瞼'=>'臉とは違う',
    '臉'=>'瞼とは違う',
    '詫'=>'詑とは違う',
    '詑'=>'詫とは違う',
    '日'=>'曰とは違う',
    '曰'=>'日とは違う',
    '沁'=>'泌とは違う',
    '泌'=>'沁とは違う',
    '窟'=>'屈とは違う',
    '屈'=>'窟とは違う',
    '欲'=>'慾とは違う',
    '慾'=>'欲とは違う',
    '枉'=>'抂とは違う',
    '抂'=>'枉とは違う',
    '侘'=>'佗とは違う',
    '佗'=>'侘とは違う',
    '頑'=>'頬とは違う',
    '頬'=>'頑とは違う',
    '板'=>'坂とは違う',
    '坂'=>'板とは違う',
    '残'=>'銭とは違う',
    ## '銭'=>'残とは違う', ## duplicated?
    '囲'=>'固とは違う',
    '固'=>'囲とは違う',
    '追'=>'迫とは違う',
    '迫'=>'追とは違う',
    '貰'=>'貫とは違う',
    '貫'=>'貰とは違う',
    '妨'=>'坊とは違う',
    '坊'=>'妨とは違う',
    '罐'=>'鑵とは違う',
    '鑵'=>'罐とは違う',
    '罎'=>'壜とは違う',
    '壜'=>'罎とは違う',
    '鬱'=>'欝とは違う',
    '欝'=>'鬱とは違う',
    '鋭'=>'鈍とは違う',
    '鈍'=>'鋭とは違う',
    'エ'=>'工（こう）とは違う',
    '工'=>'エ（え）とは違う',
    'カ'=>'力（ちから）とは違う',
    '力'=>'カ（か）とは違う',
    'ソ'=>'ン（ん）とは違う',
    'ン'=>'ソ（そ）とは違う',
    'チ'=>'千（せん）とは違う',
    '千'=>'チ（ち）とは違う',
    'ヌ'=>'又（また）とは違う',
    '又'=>'ヌ（ぬ）とは違う',
    'ハ'=>'八（はち）とは違う',
    '八'=>'ハ（は）とは違う',
    'ム'=>'厶とは違う',
    '厶'=>'ム（む）とは違う',
    'ル'=>'儿とは違う',
    '儿'=>'ル（る）とは違う',
    'ロ'=>'口（くち）とは違う',
    '口'=>'ロ（ろ）とは違う',
  }

  # 誤認3
  # (砂場清隆さんの入力による)
  GONIN3_HASH = {
    # gonin1, gonin2 にあるものはコメントアウト
    '此'=>'比とは違う',
    '比'=>'此とは違う',
    '島'=>'しま',
    # '鳥'=>'とり',
    '束'=>'たば',
    '東'=>'ひがし',
    '関'=>'閑とは違う',
    '閑'=>'関とは違う',
    '的'=>'テキ・まと',
    '約'=>'ヤク',
    '譬'=>'辟／言',
    '警'=>'敬／言',
    '武'=>'式とは違う',
    '式'=>'シキ',
    '仕'=>'任とは違う',
    '任'=>'仕とは違う',
    # ［＃頻出するので使わない］ 'れ'=>'ひらがな',
    # '札'=>'ふだ・サツ',
    '出'=>'だ-す・で-る',
    '山'=>'やま',
    '千'=>'数字の1000',
    '下'=>'した',
    '干'=>'ほ-す',
    # '諫'=>'諌とは違う',
    # '諌'=>'諫とは違う',
    '嗇'=>'薔とは違う',
    '薔'=>'嗇とは違う',
    '折'=>'てへん',
    '析'=>'木へん',
    '綺'=>'糸へん',
    '椅'=>'木へん',
    '困'=>'囗＋木',
    '因'=>'囗＋大',
    '慣'=>'な-れる',
    '憤'=>'いきどお-る',
    '善'=>'ゼン・よ-い',
    '菩'=>'善とは違う',
    '子'=>'子供の子',
    '予'=>'予報の予',
    '看'=>'着とは違う',
    '着'=>'き-る',
    '練'=>'糸へん',
    '錬'=>'金へん',
    '機'=>'木へん',
    '幾'=>'機とは違う',
    '宜'=>'宣とは違う',
    '宣'=>'宜とは違う',
    '投'=>'な-げる',
    '技'=>'わざ',
    '柱'=>'はしら',
    '桂'=>'かつら',
    '容'=>'容器の容',
    '谷'=>'たに',
    '車'=>'くるま',
    '単'=>'ひと-つ・タン',
    # '烏'=>'からす',
    # '鳴'=>'右は鳥（トリ）',
    # '嗚'=>'右は烏（カラス）',
    '稍'=>'のぎへん',
    '梢'=>'木へん',
    '秒'=>'のぎへん',
    '杪'=>'木へん',
    '材'=>'材料の材',
    '村'=>'むら',
    # '板'=>'木のいた',
    '枚'=>'マイ',
    '使'=>'つか-う',
    '便'=>'たよ-り',
    '漲'=>'みなぎ-る',
    '振'=>'ふ-る',
    # '待'=>'ぎょうにんべん',
    '侍'=>'にんべん',
    # '持'=>'手へん',
    # '遣'=>'遺とは違う',
    # '遺'=>'遣とは違う',
    '井'=>'非とは違う',
    '非'=>'井とは違う',
    '眺'=>'目へん',
    '跳'=>'足へん',
    '開'=>'開閉の開',
    '聞'=>'中は耳',
    # '間'=>'中は日',
    '金'=>'かね・キン',
    '全'=>'すべ-て',
    '真'=>'真実の真',
    '其'=>'そ-れ',
    '微'=>'徴とは違う',
    '徴'=>'微とは違う',
    # '語'=>'右は吾',
    # '話'=>'右は舌',
    '銜'=>'中は金',
    '衛'=>'衡とは違う',
    '衡'=>'衛とは違う',
    '匕'=>'七とは違う',
    '七'=>'数字の7',
    '浸'=>'さんずい',
    '侵'=>'にんべん',
    # '音'=>'おと',
    # '昔'=>'むかし',
    # '目'=>'め',
    # '日'=>'にち',
    # '自'=>'自分の自',
    # '白'=>'色の白',
    '古'=>'ふる-い',
    '吉'=>'吉凶の吉',
    # '迫'=>'追とは違う',
    # '追'=>'迫とは違う',
    '殺'=>'ころ-す',
    '穀'=>'穀物の穀',
    '牙'=>'きば',
    '矛'=>'矛盾の矛・ほこ',
    '賢'=>'かしこ-い',
    '買'=>'買物の買',
    '鷲'=>'就／鳥',
    '鵞'=>'我／鳥',
    # '萩'=>'のぎへん・はぎ',
    # '荻'=>'けものへん・おぎ',
  }

  #
  #「自信」と「自身」
  #「更正」と「更生」、「往事」と「往時」、「受賞」と「授賞」
  #「萩原」と「荻原」


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
    load_config(File.dirname(__FILE__)+"/checker.json")
  end

  def load_config(path = "./checker.json")
    @config = YAML.load_file(path)
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
      if @config["KUTENMEN_78HOSETSU_TEKIYO"][kutenmen]
        replace = Subsumption78Char.new(match, kutenmen)
        # print "3($replace)\n";
      elsif @config["KUTENMEN_HOSETSU_TEKIYO"][kutenmen]
        replace = SubsumptionChar.new(match, kutenmen)
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
        elsif @option[:compat78] and @config["J78"][chdh]
          # 78互換
          result << Compat78Char.new(chdh)
        elsif @option[:jyogai] and @config["JYOGAI"][chdh]
          # 適用除外
          result << JyogaiChar.new(chdh)
        elsif @option[:gonin1] and @config["GONIN1"][chdh]
          # 誤認(1)
          result << Gonin1Char.new(chdh)
        elsif @option[:gonin2] and @config["GONIN2"][chdh]
          # 誤認(2)
          result << Gonin2Char.new(chdh)
        elsif @option[:gonin3] and @config["GONIN3"][chdh]
          # 誤認(3)
          result << Gonin3Char.new(chdh)
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
