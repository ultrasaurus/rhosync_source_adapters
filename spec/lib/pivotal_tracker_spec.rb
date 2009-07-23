require File.dirname(__FILE__) + '/../../lib/pivotal_tracker'
require File.dirname(__FILE__) + '/../spec_helper'

require 'rubygems'
require 'fakeweb'

describe 'PivotalTracker' do

  describe 'when account is created' do
    it 'should login if credentials are good' do
      account = new_account
      account.should_not be_nil
    end
  end

  describe 'when getting data from the account' do
    before(:each) do
      @account = new_account
    end

    it 'should list projects' do
      FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v2/projects",
                           :body => <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<projects type="array">
  <project>
    <id>20829</id>
    <name>One</name>
    <iteration_length type="integer">1</iteration_length>
    <week_start_day>Monday</week_start_day>
    <point_scale>0,1,2,3,5,8</point_scale>
  </project>
  <project>
    <id>6529</id>
    <name>Two</name>
    <iteration_length type="integer">1</iteration_length>
    <week_start_day>Monday</week_start_day>
    <point_scale>0,1,2,3</point_scale>
  </project>
</projects>
                                  EOS
                            )
      p = @account.projects
      p.should_not be_nil
      p.length.should == 2
      p['20829'].should == {'name' => 'One'}
      p['6529'].should == {'name' => 'Two'}
    end

    it 'should list stories' do
      FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v2/projects/6529/stories",
                           :body => <<-EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <stories type="array" count="1" total="1">
      <story>
        <id type="integer">4</id>
        <story_type>feature</story_type>
        <url>http://www.pivotaltracker.com/story/show/STORY_ID</url>
        <estimate type="integer">1</estimate>
        <current_state>accepted</current_state>
        <description></description>
        <name>More power to shields</name>
        <requested_by>James Kirk</requested_by>
        <owned_by>Montgomery Scott</owned_by>
        <created_at type="datetime">2008/12/10 00:00:00 UTC</created_at>
        <accepted_at type="datetime">2008/12/10 00:00:00 UTC</accepted_at>
        <iteration>
          <number>3</number>
          <start type="datetime">2009/01/05 00:00:02 UTC</start>
          <finish type="datetime">2009/01/19 00:00:02 UTC</finish>
        </iteration>
        <labels>label 1,label 2,label 3</labels>
      </story>
    </stories>
                        EOS
                            )
      s = @account.stories(6529)
      s.should_not be_nil
      s.length.should == 1
      story = s['4']
      story.should_not be_nil
      story['story_type'].should == "feature"
      story['estimate'].should == "1"
      story['current_state'].should == "accepted"
      story['name'].should == "More power to shields"
      story['requested_by'].should == "James Kirk"
      story['owned_by'].should == "Montgomery Scott"
    end
  end

  private
  def new_account
    FakeWeb.register_uri(:get, "https://name:pass@www.pivotaltracker.com/services/tokens/active",
                         :body => <<-EOS
                                <?xml version="1.0" encoding="UTF-8"?>
                                <token>
                                  <guid>c93f12c71bec27843c1d84b3bdd547f3</guid>
                                  <id type="integer">1</id>
                                </token>
                                EOS
                          )

    PivotalTracker::Account.new("name", "pass")
  end
end