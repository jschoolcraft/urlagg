module Admin

  class FakeUser

    def id
      0
    end

    def can?(*args)
      true
    end

    def cannot?(*args)
      !can?(*args)
    end

    def is_root?
      true
    end

    def is_not_root?
      !is_root?
    end

    def resources
      Typus::Configuration.roles[role].compact
    end

    def role
      Typus.master_role
    end

    def name
    end

  end

end
