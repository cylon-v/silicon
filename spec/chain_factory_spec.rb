require 'spec_helper'
require 'silicon/chain'
require 'silicon/chain_factory'
require 'hypo'

RSpec.describe Silicon::ChainFactory do
  describe 'create' do
    it 'creates a chain' do
      silicon_config = {
        action: {
          async_timeout: 5
        }
      }

      component = double(:component)
      allow(component).to receive(:using_lifetime).and_return(component)
      allow(component).to receive(:bound_to).and_return(component)

      container = double(:container)
      allow(container).to receive(:register_instance).and_return(component)

      command1 = double(:command1)
      allow(command1).to receive(:name).and_return('command 1')

      command2 = double(:command2)
      allow(command2).to receive(:name).and_return('command 2')

      catch_command = double(:catch_command)
      allow(catch_command).to receive(:name).and_return('catch_command')


      route = double(:route)
      allow(route).to receive(:http_status).and_return(nil)
      allow(route).to receive(:http_verb).and_return('POST')
      allow(route).to receive(:commands).and_return([command1, command2])
      allow(route).to receive(:catch).and_return(catch_command)

      params = {id: 'some-id', name: 'a name'}
      match = double(:match)
      allow(match).to receive(:params).and_return(params)
      allow(match).to receive(:route).and_return(route)


      chain_factory = Silicon::ChainFactory.new(container, silicon_config)

      expect(container).to receive(:register_instance).with('some-id', :id)
      expect(container).to receive(:register_instance).with('a name', :name)
      expect(container).to receive(:register_instance).with(201, :silicon_status)

      expect(Silicon::Chain).to receive(:new).with(container, silicon_config, [command1, command2], catch_command)

      chain_factory.create(match)
    end
  end
end