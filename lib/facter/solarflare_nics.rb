# frozen_string_literal: true

# This fact collects all NIC names with vendor matching 0x1924
Facter.add(:solarflare_nics) do
  confine :kernel do |value|
    value == 'Linux'
  end

  setcode do
    sf_nics = []

    Dir.entries('/sys/class/net').each do |dir|
      next if ['.', '..', 'lo'].include?(dir)

      vendor =
        begin
          File.read("/sys/class/net/#{dir}/device/vendor").chomp
        rescue StandardError
          # Ignore any errors
          nil
        end

      sf_nics << dir if vendor == '0x1924'
    end

    sf_nics
  end
end
