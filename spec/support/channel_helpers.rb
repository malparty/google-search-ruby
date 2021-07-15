# frozen_string_literal: true

module ChannelHelpers
  def authenticate_cable(user)
    env = instance_double('env')

    warden = instance_double('warden', user: user)

    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(ApplicationCable::Connection).to receive(:env).and_return(env)
    # rubocop:enable RSpec/AnyInstance

    allow(env).to receive(:[]).with('warden').and_return(warden)
  end
end
