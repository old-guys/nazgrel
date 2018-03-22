module ShopkeeperStatusable
  extend ActiveSupport::Concern

  included do
    has_one :report_cumulative_shop_activity, through: :shop
  end

  def share_journal_count
    report_cumulative_shop_activity.try(:total_shared_count) || 0
  end

  def view_journal_count
    report_cumulative_shop_activity.try(:total_view_count) || 0
  end

  def descendant_size
    report_cumulative_shop_activity.try(:total_descendant_count) || 0
  end

  def descendant_activation_size
    report_cumulative_shop_activity.try(:total_descendant_activation_count) || 0
  end

  def descendant_activation_rate
    if descendant_size.to_f > 0
      descendant_activation_size / descendant_size.to_f
    else
      nil
    end
  end

  def children_grade_trainee_size
    @dchildren_grade_trainee_size ||= children.grade_trainee.size
  end

  def children_activation_grade_trainee_size
    @children_activation_grade_trainee_size ||= children.grade_trainee.activation.size
  end

  def children_inactivated_grade_trainee_size
    children_grade_trainee_size - children_activation_grade_trainee_size
  end

  def descendant_grade_trainee_size
    @descendant_grade_trainee_size ||= descendant_entities.grade_trainee.size
  end

  def descendant_activation_grade_trainee_size
    @descendant_activation_grade_trainee_size ||= descendant_entities.grade_trainee.activation.size
  end

  def descendant_inactivated_grade_trainee_size
    descendant_grade_trainee_size - descendant_activation_grade_trainee_size
  end

  def descendant_grade_platinum_size
    report_cumulative_shop_activity.try(:total_ecn_grade_platinum_count) || 0
  end

  def descendant_grade_gold_size
    report_cumulative_shop_activity.try(:total_ecn_grade_gold_count) || 0
  end

  def children_size
    report_cumulative_shop_activity.try(:total_children_count) || 0
  end

  def children_grade_platinum_size
    report_cumulative_shop_activity.try(:total_children_grade_platinum_count) || 0
  end

  def children_grade_gold_size
    report_cumulative_shop_activity.try(:total_children_grade_gold_count) || 0
  end

  def children_commission_income_amount
    report_cumulative_shop_activity.try(:total_children_commission_income_amount) || 0
  end

  def indirectly_descendant_size
    @indirectly_descendant_size ||= descendant_size - children_size
  end

  def indirectly_descendant_grade_platinum_size
    @indirectly_descendant_grade_platinum_size ||= descendant_grade_platinum_size - children_grade_platinum_size
  end

  def indirectly_descendant_grade_gold_size
    @indirectly_descendant_grade_gold_size ||= descendant_grade_gold_size - children_grade_gold_size
  end

  def descendant_order_number
    report_cumulative_shop_activity.try(:total_descendant_order_number) || 0
  end

  def descendant_order_amount
    report_cumulative_shop_activity.try(:total_descendant_order_amount) || 0
  end

  def descendant_commission_income_amount
    report_cumulative_shop_activity.try(:total_descendant_commission_income_amount) || 0
  end

  def indirectly_descendant_commission_income_amount
    descendant_commission_income_amount - children_commission_income_amount
  end

  private
  module ClassMethods
  end
end