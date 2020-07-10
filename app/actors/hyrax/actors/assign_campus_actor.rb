module Hyrax
  module Actors
    class AssignCampusActor < Hyrax::Actors::AbstractActor

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        admin_set_id = env.attributes[:admin_set_id]
        admin_set_title = AdminSet.find(admin_set_id).title.first
        env.curation_concern.assign_campus(admin_set_title) && next_actor.create(env)
      end
    end
  end
end
