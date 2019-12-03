class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :brand
  has_many :images
  


  enum condition: {
    "---":0,
    新品、未使用:1,未使用に近い:2,目立った傷や汚れなし:3,
    やや傷や汚れあり:4,傷や汚れあり:5,全体的に状態が悪い:6
  }, _suffix: true

  enum days: {
    "---":0,
    １〜２日で発送:1,
    ２〜３日で発送:2,
    ４〜７日で発送:3,
  }, _suffix: true

  enum delivery_fee: {
    "---":0,
    送料込み（出品者負担）:1,
    着払い（購入者負担）:2,
  }, _suffix: true

  enum delivery_method: {
    "---":0,
    未定:1,
    らくらくメルカリ便:2,
    ゆうメール:3,
    レターパック:4,
    普通郵便（定形、定形外:5,
    クロネコヤマト:6,
    ゆうパック:7,
    クリックポスト:8,
    ゆうパケット:9

  }, _suffix: true

  scope :get_category_items, -> (category_id) {where(category_id: category_id)}



  def self.range(categories)
    start_id = categories.first.id
    last_id = categories.last.id
    Range.new(start_id, last_id)
  end

  def self.get_ladies
    children = Category.find_by(name: "レディース").children
    ladies_items = get_category_items(range(children))
  end
  
  def self.get_mens
    children = Category.find_by(name: "メンズ").children
    mens_items = get_category_items(range(children))
  end

  def self.get_electronics
    children = Category.find_by(name: "家電・スマホ・カメラ").children
    electronics_items = get_category_items(range(children))
  end

  def self.get_hobbies
    children = Category.find_by(name: "おもちゃ・ホビー・グッズ").children
    hobbies_items = get_category_items(range(children))
  end

  

end
