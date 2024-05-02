# frozen_string_literal: true

class MethodTypes < EnumerateIt::Base
  associate_values(:create, :update, :delete)
end
