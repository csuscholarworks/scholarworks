require 'rails_helper'

RSpec.feature Hyrax::CurationConcern do
  context 'a logged in user' do
    let(:admin_set) { AdminSet.create(title: ['Bakersfield']) }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(admin_set_id: admin_set.id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }

    subject(:actor) { described_class.actor }

    describe '#create' do
      let(:user_attributes) do
        { email: 'test@example.com' }
      end
      let(:user) do
        User.new(user_attributes) { |u| u.save(validate: false) }
      end

      let(:env) { Hyrax::Actors::Environment.new(work, ability, attributes) }
      let(:work) { Dataset.new }
      let(:ability) { Ability.new(user) }
      let(:attributes) do
        {
          admin_set_id: admin_set.id
        }
      end

      it 'should work' do
        expect{ actor.create(env)}.to change{ work.campus.to_a }.to(['Bakersfield'])
      end
    end
  end
end
