require 'spec_helper'

describe ActiveInteraction::ArrayFilter, :filter do
  include_context 'filters'
  it_behaves_like 'a filter'

  context 'with multiple nested filters' do
    let(:block) { Proc.new { array; array } }

    it 'raises an error' do
      expect { filter }.to raise_error ActiveInteraction::InvalidFilterError
    end
  end

  context 'with a nested name' do
    let(:block) { Proc.new { array :a } }

    it 'raises an error' do
      expect { filter }.to raise_error ActiveInteraction::InvalidFilterError
    end
  end

  context 'with a nested default' do
    let(:block) { Proc.new { array default: nil } }

    it 'raises an error' do
      expect { filter }.to raise_error ActiveInteraction::InvalidDefaultError
    end
  end

  describe '#cast' do
    context 'with an Array' do
      let(:value) { [] }

      it 'returns the Array' do
        expect(filter.cast(value)).to eq value
      end
    end

    context 'with a heterogenous Array' do
      let(:value) { [[], false, 0.0, {}, 0, '', :''] }

      it 'returns the Array' do
        expect(filter.cast(value)).to eq value
      end
    end

    context 'with a nested filter' do
      let(:block) { Proc.new { array } }

      context 'with an Array' do
        let(:value) { [] }

        it 'returns the Array' do
          expect(filter.cast(value)).to eq value
        end
      end

      context 'with an Array of Arrays' do
        let(:value) { [[]] }

        it 'returns the Array' do
          expect(filter.cast(value)).to eq value
        end
      end

      context 'with a heterogenous Array' do
        let(:value) { [[], false, 0.0, {}, 0, '', :''] }

        it 'raises an error' do
          expect{
            filter.cast(value)
          }.to raise_error ActiveInteraction::InvalidValueError
        end
      end
    end
  end
end
