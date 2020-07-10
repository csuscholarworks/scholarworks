# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Dataset do
  describe '#visibility=' do
    before do
      subject.campus << 'bakersfield'
    end

    it 'supports "campus" visibility' do
      expect{ subject.visibility = 'campus' }.to change{ subject.read_groups }.to include('bakersfield')
    end

    it 'retains "campus" visibility' do
      expect{ subject.visibility = 'campus' }.to change{ subject.visibility }.to eq('campus')
    end

    it 'does not raise error' do
      expect { subject.visibility = 'campus' }.not_to raise_error
    end
  end
end
