# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Dataset do
  describe '#visibility=' do
    it 'supports "campus" visibility' do
      expect{ subject.visibility = 'campus' }.to change{ subject.read_groups }.to include('sanfrancisco')
    end

    it 'retains "campus" visibility' do
      expect{ subject.visibility = 'campus' }.to change{ subject.visibility }.to eq('campus')
    end
  end
end
