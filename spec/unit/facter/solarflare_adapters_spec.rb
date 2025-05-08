# frozen_string_literal: true

require 'spec_helper'
require 'puppet'

describe 'solarflare_adapters fact' do
  let(:cards) do
    {
      enp123s0f0: {
        vendor: '0x1924',
        busid: '0000:82:00.0',
      },
      enp123s0f1: {
        vendor: '0x1924',
        busid: '0000:82:00.1',
      },
      enp124s0f0: {
        vendor: '0x1924',
        busid: '0000:83:00.0',
      },
      enp124s0f1: {
        vendor: '0x1924',
        busid: '0000:83:00.1',
      },
    }
  end

  before :each do
    # Make it testable on non-Linux also
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it do
    # Mock filesystem calls
    expect(Dir).to receive(:entries).with('/sys/class/net').and_return(['.', '..', 'lo', 'eth0'] + cards.keys.map(&:to_s))
    expect(File).to receive(:read).with('/sys/class/net/eth0/device/vendor').and_return('0x8086')
    cards.each do |nic, opts|
      expect(File).to receive(:read).with("/sys/class/net/#{nic}/device/vendor").and_return(opts[:vendor].to_s)
      expect(File).to receive(:readlink).with("/sys/class/net/#{nic}/device").and_return(opts[:busid].to_s)
    end

    expect(Facter.fact(:solarflare_adapters).value).to eq(
      [
        ['enp123s0f0', 'enp123s0f1'],
        ['enp124s0f0', 'enp124s0f1'],
      ],
    )
  end
end
