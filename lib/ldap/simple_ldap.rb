class SimpleLDAP
  def self.authenticate(login, password, host, port, base, attributes = ['cn'])
    require 'ldap'
    connection = LDAP::Conn.new(host, port)
    connection.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
    result = nil
    begin
      bind_result = connection.bind("uid=#{login},#{base}", password)
      filter = "(uid=#{login})"
      bind_result.search(base, LDAP::LDAP_SCOPE_SUBTREE, filter, attributes) do |entry|
        result = entry.to_hash
      end
    rescue LDAP::Error, LDAP::ResultError
      return nil
    end
    connection.unbind
    return result
  end
   
  class Stub
    def self.authenticate(login, password, host = nil, port = nil, base = nil, attributes = ['cn'])
      return nil unless login == password
      data = {}
      for key in attributes
        data[key] = [login]
      end
      return data
    end
  end
end