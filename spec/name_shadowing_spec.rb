require 'helper'

class SameName
  def self.find_by_token _token
    new
  end
end

module Namespaced
  class SameName
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
        include Hobby::Auth[SameName, Namespaced::SameName]
      end
    }.to raise_error Hobby::Auth::SameNames,
    'The short names of SameName and Namespaced::SameName are the same: SameName.'
  end
end
