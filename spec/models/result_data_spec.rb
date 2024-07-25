require 'rails_helper'

RSpec.describe ResultData, type: :model do
  it 'is valid with valid attributes' do
    result = ResultData.new(subject: 'Science', timestamp: Time.now, marks: 85.25)
    expect(result).to be_valid
  end

  it 'is not valid without a subject' do
    result = ResultData.new(subject: nil, timestamp: Time.now, marks: 85.25)
    expect(result).to_not be_valid
  end
end
