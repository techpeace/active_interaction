require 'spec_helper'

describe ActiveInteraction::Pipeline do
  let(:invalid_interaction) do
    Class.new(TestInteraction) do
      float :a
      validates :a, inclusion: { in: [] }
      def execute; a end
    end
  end

  let(:square_interaction) do
    Class.new(TestInteraction) do
      float :a
      def execute; a ** 2 end
    end
  end

  let(:swap_interaction) do
    Class.new(TestInteraction) do
      float :a, :b
      def execute; { a: b, b: a } end
    end
  end

  it 'raises an error with no pipes' do
    pipeline = described_class.new
    expect {
      pipeline.run
    }.to raise_error ActiveInteraction::EmptyPipelineError
  end

  it 'returns an invalid outcome with one invalid pipe' do
    interaction = invalid_interaction
    pipeline = described_class.new do
      pipe interaction
    end

    options = { a: rand }
    expect(pipeline.run(options)).to be_invalid
  end

  it 'succeeds with one pipe' do
    interaction = swap_interaction
    pipeline = described_class.new do
      pipe interaction
    end

    options = { a: rand, b: rand }
    expect(pipeline.run(options).result).to eq(a: options[:b], b: options[:a])
  end

  it 'succeeds with two pipes' do
    interaction = swap_interaction
    pipeline = described_class.new do
      pipe interaction
      pipe interaction
    end

    options = { a: rand, b: rand }
    expect(pipeline.run(options).result).to eq options
  end

  it 'succeeds with an implicit transformation' do
    interaction = square_interaction
    pipeline = described_class.new do
      pipe interaction
    end

    options = { a: rand }
    expect(pipeline.run(options).result).to eq options[:a] ** 2
  end

  it 'succeeds with a symbolic transformation' do
    interaction = square_interaction
    pipeline = described_class.new do
      pipe interaction, :a
    end

    options = rand
    expect(pipeline.run(options).result).to eq options ** 2
  end

  it 'succeeds with a lambda transformation' do
    interaction = square_interaction
    pipeline = described_class.new do
      pipe interaction, -> result { { a: 2 * result } }
    end

    options = rand
    expect(pipeline.run(options).result).to eq (2 * options) ** 2
  end

  describe '#run!' do
    it 'raises an error with one invalid pipe' do
      interaction = invalid_interaction
      pipeline = described_class.new do
        pipe interaction
      end

      options = { a: rand }
      expect {
        pipeline.run!(options)
      }.to raise_error ActiveInteraction::InvalidInteractionError
    end

    it 'returns the outcome with one valid pipe' do
      interaction = square_interaction
      pipeline = described_class.new do
        pipe interaction
      end

      options = { a: rand }
      expect(pipeline.run!(options)).to eq options[:a] ** 2
    end
  end
end
