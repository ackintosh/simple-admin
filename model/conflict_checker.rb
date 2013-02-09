# -*- encoding: utf-8 -*-
require 'my_drip'

class ConflictChecker
  def initialize
    @drip = MyDrip
  end

  def write(news_id, session_id)
    # ログ保存
    k,  = @drip.write(1, "newsid=#{news_id}", "sessionid=#{session_id}");
    return k
  end

  def conflict?(news_id, session_id)
    result_key = write(news_id, session_id)
    older_key = @drip.older(result_key, "newsid=#{news_id}")[0]

    # 直前のログが自分のセッションID -> 同時編集ではない
    return false if @drip[older_key][2] == "sessionid=#{session_id}"

    # 直前のログが別のセッションID且つ、指定したkeyよりも新しい場合、同時編集と判定
    return older_key > key_for_judgement
  end

  def key_for_judgement
    t = Time.now - 10
    "#{t.to_i}#{t.usec}".to_i
  end
end
