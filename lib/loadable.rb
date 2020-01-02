module Loadable

  def load_objects(file_path)
      csv = CSV.read("#{file_path}", headers: true, header_converters: :symbol)
      csv.map do |row|
        self.new(row)
      end
  end

end