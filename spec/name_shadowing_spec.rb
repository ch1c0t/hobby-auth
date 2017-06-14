require 'helper'

class Same
  def self.find_by_token _token
    new
  end
end

module Namespaced
  class Same
    def self.find_by_token _token
      new
    end
  end
end

describe Hobby::Auth do
  it 'raises an error when the short names are the same' do
    expect {
      Class.new do
        include Hobby
        include Hobby::Auth[Same, Namespaced::Same]
      end
    }.to raise_error Hobby::Auth::SameNames,
    'The short names of Same and Namespaced::Same are the same: same.'
  end
end
