# frozen_string_literal: true

# This fact collects all adapter names with vendor matching 0x1924 and group them
# by their PCI bus position. Returns Array of Arrays (one Array per card).
Facter.add(:solarflare_adapters) do
  confine :kernel do |value|
    value == 'Linux'
  end

  setcode do
    # This is Hash[String, Array], so always initialize values to []
    sf_nics = Hash.new { |h, k| h[k] = [] }

    Dir.entries('/sys/class/net').each do |dir|
      next if ['.', '..', 'lo'].include?(dir)

      vendor =
        begin
          File.read("/sys/class/net/#{dir}/device/vendor").chomp
        rescue StandardError
          # Ignore any errors
          nil
        end

      next unless vendor == '0x1924'

      bus_id =
        begin
          f = File.basename(File.readlink("/sys/class/net/#{dir}/device"))
          f.split(':')[0..-2]
        rescue StandardError
          # Ignore any errors
          nil
        end

      sf_nics[bus_id] << dir
    end

    # We just need Array of Arrays, nobody cares about PCI bus ID
    sf_nics.values
  end
end
