# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::CreateService, type: :service do
  context 'when quantity is present and greater than 0' do
    let(:quantity) { 1 }

    it 'creates new team' do
      result = described_class.call(quantity: quantity)

      expect(result.success?).to be_truthy
    end
  end

  context 'when quantity is not present' do
    it 'shouldn\'t create new team' do
      result = described_class.call

      expect(result.success?).to be_falsey
      expect(result.error).to eq('Quantity should be present or greater than 0')
    end
  end
end
