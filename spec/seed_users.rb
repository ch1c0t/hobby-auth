class User
  @@all_users = []
  def initialize token
    @token = token
    @@all_users << self
  end
  attr_reader :token

  def self.find_by_token token
    @@all_users.find { |user| user.token == token && user.is_a?(self) }
  end
end

class Getter < User
end

module Namespaced
  class Poster < User
  end
end

Getter.new 'first valid getter token'
Getter.new 'second valid getter token'
Namespaced::Poster.new 'first valid poster token'
Namespaced::Poster.new 'second valid poster token'
