class Ability
  include Hydra::Ability

  include Hyrax::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions

    campus = "bakersfield" if current_user.email.include?("bakersfield.edu")
    campus = "chancellor" if current_user.email.include?("calstate.edu")
    campus = "channel" if current_user.email.include?("ci.edu")
    campus = "chico" if current_user.email.include?("chico.edu")
    campus = "dominguez" if current_user.email.include?("dh.edu")
    campus = "eastbay" if current_user.email.include?("eb.edu")
    campus = "fresno" if current_user.email.include?("fresno.edu")
    campus = "fullerton" if current_user.email.include?("fullerton.edu")
    campus = "humboldt" if current_user.email.include?("humboldt.edu")
    campus = "longbeach" if current_user.email.include?("lb.edu")
    campus = "losangeles" if current_user.email.include?("la.edu")
    campus = "maritime" if current_user.email.include?("csum.edu")
    campus = "mlml" if current_user.email.include?("mlml.edu")
    campus = "monterey" if current_user.email.include?("csumb.edu")
    campus = "northridge" if current_user.email.include?("csun.edu")
    campus = "pomona" if current_user.email.include?("cpp.edu")
    campus = "sacramento" if current_user.email.include?("sacramento.edu")
    campus = "sandiego" if current_user.email.include?("sdsu.edu")
    campus = "sanfrancisco" if current_user.email.include?("sf.edu")
    campus = "sanjose" if current_user.email.include?("sjsu.edu")
    campus = "sanluisobisbo" if current_user.email.include?("calpoly.edu")
    campus = "sanmarcos" if current_user.email.include?("sanmarcos.edu")
    campus = "sonoma" if current_user.email.include?("sonoma.edu")
    campus = "stanislaus" if current_user.email.include?("stanislaus.edu")

    user_groups.push(campus)

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
end
