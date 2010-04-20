require 'spec/spec_helper.rb'

describe Message do
  describe '#project_qty_request' do
    specify {Message.project_qty_request.should == "\002Q\003"}
  end

  describe '#project_qty_response' do
    specify {Message.project_qty_response(3).should == "\002N\0373\003"}
    specify {Message.project_qty_response(4).should == "\002N\0374\003"}
  end

  describe '#project_info_request' do
    specify {
      exp_msg = "#{Message::MSG_START}G#{Message::MSG_SEP}0#{Message::MSG_END}"
      Message.project_info_request(0).should == exp_msg
    }
  end

  describe '#project_info_response' do
    specify {
      exp_msg = "#{Message::MSG_START}I#{Message::MSG_SEP}pub#{Message::MSG_SEP}priv#{Message::MSG_END}"
      Message.project_info_response('pub', 'priv').should == exp_msg
    }
  end

  describe '#project_info_request!' do
    specify {
      exp_msg = [Message.project_info_request(0), Message.project_info_response('pub', 'priv')]
      Message.project_info_request!(0, 'pub', 'priv').should == exp_msg
    }
  end

  describe '#project_qty_request!' do
    specify {Message.project_qty_request!(3).should == ["\002Q\003", Message.project_qty_response(3)]}
  end

  describe '#project_status' do
    specify {
      expected = "#{Message::MSG_START}S#{Message::MSG_SEP}pub#{Message::MSG_SEP}R#{Message::MSG_END}"
      Message.project_status('pub', 'running').should == expected
    }

    specify {
      lambda {Message.project_status('pub', 'bad_status')}.should raise_error(ArgumentError)
    }
  end
end
