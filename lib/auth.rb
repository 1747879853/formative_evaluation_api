class Auth
  class << self
    def check(auth_name, user, relation: 'or', outer: {})
      # return true if Rails.env.development?
      
      auth_names = auth_name.strip.split(',').map(&:strip)
      auth_rules = user.auth_rules
      auth_rules = auth_rules.select{|rule| auth_names.include? rule.name }

      return false if auth_rules.empty?
      return false if auth_names.count>auth_rules.count && relation == 'and'

      return auth_rules.any?{|rule| check_rule(rule, outer)} if relation == 'or'
      return auth_rules.all?{|rule| check_rule(rule, outer)} if relation == 'and'
    end

    def getGroups(user)
      user.auth_groups.map(&:title).join(',')
    end

    private
    def check_rule(rule, outer={})
      return false if rule.status == 0
      return true if outer.blank?
      return true if rule.condition.blank?

      p = eval "lambda { #{rule.condition} }"
      p.call(outer)
    end
 end
end