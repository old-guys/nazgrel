module ShopEcn::Calculations
  def calculate(shop: )
    _shopkeeper = shop.shopkeeper
    _parent_shopkeeper = _shopkeeper.try(:parent)

    ancestry_rate = if _parent_shopkeeper.try(:descendant_size).to_i > 1
      _shopkeeper.descendant_size.to_f / _parent_shopkeeper.descendant_size.to_f
    else
      nil
    end

    {
      ecn_count: _shopkeeper.descendant_size,
      ancestry_rate: ancestry_rate,
      activation_rate: _shopkeeper.descendant_activation_rate,
      ecn_grade_platinum_count: _shopkeeper.descendant_grade_platinum_size,
      ecn_grade_gold_count: _shopkeeper.descendant_grade_gold_size,
      children_count: _shopkeeper.children_size,
      children_grade_platinum_count: _shopkeeper.children_grade_platinum_size,
      children_grade_gold_count: _shopkeeper.children_grade_gold_size,
      indirectly_descendant_count: _shopkeeper.indirectly_descendant_size,
      indirectly_descendant_grade_platinum_count: _shopkeeper.indirectly_descendant_grade_platinum_size,
      indirectly_descendant_grade_gold_count: _shopkeeper.indirectly_descendant_grade_gold_size
    }
  end
end