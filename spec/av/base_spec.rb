require 'spec_helper'

describe Av::Commands::Base do
  let(:subject) { Av.cli }
  let(:source) { File.new(Dir.pwd + '/spec/support/assets/sample.mp4').path }
  
  describe '.identify' do
    let(:meta) { subject.identify source }
    
    it { expect(meta).to be_a Hash }
    it { expect(meta.keys).to include :size, :fps, :length, :aspect }
  end
  
  describe '.add_input_param' do
    before do
      subject.add_input_param({k: 'value'})
    end
    it { expect(subject.input_params.to_s).to eq '-k value' }
    context 'multiple calls' do
      before do
        subject.add_input_param({k: 'value1'})
        subject.add_input_param(:k, 'value2')
        subject.add_input_param([:x, 'y'])
      end
      it { expect(subject.input_params.to_s).to eq '-k value value1 value2 -x y' }
    end
  end

  describe '.add_output_param' do
    before do
      subject.add_output_param({k: 'value'})
    end
    it { expect(subject.output_params.to_s).to eq '-k value' }
    context 'multiple calls' do
      before do
        subject.add_output_param({k: 'value1'})
        subject.add_output_param(:k, 'value2')
        subject.add_output_param([:x, 'y'])
      end
      it { expect(subject.output_params.to_s).to eq '-k value value1 value2 -x y' }
    end
  end
  
  describe '.run' do
    before do
      subject.add_output_param(ar: 44100)
      subject.add_source(source)
      subject.add_destination(Tempfile.new(['one', '.ogv']).path)
    end
    it { expect { subject.run }.not_to raise_exception }
    
  end
end
