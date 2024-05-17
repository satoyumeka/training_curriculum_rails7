class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    set_week_days
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end


  def getWeek
    wdays = ['(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)']

    @todays_date = Date.today

    # 今日の曜日を取得
    today_wday = wdays[@todays_date.wday]

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = (@todays_date + x).wday % 7 # 添字が7以上にならないようにする

      days = {
        month: (@todays_date + x).month,
        date: (@todays_date + x).day,
        plans: today_plans,
        wday: wdays[wday_num] # wdaysから曜日の値を取り出す
      }
      @week_days.push(days)
    end

    # 今日の曜日をビューで使えるようにインスタンス変数に保存
    @today_wday = today_wday

  end
end