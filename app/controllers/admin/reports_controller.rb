class Admin::ReportsController < Admin::ResourceController
  def index
    @day_link_count = TaggedLink.where(['created_at >= ?', 1.day.ago]).count
    @week_link_count = TaggedLink.where(['created_at >= ?', 1.week.ago]).count
    @month_link_count = TaggedLink.where(['created_at >= ?', 1.month.ago]).count
    @link_count = TaggedLink.count

    @day_user_count = User.where(['created_at >= ?', 1.day.ago]).count
    @week_user_count = User.where(['created_at >= ?', 1.week.ago]).count
    @month_user_count = User.where(['created_at >= ?', 1.month.ago]).count
    @user_count = User.count

    @day_tag_count = Tag.where(['created_at >= ?', 1.day.ago]).count
    @week_tag_count = Tag.where(['created_at >= ?', 1.week.ago]).count
    @month_tag_count = Tag.where(['created_at >= ?', 1.month.ago]).count
    @tag_count = Tag.count
  end
end