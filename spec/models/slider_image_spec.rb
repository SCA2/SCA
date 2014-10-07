require 'spec_helper'

describe SliderImage do
	before do
		@image = SliderImage.new(
			name: 'Big Chassis',
			caption: 'This is the awesome CH02 chassis',
			image_url: '/app/assets/images/CH02-1.jpg')
	end

	subject { @image }

	it { should respond_to(:name) }
	it { should respond_to(:caption) }
	it { should respond_to(:image_url) }

	it 'is valid with a name, caption, and image_url' do
		expect(subject).to be_valid
	end

	it 'is invalid without a name' do
		expect(SliderImage.new(name: nil)).to have(1).errors_on(:name)
	end

	it 'is invalid without a caption' do
		expect(SliderImage.new(caption: nil)).to have(1).errors_on(:caption)
	end

	it 'is invalid without an image_url' do
		expect(SliderImage.new(image_url: nil)).to have(1).errors_on(:image_url)
	end
end
