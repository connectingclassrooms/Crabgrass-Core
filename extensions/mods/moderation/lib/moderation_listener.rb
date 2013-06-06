class ModerationListener < Crabgrass::Hook::ViewListener
  include Singleton

  def group_permissions(context)
    return unless context[:group].council?
    return if context[:form].nil?
    f=context[:form]
    f.row do |r|
      r.label I18n.t(:moderation)
      r.checkboxes do |list|
        admins_may_moderate_checkbox(list)
      end
    end
  end
end
