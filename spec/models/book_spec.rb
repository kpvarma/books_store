require 'rails_helper'

RSpec.describe Book, type: :model do

  context "Validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :author }
    it { should validate_presence_of :isbn }

    it { should allow_value('My Experiments with Truth').for(:name)}
    it { should_not allow_value('xx').for(:name )}
    it { should_not allow_value("x"*257).for(:name )}

    it { should allow_value('Mahathma Gandhi').for(:author)}
    it { should_not allow_value('xx').for(:author )}
    it { should_not allow_value("x"*257).for(:author )}

    it { should allow_value('9781607960201').for(:isbn)}
    it { should_not allow_value('123456789').for(:isbn )}
    it { should_not allow_value('x'*33).for(:isbn )}
  end

end
