# frozen_string_literal: true

require 'spec_helper'
require 'puppet'

describe 'solarflare_nics fact' do
  it do
    expect(Dir).to receive(:entries).with('/sys/class/net').and_return(['.', '..', 'lo', 'eno1', 'enp123s0f0', 'enp123s0f1'])
    expect(File).to receive(:read).with('/sys/class/net/eno1/device/vendor').and_return("0x8086\n")
    expect(File).to receive(:read).with('/sys/class/net/enp123s0f0/device/vendor').and_return("0x1924\n")
    expect(File).to receive(:read).with('/sys/class/net/enp123s0f1/device/vendor').and_return("0x1924\n")

    expect(Facter.fact(:solarflare_nics).value).to eq(['enp123s0f0', 'enp123s0f1'])
  end
end
