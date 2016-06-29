require 'rails_helper'

describe "Static pages" do

  subject { page }

  describe "About page" do

      before { visit about_path }
      it { should have_title('About') }

  end

  describe "Help page" do

      before { visit help_path }
      it { should  have_title('Help') }

  end

end