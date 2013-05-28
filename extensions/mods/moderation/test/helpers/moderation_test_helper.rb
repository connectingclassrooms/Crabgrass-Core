module ModerationTestHelper

  protected

  def assert_in_state(state, obj)
    assert_in_moderation state, obj
    assert_flagged_for(state)
  end

  def assert_flagged_for(state)
    @flag.reload
    assert_equal (state == :deleted), !!@flag.deleted_at
    assert_equal (state == :vetted), !!@flag.vetted_at
  end

  MODERATION_STATES = %W/new deleted vetted/

  def assert_in_moderation(expected, obj)
    MODERATION_STATES.each do |state|
      if state == expected.to_s
        assert find_in(state, obj), "Page should have shown up in #{expected}"
      else
        assert !find_in(state, obj),
          "Page expected in #{expected} should not have shown up in #{state}"
      end
    end
  end

  def find_in(state, obj)
    obj.class.find_by_path("/moderation/#{state}").include?(obj)
  end

end
