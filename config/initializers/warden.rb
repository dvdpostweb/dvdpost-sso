module Warden

  class SessionSerializer
    def deserialize(keys)
      klass, id = keys

      if klass.is_a?(Class)
        raise "Devise changed how it stores objects in session. If you are seeing this message, " <<
          "you can fix it by changing one character in your cookie secret, forcing all previous " <<
          "cookies to expire, or cleaning up your database sessions if you are using a db store."
      end
      # NOTE: Original line code. Notice that it uses an :id symbol. It doesn't respect the primary key that explicity defined in the model
      # klass.constantize.find(:first, :conditions => { :id => id })
      # NOTE: THIS IS THE FIX
      klass.constantize.find(:first, :conditions => { :customers_id => id })
    rescue NameError => e
      if e.message =~ /uninitialized constant/
        Rails.logger.debug "Trying to deserialize invalid class #{klass}"
        nil
      else
        raise
      end
    end
  end

end
