class Ability
  include Hydra::Ability

  include Hyrax::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    puts "****************** CUSTOM PERMISSIONS BEING CALLED YO **************"

    campus = current_user_campus
    user_groups.push(campus) if campus.present?

    # admin
    if current_user.admin?
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
    end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end

  private

  def current_user_campus
    campus = nil
    Hyrax::CampusService::CAMPUSES.each do |campus_info|
      if current_user.email.end_with?(*campus_info[:email_domains])
        campus = campus_info[:slug]
        break
      end
    end
    campus
  end
end
