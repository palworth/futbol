require 'csv'

module Loadable

  def load_objects(file_path, klass)
      csv = CSV.read("#{file_path}", headers: true, header_converters: :symbol)
      csv.map do |row|
        Object.const_get(klass).new(row)
      end
  end

end