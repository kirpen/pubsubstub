module Pubsubstub
  class Event
    attr_reader :id, :name, :data

    def initialize(data, options = {})
      @id = options[:id] || time_now
      @name = options[:name]
      @data = data
    end

    def to_json
      {id: @id, name: @name, data: @data}.to_json
    end

    def to_message
      data = @data.split("\n").map{ |segment| "data: #{segment}" }.join("\n")
      message = "id: #{id}" << "\n"
      message << "event: #{name}" << "\n" if name
      message << data << "\n\n"
      message
    end

    def self.from_json(json)
      hash = JSON.load(json)
      new(hash['data'], name: hash['name'], id: hash['id'])
    end

    def ==(other)
      id == other.id && name == other.name && data == other.data
    end

    private
    def time_now
      (Time.now.to_f * 1000).to_i
    end
  end
end
