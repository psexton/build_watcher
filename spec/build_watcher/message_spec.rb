require 'spec/spec_helper.rb'

describe Message do
  describe '#project_qty_request' do
    specify {Message.project_qty_request.should == "\002Q\003"}
  end

  describe '#project_qty_response' do
    specify {Message.project_qty_response(3).should == "\002N\0373\003"}
    specify {Message.project_qty_response(4).should == "\002N\0374\003"}
  end

  describe '#project_info_message' do
    specify {
      exp_msg = "#{Message::ASCII_STX}I#{Message::ASCII_SEP}pub#{Message::ASCII_SEP}priv#{Message::ASCII_ETX}"
      Message.project_info_message('pub', 'priv').should == exp_msg
    }
  end

  describe '#project_qty_request!' do
    specify {Message.project_qty_request!(3).should == ["\002Q\003", Message.project_qty_response(3)]}
  end

  describe '#project_status' do
    specify {
      expected = "#{Message::ASCII_STX}S#{Message::ASCII_SEP}pub#{Message::ASCII_SEP}r#{Message::ASCII_ETX}"
      Message.project_status('pub', 'running').should == expected
    }

    specify {
      lambda {Message.project_status('pub', 'bad_status')}.should raise_error(ArgumentError)
    }
  end
end
