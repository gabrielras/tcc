# frozen_string_literal: true

class RoleTypes < EnumerateIt::Base
  associate_values(:administrator, :collaborator)
end
