SearchFilter.new('/moderation/:state/') do

  query do |query, state|
    query.add_sql_condition ModeratedFlag.conditions_for_view(state)
    query.add_flow_constraint :deleted if state == 'deleted'
  end

end


